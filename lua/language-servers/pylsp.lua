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
        jedi = {
          extra_paths = require("feature.python-extra-paths").get_paths(),
        },
      },
    },
  },
}
