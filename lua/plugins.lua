local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') ..
      '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path
    })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require 'packer'.startup(function(use)
  use 'wbthomason/packer.nvim'

  use '~/.config/nvim/my_plugins/arduinolsp'

  -- utilities and look
  use 'preservim/nerdtree'
  use 'folke/trouble.nvim'
  use 'voldikss/vim-floaterm'
  use 'gpanders/editorconfig.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'crispgm/nvim-tabline'
  use 'numToStr/Comment.nvim'
  use 'powerman/vim-plugin-ruscmd'
  use 'vim-airline/vim-airline'

  use 'dstein64/vim-startuptime'

  use 'nlknguyen/papercolor-theme'

  use { 'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim'
    }
  }

  use 'pierreglaser/folding-nvim'

  use { 'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp' }
  }

  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'
  use 'aklt/plantuml-syntax'
  use 'lukas-reineke/lsp-format.nvim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require 'nvim-treesitter.install'.update { with_sync = true }
    end
  }

  -- dependency for cmp-nvim-lsp, nvim-cmp, cmp-vsnip, etc
  use 'nvim-lua/plenary.nvim'

  if packer_bootstrap then require 'packer'.sync() end
end)

if packer_bootstrap then
  print '==================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '        then restart nvim'
  print '==================================='
  return
end

-- Automatically source and recompile packer
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
