return {
  "neovim/nvim-lspconfig",
  -- tag = "v0.1.4",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local map = vim.keymap.set

    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    default_capabilities.textDocument.completion.completionItem.snippetSupport =
      true

    local lsp_flags = { debounce_text_changes = 150 }

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

    local opts = { noremap = true, silent = true }
    map("n", "<leader><leader>e", vim.diagnostic.open_float, opts)

    require("mason").setup {
      ui = {
        icons = {
          package_installed = "+",
          package_pending = ">",
          package_uninstalled = "-",
        },
      },
    }

    require("mason-lspconfig").setup()

    local lspconfig = require "lspconfig"
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = {
      { "clangd", cmd = { "clangd", "--completion-style=detailed" } },
      { "cmake" },
      { "cssls" },
      { "bashls" },
      {
        "pylsp",
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { ignore = { "W391" }, maxLineLength = 80 },
            },
          },
        },
      },
      {
        "lua_ls",
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "use" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      },
      {
        "html",
        filetypes = { "html", "xhtml" },
        init_options = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = {
            css = true,
            javascript = true,
          },
          provideFormatter = true,
        },
      },
      -- TODO: jdtls
    }

    local vim_warn = vim.log.levels.WARN

    for _, server in pairs(servers) do
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

      if vim.fn.executable(server_exec) ~= 1 then
        -- check, if the current file type is in the filetypes list for this
        -- server; it is supposed to do not print "server is not installed"
        -- warning if the current filetype is not for the server's language.
        local filetypes = {}
        if server["filetypes"] then
          filetypes = server["filetypes"]
        else
          filetypes = config.filetypes
        end

        local current_filetype = vim.bo.filetype
        if filetypes then
          for i in filetypes do
            if current_filetype == i then
              vim.notify(
                ("lsp setup: %q not found"):format(server_exec),
                vim_warn
              )
              return
            end
          end
        end
      end

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
