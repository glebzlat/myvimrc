return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- servers configurations are placed here
    local language_servers = "language-servers"

    local map = vim.keymap.set

    map(
      "n",
      "<leader><leader>e",
      vim.diagnostic.open_float,
      { noremap = true, silent = true }
    )

    local on_attach = function(_, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      map("n", "<leader><leader>ca", vim.lsp.buf.code_action, bufopts)
      map("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
      map("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
      map("n", "<leader>K", vim.lsp.buf.hover, bufopts)
      map("n", "<leader>gi", vim.lsp.buf.implementation, bufopts)
      map("n", "<leader>tD", vim.lsp.buf.type_definition, bufopts)
      map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
      map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
      map(
        "n",
        "<leader>wl",
        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        bufopts
      )
      map("n", "<leader><C-k>", vim.lsp.buf.signature_help, bufopts)
      map(
        "n",
        "<leader>bf",
        function() vim.lsp.buf.format { async = true } end,
        bufopts
      )
    end

    local lspconfig = require "lspconfig"
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lsp_flags = { debounce_text_changes = 150 }

    local path = require "mason-core.path"
    local language_servers_dir =
      path.concat { vim.fn.stdpath "config", "lua", language_servers }
    local fnamemodify = vim.fn.fnamemodify

    -- for each file in language_servers_dir:
    --   load configuration and setup the server
    for filename in vim.fs.dir(language_servers_dir) do
      local module = language_servers .. "." .. fnamemodify(filename, ':r')
      local server = require(module)

      -- apply default `on_attach`, `capabilities` and `flags` if custom
      -- not provided
      if not server["on_attach"] then server["on_attach"] = on_attach end
      if not server["capabilities"] then
        server["capabilities"] = capabilities
      end
      if not server["flags"] then server["flags"] = lsp_flags end

      local config = lspconfig[server[1]]
      if not config["document_config"] then return end
      config.setup(server)
    end
  end,
}
