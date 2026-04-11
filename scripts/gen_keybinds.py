#!/usr/bin/env python3
"""
gen_keybinds.py — Scan all Lua files in this Neovim config and regenerate KEYBINDS.md.

Usage:
    python scripts/gen_keybinds.py

The script parses two patterns:
  1. vim.keymap.set(mode, key, ..., { desc = "..." }) — including local `map` aliases.
  2. Lazy.nvim `keys = { { "key", ..., desc = "...", mode = ... } }` table entries.

Output is written to KEYBINDS.md at the repo root.
"""

import os
import re
import sys
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

REPO_ROOT = Path(__file__).resolve().parent.parent
LUA_ROOT = REPO_ROOT / "lua"
OUTPUT = REPO_ROOT / "KEYBINDS.md"

# Map source file paths (relative to repo root) to human-readable section names.
# Files not listed here get an auto-generated section name.
SECTION_NAMES: dict[str, str] = {
    "lua/configs/mappings/custom.lua": "Editor (custom.lua)",
    "lua/configs/mappings/lsp.lua": "LSP (lsp.lua)",
    "lua/configs/mappings/plugins.lua": "Plugins — Buffers & UI (plugins.lua)",
    "lua/configs/mappings/git.lua": "Git (git.lua)",
    "lua/plugins/conform.lua": "Formatting — conform.nvim",
    "lua/plugins/copilot.lua": "AI / Copilot",
    "lua/plugins/fff.lua": "File Finder — fff.nvim",
    "lua/plugins/snacks.lua": "Pickers — snacks.nvim",
    "lua/configs/mappings/lsp.lua": "LSP (lsp.lua)",
    "lua/plugins/spectre.lua": "Search & Replace — spectre.nvim",
    "lua/plugins/todo.lua": "Todo Comments",
    "lua/plugins/nvim_tree.lua": "File Tree — nvim-tree",
    "lua/plugins/yazi.lua": "File Manager — yazi.nvim",
    "lua/plugins/whichkey.lua": "UI — which-key.nvim",
    "lua/plugins/markdown.lua": "Markdown",
    "lua/plugins/typescript_tools.lua": "TypeScript Tools",
    "lua/plugins/hover.lua": "Hover",
    "lua/plugins/illuminate.lua": "Illuminate — references",
    "lua/plugins/mark.lua": "Marks",
    "lua/plugins/matchup.lua": "Matchup — bracket jumping",
    "lua/plugins/dropbar.lua": "Dropbar — winbar symbols",
    "lua/plugins/gx.lua": "URL opener — gx.nvim",
}

# ---------------------------------------------------------------------------
# Data
# ---------------------------------------------------------------------------

@dataclass
class Keymap:
    key: str
    modes: list[str]
    desc: str
    source_file: str   # relative to repo root


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def normalize_mode(raw: str) -> list[str]:
    """Turn raw Lua mode value into a sorted list of single-char mode strings."""
    # strip quotes and whitespace
    raw = raw.strip().strip('"\'')
    if not raw:
        return ["n"]
    # could be a table like { "n", "v" } already expanded, or a single string
    return sorted(set(raw.split()))


def mode_table_to_list(lua_table: str) -> list[str]:
    """Parse a Lua table string like '{ "n", "v" }' into ['n', 'v']."""
    modes = re.findall(r'"([^"]+)"|\'([^\']+)\'', lua_table)
    result = []
    for a, b in modes:
        result.append(a or b)
    return sorted(set(result)) if result else ["n"]


def clean_key(k: str) -> str:
    return k.strip().strip('"\'')


def fmt_modes(modes: list[str]) -> str:
    return ", ".join(modes)


# ---------------------------------------------------------------------------
# Parsers
# ---------------------------------------------------------------------------

