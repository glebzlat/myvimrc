return {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    symbols = {
      outline_items = {
        show_symbol_lineno = true,
        auto_set_cursor = false,
      },
      filter = {
        python = { "Function", "Class", "Method", "Constructor" },
      },
      icons = {
        -- Use Unicode symbols to take into account environments with no
        -- custom font.
        File = { icon = "F" },
        Module = { icon = "M" },
        Namespace = { icon = "ℕ" },
        Package = { icon = "P" },
        Property = { icon = "ⅈ" },
        Field = { icon = "ⅈ" },
        Constructor = { icon = "ℭ" },
        Interface = { icon = "ℐ" },
        Function = { icon = "ℱ" },
        Variable = { icon = "v" },
        Constant = { icon = "ℼ" },
        StaticMethod = { icon = "ƒ" },
        EnumMember = { icon = "e" },
        Parameter = { icon = "℘" },
      },
    },
  },
}
