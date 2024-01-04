return {
  "pylsp",
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {
            "W391",
            "W503",
            "W504",
          },
          maxLineLength = 80,
        },
      },
    },
  },
}
