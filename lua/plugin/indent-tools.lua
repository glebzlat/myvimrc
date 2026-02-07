return {
  "arsham/indent-tools.nvim",
  dependencies = {
    "arsham/arshlib.nvim",
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = {
      normal = {
        up = "[i",
        down = "]i",
      },
      textobj = {
        ii = "ii",
        ai = "ai",
      },
    }
  },
}
