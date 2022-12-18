local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local lspconfig = require 'lspconfig'

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  map('n', '<leader><leader>ca', vim.lsp.buf.code_action, bufopts)
  map('n', '<leader>gD', vim.lsp.buf.declaration, bufopts)
  map('n', '<leader>gd', vim.lsp.buf.definition, bufopts)
  map('n', '<leader>K', vim.lsp.buf.hover, bufopts)
  map('n', '<leader>gi', vim.lsp.buf.implementation, bufopts)
  map('n', '<leader>tD', vim.lsp.buf.type_definition, bufopts)
  map('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  map('n', '<leader><C-k>', vim.lsp.buf.signature_help, bufopts)
  map('n', '<leader>bf', function()
    vim.lsp.buf.format { async = true }
  end, bufopts)

end

local on_attach_format = function(client, bufnr)
  on_attach(client, bufnr)
  require('lsp-format').on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_flags = { debounce_text_changes = 150 }

map('n', '<leader><leader>e', vim.diagnostic.open_float, opts)

-- completion
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' }
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Cr>'] = cmp.mapping.confirm({ select = true }),
  })
}

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'cmdline' }
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Clangd
lspconfig.clangd.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
  filetypes = {
    "c",
    "cpp",
    "arduino"
  },
}

-- Lua
lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'use' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true)
      },
      telemetry = {
        enable = false
      }
    }
  }
}

-- Cmake
lspconfig.cmake.setup {
  capabilities = capabilities,
  on_attach = on_attach_format,
  flags = lsp_flags,
}

-- HTML
lspconfig.html.setup {
  capabilities = capabilities,
  on_attach = on_attach_format,
  flags = lsp_flags,
}

-- CSS
lspconfig.cssls.setup {
  capabilities = capabilities,
  on_attach = on_attach_format,
  flags = lsp_flags,
}

lspconfig.eslint.setup {}

-- Python
lspconfig.pylsp.setup {
  capabilities = capabilities,
  on_attach = on_attach_format,
  flags = lsp_flags,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { 'W391' },
          maxLineLength = 100
        }
      }
    }
  },
}
