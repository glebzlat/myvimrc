require("settings")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local lazy_lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json"

require("lazy").setup({
  "dstein64/vim-startuptime",
  "lukas-reineke/indent-blankline.nvim",
  "vim-scripts/DoxygenToolkit.vim",
  { "lewis6991/gitsigns.nvim", tag = "v0.6" },

  { "mfussenegger/nvim-jdtls" },
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
  require("plugin.autopairs"),
  require("plugin.indent-blankline"),
  require("plugin.lazydev"),

  require("plugin.telescope"),
  require("plugin.reach"),
  require("plugin.symbol-outline"),
  require("plugin.which-key"),

  require("plugin.dashboard"),
  require("plugin.hardline"),
  require("plugin.nvim-tabline"),

  require("plugin.toggleterm"),

  { "NLKNguyen/papercolor-theme", priority = 1000 },
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "Mofiqul/dracula.nvim", priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "projekt0n/github-nvim-theme", priority = 1000 },
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

if vim.version().minor >= 11 then
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true
  })
end
