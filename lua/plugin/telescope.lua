return {
  "nvim-telescope/telescope.nvim",
  version = "0.1.1",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local map = vim.keymap.set
    local default_map = { silent = true, noremap = true }

    local telescope = require "telescope"

    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ["<C-h>"] = "which_key",
          },
        },
      },
      extensions = {
        file_browser = {
          dir_icon = "‣",
          hidden = true,
        },
      },
    }

    pcall(telescope.load_extension, "file_browser")

    local builtin = require "telescope.builtin"

    map("n", "<leader>tf", builtin.find_files, default_map)
    map("n", "<Space>", "<cmd>Telescope file_browser<cr>", default_map)
    map("n", "<leader>tsg", builtin.git_status, default_map)
    map("n", "<leader>tg", builtin.live_grep, default_map)
    map("n", "<leader>tgs", builtin.grep_string, default_map)
    map("n", "<leader>tb", builtin.buffers, default_map)
    map("n", "<leader>th", builtin.help_tags, default_map)
    map("n", "<leader>tk", builtin.keymaps, default_map)
  end,
}
