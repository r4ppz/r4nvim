return {
  "nvim-mini/mini.surround",
  event = "BufReadPost",
  version = "*",
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "<leader>sa",
        delete = "<leader>sd",
        find = "<leader>sf",
        find_left = "<leader>sF",
        highlight = "<leader>sh",
        replace = "<leader>sr",
        suffix_last = "l",
        suffix_next = "n",
      },
      silent = true,
    })
  end,
}
