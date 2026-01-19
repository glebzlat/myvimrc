return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "+",
          package_pending = ">",
          package_uninstalled = "-",
        },
      },
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry"
      }
    })
  end,
}
