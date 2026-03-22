local map = require("utils.map")

-- Plugins? (other keybinds are in the plugins lua files)

---------------------------------------------------------------------
-- TERMINAL MANAGEMENT
local focus_main_window = require("utils.focus_main_window")

-- Keymaps
map({ "n", "t" }, "<A-w>", function()
  focus_main_window()
  require("nvchad.term").toggle({
    pos = "float",
    id = "float_term",
  })
end, { desc = "Toggle Floating Terminal" })

-- THis is ahhh
map({ "n", "t" }, "<M-S-d>", function()
  local function is_process_running(name)
    local handle = io.popen("pgrep -x " .. name)
    if not handle then
      return false
    end
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
  end

  local function file_exists(file, dir)
    local path = dir .. "/" .. file
    local f = io.open(path, "r")
    if f ~= nil then
      f:close()
      return true
    end
    return false
  end

  local cwd = vim.fn.getcwd()

  if not is_process_running("dockerd") then
    vim.notify("dockerd is not running", vim.log.levels.WARN)
    return
  end

  if not file_exists("docker-compose.yml", cwd) then
    vim.notify("docker-compose.yml doesn't exist in CWD", vim.log.levels.WARN)
    return
  end

  focus_main_window()
  local term = require("nvchad.term")
  term.toggle({
    pos = "float",
    id = "lazydocker_float",
    float_opts = {
      row = 0.05,
      col = 0.05,
      width = 0.9,
      height = 0.8,
      border = "single",
    },
    cmd = "lazydocker",
  })

  -- map q to close/toggle the terminal (not LazyDocker)
  local buf = vim.api.nvim_get_current_buf()
  map("t", "q", function()
    term.toggle({ id = "lazydocker_float" })
  end, { buffer = buf })
end, { desc = "Toggle LazyDocker" })

map({ "n", "t" }, "<A-s>", function()
  focus_main_window()
  require("nvchad.term").toggle({
    pos = "sp",
    id = "horizontal_term",
    size = 0.5,
  })
end, { desc = "Toggle Horizontal Terminal" })

map({ "n", "t" }, "<A-v>", function()
  focus_main_window()
  require("nvchad.term").toggle({
    pos = "vsp",
    id = "vertical_term",
    size = 0.5,
  })
end, { desc = "Toggle Vertical Terminal" })

map("n", "<A-t>", function()
  vim.cmd("enew")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "New Terminal Buffer" })

---------------------------------------------------------------------
-- BUFFERS MANAGEMENT
local safe_buf_action = require("utils.safe_buf_action")

map("n", "<leader>n", "<cmd>enew<CR>", { desc = "Buffer new" })

-- change buffer
map(
  { "n", "v" },
  "<M-Right>",
  safe_buf_action(function()
    require("nvchad.tabufline").next()
  end),
  { desc = "Buffer goto next" }
)
map(
  { "n", "v" },
  "<M-Left>",
  safe_buf_action(function()
    require("nvchad.tabufline").prev()
  end),
  { desc = "Buffer goto prev" }
)

-- move buffer
map(
  { "n", "v" },
  "<C-M-Right>",
  safe_buf_action(function()
    require("nvchad.tabufline").move_buf(1)
  end),
  { desc = "move buffer to the right" }
)
map(
  { "n", "v" },
  "<C-M-Left>",
  safe_buf_action(function()
    require("nvchad.tabufline").move_buf(-1)
  end),
  { desc = "move buffer to the left" }
)

-- close buffer
map(
  "n",
  "<leader>q",
  safe_buf_action(function()
    require("nvchad.tabufline").close_buffer()
  end),
  { desc = "Buffer close" }
)

map(
  "n",
  "<M-q>",
  safe_buf_action(function()
    require("nvchad.tabufline").close_buffer()
  end),
  { desc = "Buffer close" }
)

map(
  "n",
  "<S-M-Q>",
  safe_buf_action(function()
    require("nvchad.tabufline").closeAllBufs(false)
  end),
  { desc = "Close all buffers except current" }
)

---------------------------------------------------------------------
-- NVCHAD I think

map("n", "<leader>vc", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })
map("n", "<leader>vt", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- UI
map("n", "<leader>um", "<cmd>Mason<CR>", { desc = "Mason UI" })
map("n", "<leader>ul", "<cmd>Lazy<CR>", { desc = "Lazy UI" })
map("n", "<leader>ui", "<cmd>MasonInstallAll<cr>", { desc = "Mason Install ALl" })

-- Keyboard users
map("n", "<C-t>", function()
  require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
map({ "n", "v" }, "<RightMouse>", function()
  require("menu.utils").delete_old_menus()

  vim.cmd.exec('"normal! \\<RightMouse>"')

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open(options, { mouse = true })
end, {})
