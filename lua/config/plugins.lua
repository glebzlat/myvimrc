-------------------------------------------------------------------------------
-- Plugin setup
-------------------------------------------------------------------------------

-- Packer --------------------------------------------------------------------

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
local packer = require 'packer'
packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- theme
  use 'nlknguyen/papercolor-theme'

  -- look
  use 'crispgm/nvim-tabline'
  use 'ojroques/nvim-hardline'
  use 'lewis6991/gitsigns.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'glepnir/dashboard-nvim'

  -- code tools
  use 'gpanders/editorconfig.nvim'
  use 'numToStr/Comment.nvim'
  -- use 'lukas-reineke/lsp-format.nvim'
  use 'mhartington/formatter.nvim'
  use 'folke/trouble.nvim'

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    tag = 'v0.8.1',
    run = function()
      -- require 'nvim-treesitter.install'.update { with_sync = true }
      vim.cmd [[ TSUpdate ]]
    end
  }

  -- utility
  use 'powerman/vim-plugin-ruscmd'
  use 'dstein64/vim-startuptime'

  -- lspconfig and additional tools

  use { 'neovim/nvim-lspconfig',
    tag = 'v0.1.4',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim'
    }
  }

  use { 'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp' }
  }

  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = 'nvim-lua/plenary.nvim'
  }

  use { 'nvim-telescope/telescope-file-browser.nvim',
    -- after = 'nvim-telescope/telescope.nvim'
  }

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

return packer_bootstrap
