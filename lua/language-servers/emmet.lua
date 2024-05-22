local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  "emmet_language_server",
  capabilities = capabilities,
  -- init_options = {
  --   html = {
  --     options = {
  --       ["bem.enabled"] = true,
  --     },
  --   },
  -- },
}
