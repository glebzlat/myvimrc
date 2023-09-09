return {
  "goolord/alpha-nvim",
  config = function()
    local header = {
      type = "text",
      val = {
        "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      },
      opts = {
        position = "center",
        hl = "Type",
      },
    }

    local function footer_val()
      local lazy = require "lazy"
      return {
        string.format("Installed %d plugins", lazy.stats().count),
      }
    end

    local footer = {
      type = "text",
      val = footer_val(),
      opts = {
        position = "center",
        hl = "Number",
      },
    }

    local function button(shortcut, val, keybind, keybind_opts)
      local opts = {
        position = "center",
        shortcut = shortcut,
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "Keyword",
      }

      if keybind then
        keybind_opts = vim.F.if_nil(
          keybind_opts,
          { noremap = true, silent = true, nowait = true }
        )
        opts.keymap = { "n", shortcut, keybind, keybind_opts }
      end

      local function on_press()
        local key = vim.api.nvim_replace_termcodes(
          keybind or shortcut .. "<Ignore>",
          true,
          false,
          true
        )
        vim.api.nvim_feedkeys(key, "t", false)
      end

      return {
        type = "button",
        val = val,
        on_press = on_press,
        opts = opts,
      }
    end

    local buttons = {
      type = "group",
      val = {
        button("e", "New file", "<cmd>ene<CR>"),
        button("<leader>tf", "Find file"),
        button("<Space>", "File Browser"),
        button("<leader>th", "Browse help"),
        button("<leader>tk", "Keymaps"),
      },
      opts = {
        spacing = 1,
      },
    }

    local terminal = {
      type = "terminal",
      command = nil,
      width = 69,
      height = 8,
      opts = {
        redraw = true,
        window_config = {},
      },
    }

    local section = {
      terminal = terminal,
      header = header,
      buttons = buttons,
      footer = footer,
    }

    require("alpha").setup {
      layout = {
        { type = "padding", val = 2 },
        section.header,
        { type = "padding", val = 2 },
        section.buttons,
        section.footer,
      },
      opts = {
        margin = 5,
      },
    }
  end,
}
