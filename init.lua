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

  { "mfussenegger/nvim-jdtls" },
  { "folke/neodev.nvim", opts = {} },
  { "tpope/vim-sleuth", version = "v2.0" },

  require("plugin.mason"),
  require("plugin.mason-lspconfig"),
  require("plugin.trouble"),
  require("plugin.indent-tools"),
  require("plugin.formatter"),
  require("plugin.treesitter"),
  require("plugin.lsp"),
  require("plugin.cmp"),
  require("plugin.neogen"),
  require("plugin.comment"),

  require("plugin.telescope"),
  require("plugin.reach"),
  require("plugin.symbol-outline"),
  require("plugin.which-key"),

  require("plugin.dashboard"),
  require("plugin.hardline"),
  require("plugin.nvim-tabline"),
  require("plugin.colorscheme"),

  require("plugin.toggleterm"),
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
