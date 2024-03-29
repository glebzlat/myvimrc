require("settings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json"

require("lazy").setup({
  "dstein64/vim-startuptime",
  "lukas-reineke/indent-blankline.nvim",
  "vim-scripts/DoxygenToolkit.vim",
  { "lewis6991/gitsigns.nvim", tag = "v0.6" },

  require("plugin.reach"),
  require("plugin.hardline"),
  require("plugin.dashboard"),
  require("plugin.trouble"),
  require("plugin.formatter"),
  require("plugin.toggleterm"),
  require("plugin.treesitter"),
  require("plugin.lsp"),
  require("plugin.cmp"),
  require("plugin.telescope"),
  require("plugin.indent-tools"),
  require("plugin.neogen"),
  require("plugin.symbol-outline"),

  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "+",
            package_pending = ">",
            package_uninstalled = "-",
          },
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  },

  { "mfussenegger/nvim-jdtls" },

  -- TODO: it seems neodev does not work
  { "folke/neodev.nvim", opts = {} },

  { "tpope/vim-sleuth", version = "v2.0" },
  {
    "numToStr/Comment.nvim",
    version = "v0.7.0",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "crispgm/nvim-tabline",
    config = function()
      require("tabline").setup({})
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  {
    "nlknguyen/papercolor-theme",
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
  },
  {
    "Mofiqul/dracula.nvim",
    priority = 1000,
  },
}, {
  lockfile = lazy_lockfile,
  ui = {
    icons = {
      cmd = "CMD ",
      config = "CONF",
      event = "EV",
      ft = "FT",
      init = "INIT",
      import = "IMP",
      keys = "K",
      lazy = "LAZY",
      loaded = "●",
      not_loaded = "○",
      plugin = "PLUG",
      runtime = "RT",
      source = "★",
      start = "➜",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
})

local cs_saver = require("feature.colorscheme-saver")
cs_saver.setup()
