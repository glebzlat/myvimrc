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
        -- EXPERIMENTAL
        -- This path is valid for Fedora Workstation 39. On other systems
        -- it should be different. I think, if this cause no issues, I will
        -- write a utility which determines this path automatically.
        -- But for now it is hardcoded here.
        jedi = {
          extra_paths = {
            "/usr/lib64/python3.12/site-packages",
          },
        },
      },
    },
  },
}
