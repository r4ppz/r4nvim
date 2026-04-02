local M = {}

function M.setup(capabilities)
  local config_dir = vim.fn.stdpath("config") .. "/lua/configs/servers"
  if vim.fn.isdirectory(config_dir) ~= 1 then
    return
  end

  local files = vim.fn.readdir(config_dir)
  for _, f in ipairs(files) do
    if f:match("%.lua$") and f ~= "init.lua" then
      local modname = f:gsub("%.lua$", "")
      local mod = require("configs.servers." .. modname)
      mod.setup(capabilities)
    end
  end
end

return M
