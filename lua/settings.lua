require 'details.functions'

local opt = vim.opt
local gvar = vim.api.nvim_set_var

-- Abbreviation for :h - :tab h - open help in a new tab
vim.cmd [[ cabbrev h tab h ]]
-- Command for new tab help :Th
vim.api.nvim_create_user_command('Th', 'tab help <args>',
  { nargs = 1, complete = 'help' })

opt.mouse = 'a'
opt.encoding = 'utf-8'
opt.showcmd = true
vim.cmd([[
filetype indent plugin on
syntax enable
]])
gvar('mapleader', ';')

-- Triangle braces match is very useful in C++ template programming
vim.o.matchpairs = "(:),{:},[:],<:>"

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

vim.g.tagbar_compact = 1

-- 2 spaces for selected filetypes
vim.cmd [[
autocmd FileType cpp,arduino,html,css,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

opt.so = 5 -- Cursor indentation from window top and bottom edges
opt.foldcolumn = '2' -- Foldcolumn width
opt.colorcolumn = '80'

-- Colorscheme
vim.cmd [[ colorscheme elflord ]]
-- vim.cmd [[ colorscheme default ]]

-- Update and open folds when write
-- It is important, because formatter removes all foldings,
-- and when they're added again, they are closed
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function()
    UpdateFolding()
    OpenAllFolds()
  end
})

-------------------------------------------------------------------------------
-- Plugins settings
-------------------------------------------------------------------------------

-- Vim-Airline
gvar('airline_highlighting_cache', '1') -- Enable caching

SafeRequire('tabline', function(tabline)
  tabline.setup {
    show_index = true,
    show_modify = true,
    modify_indicator = '[+]',
    no_name = '[No name]'
  }
end)

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
  indent_blankline.setup {
    show_current_context = true,
    show_current_context_start = true,
  }
end)

SafeRequire('Comment', function(comment)
  comment.setup()
end)

SafeRequire('mason', function(mason)
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
