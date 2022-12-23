require 'details.functions'

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

local is_bootstrap = ensure_packer()

SafeRequire('packer', function(packer)
  packer.startup(function(use)
    use 'wbthomason/packer.nvim'

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

    use 'nlknguyen/papercolor-theme'

    use { 'neovim/nvim-lspconfig',
      requires = {
        -- Automatic packet manager
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim'
      }
    }

    use 'pierreglaser/folding-nvim'
    use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp', } }

    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'aklt/plantuml-syntax'
    use 'lukas-reineke/lsp-format.nvim'

    use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
        SafeRequire('nvim-treesitter.install', function(ts)
          ts.update { with_sync = true }
        end)
      end
    }

    -- dependency for cmp-nvim-lsp, nvim-cmp, cmp-vsnip, etc
    use 'nvim-lua/plenary.nvim'

    -- Add custom plugins from lua/custom/plugins.lua
    SafeRequire { 'custom.plugins', function(plugins)
      plugins(use)
    end, notify = false }

    if is_bootstrap then packer.sync() end
  end)
end)

if is_bootstrap then
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
