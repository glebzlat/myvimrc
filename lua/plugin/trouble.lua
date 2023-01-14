return {
  "folke/trouble.nvim",
  config = function()
    local map = vim.keymap
    local default_map = { silent = true, noremap = true }

    require("trouble").setup {
      icons = false,
      fold_open = "v", -- icon used for open folds
      fold_closed = ">", -- icon used for closed folds
      indent_lines = false, -- add an indent guide below the fold icons
      signs = {
        -- icons / text used for a diagnostic
        error = "Error",
        warning = "Warn",
        hint = "Hint",
        information = "Info",
      },
      -- enabling this will use the signs defined in your lsp client
      use_diagnostic_signs = false,
    }

    map.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", default_map)
  end,
}
