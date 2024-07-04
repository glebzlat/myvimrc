return {
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })
  end,
  config = function()
    local ts_path = tostring(vim.fn.stdpath("data")) .. "/ts_parsers"

    vim.opt.runtimepath:append(ts_path) -- parsers directory

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "cpp",
        "c",
        "python",
        "bash",
        "ruby",
        "lua",
        "markdown",
        "markdown_inline",
      },

      auto_install = false,
      sync_install = true,

      parser_install_dir = ts_path,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      ignore_install = {},
      modules = {},

      additional_vim_regex_highlighting = false
    })
  end,
}
