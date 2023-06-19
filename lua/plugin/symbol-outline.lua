return {
  "simrat39/symbols-outline.nvim",
  config = function()
    local options = {
      symbols = {
        keymaps = {
          close = { "q" },
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          toggle_preview = "K",
          rename_symbol = "r",
          code_actions = "a",
          fold = "h",
          unfold = "l",
          fold_all = "W",
          unfold_all = "E",
          fold_reset = "R",
        },
        File = { icon = "file", hl = "@text.uri" },
        Module = { icon = "module", hl = "@namespace" },
        Namespace = { icon = "namespace", hl = "@namespace" },
        Package = { icon = "pack", hl = "@namespace" },
        Class = { icon = "class", hl = "@type" },
        Method = { icon = "method", hl = "@method" },
        Property = { icon = "prop", hl = "@method" },
        Field = { icon = "field", hl = "@field" },
        Constructor = { icon = "ctor", hl = "@constructor" },
        Enum = { icon = "enum", hl = "@type" },
        Interface = { icon = "iface", hl = "@type" },
        Function = { icon = "func", hl = "@function" },
        Variable = { icon = "var", hl = "@constant" },
        Constant = { icon = "const", hl = "@constant" },
        String = { icon = "str", hl = "@string" },
        Number = { icon = "#", hl = "@number" },
        Boolean = { icon = "bool", hl = "@boolean" },
        Array = { icon = "arr", hl = "@constant" },
        Object = { icon = "obj", hl = "@type" },
        Key = { icon = "key", hl = "@type" },
        Null = { icon = "NULL", hl = "@type" },
        EnumMember = { icon = "enumm", hl = "@field" },
        Struct = { icon = "struct", hl = "@type" },
        Event = { icon = "event", hl = "@type" },
        Operator = { icon = "+", hl = "@operator" },
        TypeParameter = { icon = "𝙏", hl = "@parameter" },
        Component = { icon = "comp", hl = "@function" },
        Fragment = { icon = "frag", hl = "@constant" },
      },
    }
    require("symbols-outline").setup(options)
  end,
}