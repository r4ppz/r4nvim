local win_util = require("utils.window")

local exclude_filetypes = {
  "NvimTree",
  "markdown",
  "gitcommit",
  "diff",
  "Lazy",
  "mason",
  "spectre_panel",
  "copilot-chat",
  "snacks_picker_input",
  "snacks_picker_preview",
  "snacks_picker_list",
  "snacks_dashboard",
}

local function has_valid_source(buf)
  return pcall(vim.treesitter.get_parser, buf)
    or not vim.tbl_isempty(vim.lsp.get_clients({
      bufnr = buf,
      method = "textDocument/documentSymbol",
    }))
end

return {
  "Bekaboo/dropbar.nvim",
  event = "BufReadPost",
  opts = {
    bar = {
      truncate = false,
      padding = { left = 2, right = 5 },
      enable = function(buf, win, _)
        return not win_util.is_ft_excluded(buf, exclude_filetypes)
          and win_util.is_buf_win_valid(buf, win)
          and win_util.is_win_standard(win)
          and has_valid_source(buf)
      end,
    },
    icons = {
      ui = {
        bar = {
          separator = " ",
          extends = "…",
        },
        menu = {
          separator = " ",
          indicator = " ",
        },
      },
    },
  },
  config = function(_, opts)
    require("dropbar").setup(opts)
    local dropbar_api = require("dropbar.api")
    local map = vim.keymap.set
    map("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    map("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    map("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
