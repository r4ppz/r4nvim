# Keybinds Reference

> Auto-generated from source — run `python scripts/gen_keybinds.py` to update.

`<leader>` is `Space`.  Modes: **n** = Normal, **i** = Insert, **v** = Visual, **t** = Terminal.

---

## Table of Contents

- [Editor (custom.lua)](#editor-custom-lua)
- [Git (git.lua)](#git-git-lua)
- [LSP (lsp.lua)](#lsp-lsp-lua)
- [Plugins — Buffers & UI (plugins.lua)](#plugins-—-buffers-ui-plugins-lua)
- [Formatting — conform.nvim](#formatting-—-conform-nvim)
- [AI / Copilot](#ai-copilot)
- [Dropbar — winbar symbols](#dropbar-—-winbar-symbols)
- [File Finder — fff.nvim](#file-finder-—-fff-nvim)
- [Hover](#hover)
- [Illuminate — references](#illuminate-—-references)
- [Marks](#marks)
- [Markdown](#markdown)
- [Matchup — bracket jumping](#matchup-—-bracket-jumping)
- [File Tree — nvim-tree](#file-tree-—-nvim-tree)
- [Search & Replace — spectre.nvim](#search-replace-—-spectre-nvim)
- [Todo Comments](#todo-comments)
- [TypeScript Tools](#typescript-tools)
- [UI — which-key.nvim](#ui-—-which-key-nvim)
- [File Manager — yazi.nvim](#file-manager-—-yazi-nvim)

---

## Editor (custom.lua)

> Source: `lua/configs/mappings/custom.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<C-A-Up>` | n | Move line up |
| `<C-A-Down>` | n | Move line down |
| `<C-A-Up>` | v | Move selection up |
| `<C-A-Down>` | v | Move selection down |
| `<C-A-Up>` | i | Move selection up |
| `<C-A-Down>` | i | Move selection up |
| `<C-c>` | n | Copy whole file |
| `<C-a>` | n | Select all |
| `<M-Up>` | n | Insert above |
| `<M-Down>` | n | Insert below |
| `<M-Up>` | i | Insert above |
| `<M-Down>` | i | Insert below |
| `<M-a>` | n | Undo |
| `<M-a>` | i | Undo (Insert) |
| `<M-a>` | v | Undo (Visual) |
| `<M-d>` | n | Redo |
| `<M-d>` | i | Redo (Insert) |
| `<M-d>` | v | Redo (Visual) |
| `<S-Up>` | n | Scroll half a page up and center |
| `<S-Down>` | n | Scroll half a page down and center |
| `<S-Up>` | i | Scroll half a page up and center in insert mode |
| `<S-Down>` | i | Scroll half a page down and center in insert mode |
| `<C-Left>` | n, v | Move to the beginning of the word |
| `<C-Right>` | n, v | Move to the end of the word |
| `<C-Left>` | i | Move to the beginning of the word in insert mode |
| `<C-Right>` | i | Move to the end of the word in insert mode |
| `<S-Right>` | n, v | Move Right like E |
| `<S-Left>` | n, v | Move Left like B |
| `<S-Up>` | v | Jump to previous paragraph |
| `<S-Down>` | v | Jump to next paragraph |
| `<C-Down>` | n, v | Scroll window down one line |
| `<C-Up>` | n, v | Scroll window up one line |
| `<C-Down>` | i | Scroll window down one line in insert mode |
| `<C-Up>` | i | Scroll window up one line in insert mode |
| `<` | v | Indent left and reselect |
| `>` | v | Indent right and reselect |
| `<C-s>` | n | Save file |
| `<C-s>` | v | Save file |
| `<C-s>` | i | Save file |
| `<M-Esc>` | n | Clear highlights |
| `<C-q>` | t | Escape terminal mode |
| `<leader>/` | n | toggle comment |
| `<leader>/` | v | toggle comment |
| `!` | n, v | Jump to first non-blank character of the line |
| `@` | n, v | Jump to last non-blank character of line |
| `<leader>ob` | n, v | Get BufInfo |
| `<leader>oc` | n, v | Open Neovim Config |
| `<leader>ow` | n | Toggle line wrapping |
| `<C-r>` | n | Disable redo |
| `u` | n | Disable undo |
| `<C-z>` | n | Disable suspend |
| `ZZ` | n | Disable accidental save and quit (ZZ) |
| `ZQ` | n | Disable accidental quit (ZQ) |
| `s` | n, v | Substitute without yanking (visual) |
| `S` | n, v | Substitute line without yanking (normal) |
| `q` | n, v | Disable recording macro (q) |
| `Q` | n, v | Disable Ex mode (Q) |
| `p` | v | Paste without yanking replaced text |
| `c` | n, v | Change text without yanking |
| `d` | n, v | Delete without yanking |
| `D` | n, v | Delete to end of line without yanking |
| `X` | n | Cut line |
| `d` | n | Delete text without yanking |
| `#` | n | Highlight word (no jump, case-insensitive) |
| `#` | v | Highlight selection (no jump, case-insensitive) |
| `<leader>tn` | n | New tab |
| `<leader>tQ` | n | Close all other tabs |
| `<leader>tq` | n | Close tab |
| `<leader>t<Right>` | n | Next tab |
| `<leader>t<Left>` | n | Previous tab |
| `]t` | n | Next tab |
| `[t` | n | Previous tab |
| `<Tab>` | n | Next search match or Next Tab |
| `<S-Tab>` | n | Prev search match or Prev Tab |
| `<C-w><S-Left>` | n, v | Move window to the far left |
| `<C-w><S-Right>` | n, v | Move window to the far left |
| `<C-w><S-Down>` | n, v | Move window to the far left |
| `<C-w><S-Up>` | n, v | Move window to the far left |
| `<S-M-Down>` | n, v | Increase window height |
| `<S-M-Up>` | n, v | Decrease window height |
| `<S-M-Right>` | n, v | Decrease window width |
| `<S-M-Left>` | n, v | Increase window width |
| `<C-W>q` | n | Close window safely |

---

## Git (git.lua)

> Source: `lua/configs/mappings/git.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<M-g>` | n | Lazygit (Snacks) |
| `<leader>gg` | n | Lazygit (Snacks) |
| `]c` | n | Next Git Hunk (GitSign) |
| `[c` | n | Previous Git Hunk (GitSign) |
| `<leader>gs` | n | Stage Hunk (GitSign) |
| `<leader>gS` | n | Stage Buffer (GitSign) |
| `<leader>gr` | n | Reset Hunk (GitSign) |
| `<leader>gR` | n | Reset Buffer (GitSign) |
| `<leader>gP` | n | Preview Hunk (GitSign) |
| `<leader>gp` | n | Preview Hunk Inline (GitSign) |
| `<leader>gb` | n | Blame Line (GitSign) |
| `<leader>gd` | n | Open Diffview |
| `<leader>gh` | n | Open Diffview History (Diffview) |
| `<leader>gf` | n | Open Diffview Current File History Diffview |

---

## LSP (lsp.lua)

> Source: `lua/configs/mappings/lsp.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>Lr` | n | Restart LSP |
| `<leader>Li` | n | LSP Info |
| `<leader>Ls` | n | LSP Stop |
| `gR` | n | Find References (including def and imp) |
| `gr` | n | LSP References (Snacks) |
| `gd` | n | Goto [d]efinition (Snacks) |
| `gI` | n | Goto [I]mplementation (Snacks) |
| `gy` | n | Goto T[y]pe Definition (Snacks) |
| `ge` | n | Goto D[e]claration (Snacks) |
| `gD` | n | Peek Definition |
| `gT` | n | Peek Type Definition |
| `<S-C-Down>` | n | Peek Definition |
| `<leader>la` | n, v | Code Actions |
| `<leader>lr` | n | Rename Symbol |
| `[d` | n | Previous Diagnostic |
| `]d` | n | Next Diagnostic |
| `<leader>lD` | n | Show Line Diagnostics |
| `<leader>ld` | n | Show Buffer Diagnostics |
| `<leader>lw` | n | Show Workspace Diagnostics |
| `<leader>li` | n | Incoming Calls |
| `<leader>lo` | n | Outgoing Calls |
| `<leader>ls` | n | Toggle Outline |

---

## Plugins — Buffers & UI (plugins.lua)

> Source: `lua/configs/mappings/plugins.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>n` | n | Buffer new |
| `<M-Right>` | n, v | Buffer goto next |
| `<M-Left>` | n, v | Buffer goto prev |
| `<C-M-Right>` | n, v | move buffer to the right |
| `<C-M-Left>` | n, v | move buffer to the left |
| `<leader>q` | n | Buffer close |
| `<M-q>` | n | Buffer close |
| `<S-M-Q>` | n | Close all buffers except current |
| `<leader>vc` | n | toggle nvcheatsheet |
| `<leader>vt` | n | telescope nvchad themes |
| `<C-t>` | n | Mason UI |
| `<leader>ul` | n | Lazy UI |
| `<leader>ui` | n | Mason Install ALl |
| `<leader>uh` | n | Check Health |
| `<A-w>` | n, t | Toggle Floating Terminal |
| `<M-b>` | n, t | Toggle Btop |
| `<M-S-d>` | n, t | Toggle LazyDocker |
| `<A-s>` | n, t | Toggle Horizontal Terminal |
| `<A-v>` | n, t | Toggle Vertical Terminal |
| `<A-t>` | n | New Terminal Buffer |

---

## Formatting — conform.nvim

> Source: `lua/plugins/conform.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>of` | n | Format & Autofix File |

---

## AI / Copilot

> Source: `lua/plugins/copilot.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ci` | n, v | Check if code is idiomatic |
| `<leader>ce` | n, v | Explain code |
| `<leader>cs` | n, v | Suggest alternatives |
| `<leader>cm` | n, v | View/select available models |
| `<M-c>` | n, v | Toggle CopilotChat |
| `<leader>cp` | n, v | View/select prompt templates |
| `<leader>cb` | n, v | Open chat with current buffer |
| `<leader>cB` | n, v | Open chat with all buffers |
| `<leader>cf` | n, v | Add files to CopilotChat |
| `<C-S-M-Up>` | n, v | Explain hover with Copilot |

---

## Dropbar — winbar symbols

> Source: `lua/plugins/dropbar.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<Leader>;` | n | Pick symbols in winbar |
| `[;` | n | Go to start of current context |
| `];` | n | Select next context |

---

## File Finder — fff.nvim

> Source: `lua/plugins/fff.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<M-f>` | n | Find files (fff) |
| `<leader>ff` | n | Find files (fff) |
| `<leader>fg` | n | Live fuzzy grep (fff) |

---

## Hover

> Source: `lua/plugins/hover.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `K` | n | Hover (double tap enters docs) |
| `<S-C-Up>` | n | Hover (double tap enters docs) |

---

## Illuminate — references

> Source: `lua/plugins/illuminate.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `[r` | n | Prev reference |
| `]r` | n | Next reference |

---

## Marks

> Source: `lua/plugins/mark.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `;;` | n | Toggle next available mark |
| `` | n | Cycle next mark |
| `;X` | n | Delete all marks in buffer |
| `;D` | n | Delete all marks on line |

---

## Markdown

> Source: `lua/plugins/markdown.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>om` | n | Markdown preview |
| `<leader>or` | n | Toggle render-markdown |

---

## Matchup — bracket jumping

> Source: `lua/plugins/matchup.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `~` | n, v | Jump to matching pair |

---

## File Tree — nvim-tree

> Source: `lua/plugins/nvim_tree.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<ESC>` | n | fucking nothing |
| `<C-S-Up>` | n | Info |
| `<C-]>` | n | cd |
| `<C-[>` | n | cd .. |
| `<M-e>` | n | Toggle NvimTree |
| `<leader>a` | n | Add to CopilotChat |

---

## Search & Replace — spectre.nvim

> Source: `lua/plugins/spectre.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>S` | n | Toggle Spectre |
| `<leader>Sw` | n | Search current word |
| `<leader>Sw` | v | Search current word |
| `<leader>Sp` | n | Search on current file |

---

## Todo Comments

> Source: `lua/plugins/todo.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `]t` | n | Next todo comment |
| `[t` | n | Previous todo comment |

---

## TypeScript Tools

> Source: `lua/plugins/typescript_tools.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>lO` | n, v | TSTools Organize Imports |

---

## UI — which-key.nvim

> Source: `lua/plugins/whichkey.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>oW` | n | whichkey all keymaps |

---

## File Manager — yazi.nvim

> Source: `lua/plugins/yazi.lua`

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>e` | n | Open Yazi |

---
