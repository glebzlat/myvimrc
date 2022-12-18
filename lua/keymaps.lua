local map = vim.api.nvim_set_keymap
local default_st = {silent = true, noremap = true}

-- Trouble keymaps
map('n', '<leader>xx', '<cmd>TroubleToggle<cr>', default_st)
map('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
default_st)
map('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>',
default_st)
map('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>', default_st)
map('n', '<leader>xl', '<cmd>TroubleToggle quickfix<cr>', default_st)
map('n', 'gR', '<cmd>TroubleToggle lsp_references<cr>', default_st)

-- NERDTree keymaps
map('n', '<space>', ':NERDTreeToggle<CR>', default_st)
map('', '<leader>f', '<Cmd>NERDTreeFocus<cr>', default_st)
map('n', '<leader>rr', '<Cmd>NERDTreeRefreshRoot<cr>', default_st)

map('n', '<leader>l', '<cmd>tabnext<cr>', default_st)
map('n', '<leader>k', '<cmd>tabprevious<cr>', default_st)
map('n', '<leader>c', '<cmd>tabclose<cr>', default_st)
map('n', '<leader>n', '<cmd>tabnew<cr>', default_st)
map('n', '<leader>1', '1gt', default_st)
map('n', '<leader>2', '2gt', default_st)
map('n', '<leader>3', '3gt', default_st)
map('n', '<leader>4', '4gt', default_st)
map('n', '<leader>5', '5gt', default_st)
map('n', '<leader>6', '6gt', default_st)
map('n', '<leader>7', '7gt', default_st)
map('n', '<leader>8', '8gt', default_st)
map('n', '<leader>9', '9gt', default_st)
map('n', '<leader>0', '<cmd>tablast<cr>', default_st)

-- Floaterm
map('n', '<leader>t', '<cmd>FloatermNew<cr>', default_st)

vim.g.floaterm_keymap_kill = '<leader><leader>k'
vim.g.floaterm_keymap_toggle = '<leader><leader>t'
vim.g.floaterm_keymap_hide = '<leader><leader>h'
vim.g.floaterm_keymap_next = '<leader><leader>n'
vim.g.floaterm_keymap_prev = '<leader><leader>p'

vim.g.floaterm_height = 0.8
vim.g.floaterm_width = 0.9

vim.g.floaterm_title = 'floaterm($1/$2)'

