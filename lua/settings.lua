local option = vim.opt
local global = vim.api.nvim_set_var

-- Open help in a new tab
vim.cmd "cabbrev th tab h"

vim.cmd [[
filetype indent plugin on
syntax enable
]]

global("mapleader", ";")

option.termguicolors = false

option.mouse = "a"
option.encoding = "utf-8"
option.number = true -- Show line numbers
option.relativenumber = true
option.cursorline = true -- Highlight current cursor line
option.autoindent = true
option.colorcolumn = "80"
option.scrolloff = 5 -- Cursor indentation from window top and bottom edges
option.sidescrolloff = 12 -- Cursor indentation from the window left and right
option.matchpairs = "(:),{:},[:],<:>"
option.title = true -- Title of the window
option.showcmd = true
option.wrap = false -- Wrap long lines (do not carry to the next line)
option.linebreak = false -- Break long lines (carry)
option.showbreak = "=> " -- Break marker
option.expandtab = true
option.tabstop = 4
option.shiftwidth = 4
option.softtabstop = 4
option.smartindent = true
option.foldmethod = "indent"
option.foldcolumn = "auto:2"
option.foldlevelstart = 99 -- To prevent fold closing on enter
option.splitright = true -- Put a new window to the right
option.splitbelow = true -- Put a new window below
option.lazyredraw = true -- To prevent flicker, i think
option.synmaxcol = 512 -- Avoid to slow down redrawing for very long lines
option.ruler = false

vim.g.tagbar_compact = 1

-- 2 spaces for selected filetypes
vim.cmd [[
autocmd FileType cpp,arduino,html,css,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

local map = vim.keymap.set
local default_map = { silent = true, noremap = true }

map("n", "<leader>l", "<cmd>tabnext<cr>", default_map)
map("n", "<leader>k", "<cmd>tabprevious<cr>", default_map)
map("n", "<leader>c", "<cmd>tabclose<cr>", default_map)
map("n", "<leader>n", "<cmd>tabnew<cr>", default_map)
map("n", "<leader>1", "1gt", default_map)
map("n", "<leader>2", "2gt", default_map)
map("n", "<leader>3", "3gt", default_map)
map("n", "<leader>4", "4gt", default_map)
map("n", "<leader>5", "5gt", default_map)
map("n", "<leader>6", "6gt", default_map)
map("n", "<leader>7", "7gt", default_map)
map("n", "<leader>8", "8gt", default_map)
map("n", "<leader>9", "9gt", default_map)
map("n", "<leader>0", "<cmd>tablast<cr>", default_map)

-- local mason_bin_prefix = require("mason-core.path").bin_prefix

local function get_backup_directory()
  local dir = vim.fn.stdpath "data" .. "/backup"
  if vim.fn.isdirectory(dir) ~= 1 then vim.fn.mkdir(dir, "p", "0700") end
  return dir
end

option.backup = true
option.backupdir = get_backup_directory()
option.backupcopy = "yes" -- Make a copy and overwrite the original file
