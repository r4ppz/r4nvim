local M = {}

--- Checks if a process with the given name is currently running.
--- Uses `pgrep` to search for a process by its exact name.
--- @param name string: The name of the process to check.
--- @return boolean: `true` if the process is running, `false` otherwise.
function M.is_process_running(name)
  local handle = io.popen("pgrep -x " .. name)
  if not handle then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end

--- Checks if a file exists in the specified directory.
--- Constructs the file path and attempts to open it in read mode.
--- @param file string: The name of the file to check.
--- @param dir string: The directory path to look in.
--- @return boolean: `true` if the file exists, `false` otherwise.
function M.is_file_exists(file, dir)
  local path = dir .. "/" .. file
  local f = io.open(path, "r")
  if f ~= nil then
    f:close()
    return true
  end
  return false
end

--- Checks if a directory exists in the specified current working directory.
--- Constructs the directory path and uses `lfs.attributes` to check.
--- @param dir string: The name of the directory to check.
--- @param cwd string: The current working directory path to look in.
--- @return boolean: `true` if the directory exists, `false` otherwise.
function M.is_dir_exist(dir, cwd)
  local path = cwd .. "/" .. dir
  local handle = io.popen("stat -c '%F' " .. path .. " 2>/dev/null")
  if not handle then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  return result:match("directory") ~= nil
end

return M
