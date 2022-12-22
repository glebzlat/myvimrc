require 'details.functions'

local opt = vim.opt
local gvar = vim.api.nvim_set_var

-- Open help in a new tab
vim.cmd [[ 
cabbrev th tab h
]]

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
opt.ruler = true
opt.wrap = false -- Wrap long lines (do not carry to the next line)
-- opt.linebreak = true     -- Break long lines (carry)
-- opt.showbreak = '=> '    -- Break marker
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

vim.g.tagbar_compact = 1

-- 2 spaces for selected filetypes
vim.cmd [[
autocmd FileType cpp,arduino,html,css,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

-- Colorscheme
opt.termguicolors = true
vim.cmd [[ colorscheme PaperColor ]]

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

local safe_require = SafeRequire

-- Vim-Airline
gvar('airline_highlighting_cache', '1') -- Enable caching

safe_require('tabline', function(tabline)
  tabline.setup {
    show_index = true,
    show_modify = true,
    modify_indicator = '[+]',
    no_name = '[No name]'
  }
end)

safe_require('trouble', function(trouble)
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

vim.cmd [[
" press <Tab> to expand or jump in a snippet. These can also be mapped separately
" via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
" -1 for jumping backwards.
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

" For changing choices in choiceNodes (not strictly necessary for a basic setup).
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]]

safe_require('luasnip.loaders.from_snipmate', function(loader)
  loader.lazy_load()
end)

-- Indent Blankline
safe_require('indent_blankline', function(indent_blankline)
  indent_blankline.setup {
    show_current_context = true,
    show_current_context_start = true,
  }
end)

safe_require('Comment', function(comment)
  comment.setup()
end)

safe_require('mason', function(mason)
  mason.setup({
    ui = {
      icons = {
        package_installed = '+',
        package_pending = '>',
        package_uninstalled = '-'
      }
    }
  })
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
