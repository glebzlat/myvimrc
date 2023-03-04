return {
  "ojroques/nvim-hardline",
  requires = { 
    {"lewis6991/gitsigns.nvim", version = "v0.6"}
  },
  config = function()
    require("gitsigns").setup {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
    }

    require("hardline").setup {
      bufferline = false,
      bufferline_settings = {
        exclude_terminal = false,
        show_index = false,
      },
      theme = "default",
      sections = { -- define sections
        { class = "mode", item = require("hardline.parts.mode").get_item },
        {
          class = "high",
          item = require("hardline.parts.git").get_item,
          hide = 100,
        },
        { class = "med", item = require("hardline.parts.filename").get_item },
        "%<",
        { class = "med", item = "%=" },
        {
          class = "low",
          item = require("hardline.parts.wordcount").get_item,
          hide = 100,
        },
        { class = "error", item = require("hardline.parts.lsp").get_error },
        { class = "warning", item = require("hardline.parts.lsp").get_warning },
        {
          class = "warning",
          item = require("hardline.parts.whitespace").get_item,
        },
        {
          class = "high",
          item = require("hardline.parts.filetype").get_item,
          hide = 60,
        },
        { class = "mode", item = require("hardline.parts.line").get_item },
      },
    }
  end,
}
