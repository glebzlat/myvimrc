return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- all the servers
    -- servers that require custom properties are placed into
    -- 'lua/language-servers' directory for brevity
    local servers = {
      require "language-servers.clangd",
      require "language-servers.pylsp",
      require "language-servers.lua_ls",
      require "language-servers.html",
      require "language-servers.emmet",
      require "language-servers.denols",
      { "cmake" },
      { "cssls" },
      { "bashls" },
      { "phpactor" },
    }

    local map = vim.keymap.set
    local vim_warn = vim.log.levels.WARN

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

    -- iterate over language servers and call setup for each
    for _, server in ipairs(servers) do
      local config = lspconfig[server[1]]
      local name = server[1]

      if not config["document_config"] then return end

      local server_exec
      -- try to get executable name from `server['cmd']` first; if not, get the
      -- default
      if server["cmd"] then
        server_exec = server["cmd"]
      else
        server_exec = config.document_config.default_config.cmd
        if type(server_exec) ~= "table" then
          vim.notify(
            ("lsp setup: executable command not found for %q"):format(name),
            vim_warn
          )
          return
        end
      end
      server_exec = server_exec[1]

      -- apply default `on_attach`, `capabilities` and `flags` if custom
      -- not provided
      if not server["on_attach"] then server["on_attach"] = on_attach end
      if not server["capabilities"] then
        server["capabilities"] = capabilities
      end
      if not server["flags"] then server["flags"] = lsp_flags end

      local options = {}
      for k, v in pairs(server) do
        if type(k) ~= "number" then options[k] = v end
      end

      config.setup(options)
    end
  end,
}
