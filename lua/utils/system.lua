local M = {}

--- Checks if a process with the given name is currently running.
--- Uses `pgrep` to search for a process by its exact name.
--- @param name string: The name of the process to check.
--- @return boolean: `true` if the process is running, `false` otherwise.
function M.is_process_running(name)
  vim.fn.system({ "pgrep", "-x", name })
  return vim.v.shell_error == 0
end

--- Checks if a file exists in the specified directory.
--- Constructs the file path and uses `vim.fn.filereadable` to check.
--- @param file string: The name of the file to check.
--- @param dir string: The directory path to look in.
--- @return boolean: `true` if the file exists, `false` otherwise.
function M.is_file_exists(file, dir)
  local path = dir .. "/" .. file
  return vim.fn.filereadable(path) == 1
end

return M
