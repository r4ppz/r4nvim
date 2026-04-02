local M = {}

function M.setup(capabilities)
  vim.lsp.config("yamlls", {
    capabilities = capabilities,
    settings = {
      redhat = {
        telemetry = {
          enabled = false,
        },
      },
      yaml = {
        format = {
          enable = false,
        },
      },
    },
  })
end

return M
