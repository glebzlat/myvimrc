return {
  "toppair/reach.nvim",
  config = function()
    local function map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
    end

    require("reach").setup {
      notifications = true,
    }

    map("n", "<leader>rb", "<cmd>ReachOpen buffers<cr>")
    map("n", "<leader>rt", "<cmd>ReachOpen tabpages<cr>")
    map("n", "<leader>rm", "<cmd>ReachOpen marks<cr>")
  end,
}
