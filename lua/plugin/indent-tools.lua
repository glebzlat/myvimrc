return {
  "arsham/indent-tools.nvim",
  requires = { "arsham/arshlib.nvim" },
  config = function()
    require("indent-tools").config {
      normal = {
        up = "[i",
        down = "]i",
      },
      textobj = {
        ii = "ii",
        ai = "ai",
      },
    }
  end,
}
