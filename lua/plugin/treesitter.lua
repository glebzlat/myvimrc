return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    -- require 'nvim-treesitter.install'.update { with_sync = true }
    vim.cmd [[ TSUpdate ]]
  end,
  config = function()
    local ts_path = tostring(vim.fn.stdpath "data") .. "/ts_parsers"

    vim.opt.runtimepath:append(ts_path) -- parsers directory

    require("nvim-treesitter.configs").setup {
      ensure_installed = { "cpp", "c", "python", "bash", "ruby", "lua" },

      auto_install = false,

      parser_install_dir = ts_path,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false
      }
    }
  end,
}
