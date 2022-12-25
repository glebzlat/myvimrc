local map = vim.keymap.set

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities
    .textDocument.completion.completionItem.snippetSupport = true

local lsp_flags = { debounce_text_changes = 150 }

local on_attach = function(_, bufnr)
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

  require 'folding'.on_attach()
end

local on_attach_with_format = function(client, bufnr)
  on_attach(client, bufnr)
  require 'lsp-format'.on_attach(client)
end

local arduinolsp = require 'arduinolsp'

local servers = {
  -- C/C++
  { 'clangd',
    cmd = { 'clangd', '--completion-style=detailed', '--clang-tidy' },
    filetypes = { 'c', 'cpp', },
    on_attach = on_attach,
    capabilities = default_capabilities,
    flags = lsp_flags
  },

  -- Lua
  { 'sumneko_lua',
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
    flags = lsp_flags,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim', 'use' }
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false
        },
        telemetry = {
          enable = false
        }
      }
    }
  },

  -- CMake
  { 'cmake',
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
    flags = lsp_flags,
  },

  -- Python
  { 'pylsp',
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
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
    }
  },

  -- HTML
  { 'html',
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
    flags = lsp_flags,
  },

  -- CSS
  { 'cssls',
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
    flags = lsp_flags,
  },

  { 'arduino_language_server',
    on_attach = on_attach,
    capabilities = default_capabilities,
    flags = lsp_flags,
    on_new_config = arduinolsp.on_new_config,
    filetypes = { 'arduino' },
    cmd = {
      'arduino-language-server',
    }
  }

}

local opts = { noremap = true, silent = true }
map('n', '<leader><leader>e', vim.diagnostic.open_float, opts)

local vim_warn = vim.log.levels.WARN

local lspconfig = require 'lspconfig'

for _, server in pairs(servers) do
  local config = lspconfig[server[1]]
  local name = server[1]

  -- To prevent fault if the server name is not correct
  if not config['document_config'] then
    break
  end

  local server_executable = config.document_config.default_config.cmd

  if type(server_executable) ~= 'table' then
    local cmd = server['cmd']
    if not server['cmd'] then
      vim.notify(('lspconfig setup: for server %q executable not found')
        :format(name), vim_warn)
      break
    end
    server_executable = cmd
  end
  server_executable = server_executable[1]

  if vim.fn.executable(server_executable) ~= 1 then
    vim.notify(('lspconfig setup: %q is not found')
      :format(server_executable), vim_warn)
    break
  end

  local options = {}
  for k, v in pairs(server) do
    if type(k) ~= 'number' then
      options[k] = v
    end
  end

  config.setup(options)
end
