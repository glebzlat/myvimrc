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

    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lsp_flags = { debounce_text_changes = 150 }

    local path = require("mason-core.path")
    local language_servers_dir =
      path.concat({ vim.fn.stdpath("config"), "lua", language_servers })
    local fnamemodify = vim.fn.fnamemodify

    -- for each file in language_servers_dir:
    --   load configuration and setup the server
    for filename in vim.fs.dir(language_servers_dir) do
      local module = language_servers .. "." .. fnamemodify(filename, ":r")
      local server = require(module)

      -- apply default `capabilities` and `flags` if custom are not provided
      if not server["capabilities"] then
        server["capabilities"] = capabilities
      end
      if not server["flags"] then server["flags"] = lsp_flags end

      local config = lspconfig[server[1]]
      if not config["document_config"] then return end
      config.setup(server)
    end

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below
    -- functions
    map("n", "<leader>e", vim.diagnostic.open_float)
    map("n", "[d", vim.diagnostic.goto_prev)
    map("n", "]d", vim.diagnostic.goto_next)
    map("n", "<leader>q", vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings
        local bufopts = { noremap = true, silent = true, buffer = ev.buf }
        map("n", "<leader>ac", vim.lsp.buf.code_action, bufopts)
        map("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
        map("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
        map("n", "<leader>K", vim.lsp.buf.hover, bufopts)
        map("n", "<leader>gi", vim.lsp.buf.implementation, bufopts)
        map("n", "<leader>tD", vim.lsp.buf.type_definition, bufopts)
        map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        map("n", "<leader><C-k>", vim.lsp.buf.signature_help, bufopts)
        -- stylua: ignore start
        map("n", "<leader>wl",
          function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
        map("n", "<leader>bf",
          function()
            vim.lsp.buf.format { async = true }
          end, bufopts)
        -- stylua: ignore end
      end,
    })
  end,
}