# Pattern for: map("n", "<key>", ..., { desc = "..." })
# or:          map({"n","v"}, "<key>", ..., { desc = "..." })
# The alias 'map' is resolved per file.
RE_MAP_CALL = re.compile(
    r'(?:vim\.keymap\.set|(?<!\w)map)\s*\(\s*'
    r'(?P<mode_part>\{[^}]*\}|"[^"]*"|\'[^\']*\')\s*,\s*'
    r'(?P<key>"[^"]*"|\'[^\']*\')'
    r'(?:.*?desc\s*=\s*"(?P<desc>[^"]*)")?',
    re.DOTALL,
)

# Pattern for lazy.nvim keys table entry:
# { "<key>", ..., desc = "...", mode = ... }
RE_KEY_FIRST = re.compile(r'^\s*(?P<key>"[^"]*"|\'[^\']*\')\s*,', re.DOTALL)


def _iter_table_entries(block: str):
    """Yield individual top-level { ... } entry strings from a Lua table block."""
    i = 0
    n = len(block)
    while i < n:
        # Find start of next entry
        while i < n and block[i] != '{':
            i += 1
        if i >= n:
            break
        start = i + 1
        depth = 1
        j = start
        # Skip over string literals so braces inside strings don't count
        while j < n and depth > 0:
            ch = block[j]
            if ch in ('"', "'"):
                q = ch
                j += 1
                while j < n:
                    if block[j] == '\\':
                        j += 2
                        continue
                    if block[j] == q:
                        break
                    j += 1
            elif ch == '[' and j + 1 < n and block[j + 1] == '[':
                # long string [[...]]
                j += 2
                while j < n:
                    if block[j] == ']' and j + 1 < n and block[j + 1] == ']':
                        j += 2
                        break
                    j += 1
                continue
            elif ch == '{':
                depth += 1
            elif ch == '}':
                depth -= 1
            j += 1
        yield block[start:j - 1]
        i = j

RE_DESC_IN_ENTRY = re.compile(r'desc\s*=\s*"([^"]*)"')
RE_MODE_IN_ENTRY = re.compile(r'mode\s*=\s*(?P<mode>\{[^}]*\}|"[^"]*"|\'[^\']*\')')


def parse_file(path: Path) -> list[Keymap]:
    """Extract all keymaps from a single Lua file."""
    text = path.read_text(encoding="utf-8", errors="replace")
    rel = str(path.relative_to(REPO_ROOT))
    keymaps: list[Keymap] = []
    seen: set[tuple] = set()

    def add(key: str, modes: list[str], desc: str) -> None:
        if not desc or not key:
            return
        key = clean_key(key)
        # Skip noisy ignore markers
        if "which_key_ignore" in desc:
            return
        sig = (key, tuple(modes), desc)
        if sig in seen:
            return
        seen.add(sig)
        keymaps.append(Keymap(key=key, modes=modes, desc=desc, source_file=rel))

    # --- Parse vim.keymap.set / map() calls ---
    for m in RE_MAP_CALL.finditer(text):
        mode_part = m.group("mode_part").strip()
        if mode_part.startswith("{"):
            modes = mode_table_to_list(mode_part)
        else:
            modes = [clean_key(mode_part)]

        key = m.group("key") or ""
        desc = m.group("desc") or ""
        add(key, modes, desc)

    # --- Parse keys = { { "key", ... } } lazy specs ---
    for block in _extract_keys_blocks(text):
        for entry in _iter_table_entries(block):
            km = RE_KEY_FIRST.match(entry)
            if not km:
                continue
            key = km.group("key")
            desc_m = RE_DESC_IN_ENTRY.search(entry)
            desc = desc_m.group(1) if desc_m else ""
            mode_m = RE_MODE_IN_ENTRY.search(entry)
            if mode_m:
                mv = mode_m.group("mode").strip()
                if mv.startswith("{"):
                    modes = mode_table_to_list(mv)
                else:
                    modes = [clean_key(mv)]
            else:
                modes = ["n"]
            add(key, modes, desc)

    return keymaps


