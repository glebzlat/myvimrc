local opt = vim.opt
local gvar = vim.api.nvim_set_var

-- Open help in a new tab
vim.cmd('cabbrev th tab h')

vim.cmd([[
filetype indent plugin on
syntax enable
]])
gvar('mapleader', ';')

-- Triangle braces match is very useful in C++ template programming
vim.o.matchpairs = "(:),{:},[:],<:>"
opt.mouse = 'a'
opt.encoding = 'utf-8'
opt.showcmd = false
opt.cursorline = true -- Highlight current cursor line
opt.number = true -- Show line numbers
opt.relativenumber = true
opt.autoindent = true
opt.wrap = false -- Wrap long lines (do not carry to the next line)
opt.linebreak = false -- Break long lines (carry)
opt.showbreak = '=> ' -- Break marker
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 2
opt.smartindent = true
opt.foldcolumn = 'auto:9'
opt.scrolloff = 5 -- Cursor indentation from window top and bottom edges
opt.sidescrolloff = 12 -- Cursor indentation from the window left and right
opt.foldcolumn = '2' -- Foldcolumn width
opt.foldlevelstart = 99 -- To prevent fold closing on enter
opt.colorcolumn = '80'
opt.splitright = true -- Put a new window to the right
opt.splitbelow = true -- Put a new window below
opt.lazyredraw = true -- To prevent flicker, i think
opt.title = true -- Title of the window
opt.synmaxcol = 512 -- Avoid to slow down redrawing for very long lines
opt.ruler = false

vim.g.tagbar_compact = 1

-- 2 spaces for selected filetypes
vim.cmd [[
autocmd FileType cpp,arduino,html,css,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

-- Colorscheme
opt.termguicolors = true
vim.cmd [[ colorscheme PaperColor ]]
--
-- Backup
local function get_backup_directory()
  local dir = vim.fn.stdpath 'data' .. '/backup'
  if vim.fn.isdirectory(dir) ~= 1 then
    vim.fn.mkdir(dir, 'p', '0700')
  end
  return dir
end

opt.backup = true
opt.backupdir = get_backup_directory()
opt.backupcopy = 'yes' -- Make a copy and overwrite the original file

-------------------------------------------------------------------------------
-- Plugins settings
-------------------------------------------------------------------------------

-- Vim-Airline
gvar('airline_highlighting_cache', '1') -- Enable caching

require 'tabline'.setup {
  show_index = true,
  show_modify = true,
  modify_indicator = '[+]',
  no_name = '[No name]'
}

require 'trouble'.setup {
  icons = false,
  fold_open = "v", -- icon used for open folds
  fold_closed = ">", -- icon used for closed folds
  indent_lines = false, -- add an indent guide below the fold icons
  signs = {
    -- icons / text used for a diagnostic
    error = "error",
    warning = "warn",
    hint = "hint",
    information = "info"
  },
}

require 'indent_blankline'.setup {
  show_current_context = true,
  show_current_context_start = true,
}

require 'Comment'.setup()

local mason_root_dir = vim.fn.stdpath 'data' .. '/mason'
local mason_bin_dir = mason_root_dir .. '/bin'

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
  }),
  formatting = {
    fields = {
      'kind',
      'abbr',
      'menu'
    },
    format = function(entry, vim_item)
      vim_item.menu = ({
        vsnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]'
      })[entry.source.name]
      return vim_item
    end
  }
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

require 'mason'.setup({
  ui = {
    icons = {
      package_installed = '+',
      package_pending = '>',
      package_uninstalled = '-'
    }
  },
  install_root_dir = mason_root_dir
})

require 'mason-lspconfig'.setup({
  ensure_installed = {
    'clangd',
    'cmake',
    'pylsp',
    'cssls',
    'html',
    'bashls',
    'sumneko_lua',
    'arduino_language_server'
  }
})

local arduinolsp_ok, arduinolsp = pcall(require, 'arduinolsp')
if arduinolsp_ok then
  arduinolsp.setup({
    clangd_path = mason_bin_dir .. '/clangd',
    arduino_cli_config_dir = arduinolsp.get_arduinocli_datapath()
  })
end

-- NvimGDB
vim.cmd [[
function! NvimGdbNoTKeymaps()
tnoremap <silent> <buffer> <esc> <c-\><c-n>
endfunction

let g:nvimgdb_config_override = {
  \ 'key_next': 'n',
  \ 'key_step': 's',
  \ 'key_finish': 'f',
  \ 'key_continue': 'c',
  \ 'key_until': 'u',
  \ 'key_breakpoint': 'b',
  \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  \ }
  ]]
