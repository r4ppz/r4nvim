local M = {}

function M.setup(capabilities)
  vim.lsp.config("qml-language-server", {
    capabilities = capabilities,
    cmd = { "qml-language-server" },
    filetypes = { "qml", "qmljs" },
    root_markers = { ".qmlls.ini", "shell.qml", ".git" },
  })
end

return M
