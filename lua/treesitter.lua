require 'config_functions'

local ts_path = tostring(vim.fn.stdpath 'data') .. 'ts_parsers'

-- Treesitter parsers directory
vim.opt.runtimepath:append(ts_path)

SafeRequire('nvim-treesitter.configs', function(ts)
  ts.setup {
    ensure_installed = { "cpp", "c", "python", "bash", "ruby", "lua"},
    sync_install = false,
    auto_install = false,

    parser_install_dir = ts_path,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }

  -- code folding 
  vim.opt.foldmethod = "expr"
  vim.cmd [[ set foldexpr=nvim_treesitter#foldexpr() ]]
  vim.opt.foldcolumn = "1"
end)