def _extract_keys_blocks(text: str) -> list[str]:
    """Extract inner content of every `keys = { ... }` block using bracket counting."""
    blocks = []
    i = 0
    while i < len(text):
        m = re.search(r'\bkeys\s*=\s*\{', text[i:])
        if not m:
            break
        start = i + m.end()
        depth = 1
        j = start
        while j < len(text) and depth > 0:
            if text[j] == '{':
                depth += 1
            elif text[j] == '}':
                depth -= 1
            j += 1
        blocks.append(text[start:j - 1])
        i = start
    return blocks


def collect_all(root: Path) -> dict[str, list[Keymap]]:
    """Walk all lua files and return keymaps grouped by source file (rel path)."""
    grouped: dict[str, list[Keymap]] = {}
    for lua_file in sorted(root.rglob("*.lua")):
        rel = str(lua_file.relative_to(REPO_ROOT))
        # Skip chadrc / options / non-mapping configs that don't define user keys
        skip_patterns = [
            "lua/configs/options.lua",
            "lua/configs/autocmds.lua",
            "lua/configs/cmds.lua",
            "lua/configs/lazy.lua",
            "lua/configs/prompts.lua",
            "lua/configs/servers/",
            "lua/configs/providers/",
            "lua/utils/",
            "lua/chadrc.lua",
            "lua/plugins/treesitter.lua",
            "lua/plugins/cmp.lua",
            "lua/plugins/dashboard.lua",
            "lua/plugins/indentline.lua",
            "lua/plugins/surround.lua",
            "lua/plugins/autopairs",
            "lua/plugins/outline.lua",
            "lua/plugins/lspsaga.lua",  # only internal window keys, not global
            "lua/plugins/snacks.lua",   # picker window keys, not global binds
        ]
        if any(p in rel for p in skip_patterns):
            continue

        kms = parse_file(lua_file)
        if kms:
            grouped[rel] = kms
    return grouped


# ---------------------------------------------------------------------------
# Renderer
# ---------------------------------------------------------------------------

def section_name(rel: str) -> str:
    return SECTION_NAMES.get(rel, rel.replace("lua/", "").replace(".lua", "").replace("/", " — ").title())


def render_markdown(grouped: dict[str, list[Keymap]]) -> str:
    lines: list[str] = []
    lines.append("# Keybinds Reference")
    lines.append("")
    lines.append("> Auto-generated from source — run `python scripts/gen_keybinds.py` to update.")
    lines.append("")
    lines.append("`<leader>` is `Space`.  Modes: **n** = Normal, **i** = Insert, **v** = Visual, **t** = Terminal.")
    lines.append("")
    lines.append("---")
    lines.append("")

    # TOC
    lines.append("## Table of Contents")
    lines.append("")
    for rel in grouped:
        name = section_name(rel)
        anchor = name.lower()
        for ch in " &/().,'":
            anchor = anchor.replace(ch, "-")
        anchor = re.sub(r"-+", "-", anchor).strip("-")
        lines.append(f"- [{name}](#{anchor})")
    lines.append("")
    lines.append("---")
    lines.append("")

    for rel, kms in grouped.items():
        name = section_name(rel)
        lines.append(f"## {name}")
        lines.append("")
        lines.append(f"> Source: `{rel}`")
        lines.append("")
        lines.append("| Key | Mode | Description |")
        lines.append("|-----|------|-------------|")
        for km in kms:
            key_col = f"`{km.key}`"
            mode_col = fmt_modes(km.modes)
            lines.append(f"| {key_col} | {mode_col} | {km.desc} |")
        lines.append("")
        lines.append("---")
        lines.append("")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    print(f"Scanning Lua files under {LUA_ROOT} ...")
    grouped = collect_all(LUA_ROOT)
    total = sum(len(v) for v in grouped.values())
    print(f"Found {total} keymaps across {len(grouped)} files.")
    md = render_markdown(grouped)
    OUTPUT.write_text(md, encoding="utf-8")
    print(f"Written → {OUTPUT}")


if __name__ == "__main__":
    main()
