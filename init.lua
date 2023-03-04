pcall(require, "impatient")
require "settings"

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath "data"
    .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    -- stylua: ignore start
    fn.system {
      "git", "clone", "--depth", "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    }
    -- stylua: ignore end
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
local packer = require "packer"

packer.startup(function(use)
  use "wbthomason/packer.nvim"

  use "lewis6991/impatient.nvim"

  use "powerman/vim-plugin-ruscmd"
  use "dstein64/vim-startuptime"
  use "lukas-reineke/indent-blankline.nvim"
  use "vim-scripts/DoxygenToolkit.vim"
  use { "lewis6991/gitsigns.nvim", tag = "v0.6" }
  use {
    "williamboman/mason-lspconfig.nvim",
  }

  use(require "plugin.reach")
  use(require "plugin.colorscheme")
  use(require "plugin.hardline")
  use(require "plugin.dashboard")
  use(require "plugin.trouble")
  use(require "plugin.formatter")
  use(require "plugin.toggleterm")
  use(require "plugin.treesitter")
  use(require "plugin.lsp")
  use(require "plugin.cmp")
  use(require "plugin.telescope")
  use(require "plugin.indent-tools")
  use(require "plugin.neogen")

  use { "tpope/vim-sleuth", tag = "v2.0" }
  use {
    "numToStr/Comment.nvim",
    tag = "v0.7.0",
    config = function() require("Comment").setup() end,
  }
  use {
    "crispgm/nvim-tabline",
    config = function() require("tabline").setup {} end,
  }

  use {
    "edKotinsky/Arduino.nvim",
    branch = "dev",
  }

  if packer_bootstrap then require("packer").sync() end
end)

if packer_bootstrap then
  print "==================================="
  print "    Plugins are being installed"
  print "    Wait until Packer completes,"
  print "        then restart nvim"
  print "==================================="
  return
end

-- Automatically source and recompile packer
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]]
