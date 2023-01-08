return {
  "akinsho/toggleterm.nvim",
  tag = "*",
  config = function()
    require("toggleterm").setup {
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      open_mapping = [[<c-\>]],
      hide_numbers = true, -- hide the number column in toggleterm buffers
      auto_scroll = true,
      direction = "float",
      float_opts = {
        border = "single",
      },
    }
  end,
}
