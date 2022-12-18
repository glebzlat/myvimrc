vim.cmd [[
call plug#begin('~/.config/nvim/plugged/')

" utilities and look
Plug 'preservim/nerdtree'
Plug 'folke/trouble.nvim'
Plug 'voldikss/vim-floaterm'
Plug 'sakhnik/nvim-gdb', {'do': ':!./install.sh'}
Plug 'vim-airline/vim-airline'
Plug 'gpanders/editorconfig.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'crispgm/nvim-tabline'
Plug 'numToStr/Comment.nvim'

" lsps, syntax highlighting, formatting, completion, etc
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'aklt/plantuml-syntax'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'lukas-reineke/lsp-format.nvim'

" dependency for cmp-nvim-lsp, nvim-cmp, cmp-vsnip, etc
Plug 'nvim-lua/plenary.nvim'

call plug#end()
]]
