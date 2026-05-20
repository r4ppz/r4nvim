local cmd = vim.api.nvim_create_user_command

cmd("CopyPathAndLine", function()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" then
    vim.notify("No file name available for this buffer", vim.log.levels.WARN)
    return
  end

  local relative_path = vim.fn.fnamemodify(file_path, ":.")
  local result = ""

  local mode = vim.api.nvim_get_mode().mode

  if mode:match("^[vV\22]") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)

    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]

    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    if start_line == end_line then
      result = string.format("%s:%d", relative_path, start_line)
    else
      result = string.format("%s:%d-%d", relative_path, start_line, end_line)
    end
  else
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    result = string.format("%s:%d", relative_path, current_line)
  end

  vim.fn.setreg("+", result)
  vim.notify("Copied to clipboard: " .. result, vim.log.levels.INFO)
end, {})

cmd("ToggleBool", function()
  local word = vim.fn.expand("<cword>")
  local replacements = {
    ["true"] = "false",
    ["false"] = "true",
    ["on"] = "off",
    ["off"] = "on",
    ["1"] = "0",
    ["0"] = "1",
  }

  local replacement = replacements[word]
  if replacement then
    vim.cmd("normal! ciw" .. replacement)
  end
end, {})

-- Markdown format shortcuts
cmd("RemoveCite", [[%s/\[cite:.\{-}\]//g]], {})
cmd("RemoveBold", [[%s/\*\*\(.\{-}\)\*\*/\1/g]], {})

cmd("BufInfo", function()
  local ft = vim.bo.filetype
  local bt = vim.bo.buftype

  if ft == "" then
    ft = "[none]"
  end
  if bt == "" then
    bt = "[normal]"
  end

  print("filetype: " .. ft .. " | buftype: " .. bt)
end, {})

cmd("OpenConfig", function()
  vim.cmd("tabnew")
  local conf = vim.fn.stdpath("config")
  vim.cmd("tcd " .. conf .. " | e init.lua")
end, {})
