local M = {}

function M.setup(capabilities)
  vim.lsp.config("postgres_lsp", {
    capabilities = capabilities,
    root_markers = {
      ".git",
    },
    filetypes = { "sql" },
  })
end

return M
