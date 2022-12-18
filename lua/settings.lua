require 'config_functions'

local opt = vim.opt
local gvar = vim.api.nvim_set_var

opt.mouse = 'a'
opt.encoding = 'utf-8'
opt.showcmd = true
vim.cmd([[
filetype indent plugin on
syntax enable
]])
gvar('mapleader', ';')

vim.o.matchpairs = "(:),{:},[:],<:>"

opt.cursorline = true
opt.number = true           -- Line number
opt.relativenumber = true
opt.autoindent = true
opt.ruler = true
opt.wrap = false            -- Wrap long lines
-- opt.linebreak = true     -- Break long lines
-- opt.showbreak = '=> '
opt.expandtab = true
opt.tabstop = 4             --1 tab = 4 пробела
opt.shiftwidth = 4          --Смещаем на 4 пробела
opt.softtabstop = 2
opt.smartindent = true
opt.foldcolumn = 'auto:9'

vim.g.tagbar_compact = 1

-- 2 spaces for selected filetypes
vim.cmd [[
autocmd FileType cpp,html,css,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

opt.so = 5                  --Отступ курсора от края экрана
opt.foldcolumn = '2'        --Ширина колонки для фолдов
opt.colorcolumn = '80'

-- Colorscheme
vim.cmd [[ colorscheme elflord ]]
-- vim.cmd [[ colorscheme default ]]

-------------------------------------------------------------------------------
-- Plugins settings
-------------------------------------------------------------------------------

-- Vim-Airline
gvar('airline#extensions#tabline#enabled', '1') -- Tabline
gvar('airline#extensions#tabline#formatter', 'unique_tail') -- Tabline style
gvar('airline_highlighting_cache', '1') -- Enable caching

SafeRequire('trouble', function(trouble)
  trouble.setup {
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
end)

-- Indent Blankline
SafeRequire('indent_blankline', function(indent_blankline)
  indent_blankline.setup{
    show_current_context = true,
    show_current_context_start = true,
  }
end)

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


