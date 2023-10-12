return {
  "denols",
  cmd = { "deno", "lsp" },
  cmd_env = { NO_COLOR = true },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  handlers = {
    -- ["textDocument/definition"] = <function 1>,
    -- ["textDocument/references"] = <function 1>,
    -- ["textDocument/typeDefinition"] = <function 1>,
    -- ["workspace/executeCommand"] = <function 2>
  },
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://crux.land"] = true,
            ["https://deno.land"] = true,
            ["https://x.nest.land"] = true,
          },
        },
      },
    },
  },
}
