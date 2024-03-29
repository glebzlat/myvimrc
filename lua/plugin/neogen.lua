return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  version = "*",
  config = function()
    local map = vim.keymap
    local default_map = { silent = true, noremap = true }

    require("neogen").setup({
      enabled = true,
      input_after_comment = true,
      snippet_engine = "vsnip",
    })

    map.set("n", "<leader>nf", function()
      require("neogen").generate({ type = "func" })
    end, default_map)

    map.set("n", "<leader>nF", function()
      require("neogen").generate({ type = "file" })
    end, default_map)

    map.set("n", "<leader>nt", function()
      require("neogen").generate({ type = "type" })
    end, default_map)

    map.set("n", "<leader>nc", function()
      require("neogen").generate({ type = "class" })
    end, default_map)
  end,
}
