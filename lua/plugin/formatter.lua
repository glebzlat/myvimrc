return {
  "mhartington/formatter.nvim",
  requires = {
    "williamboman/mason.nvim",
  },
  config = function()
    -- local mason_bin_prefix = require("mason-core.path").bin_prefix
    local map = vim.keymap.set
    local default_map = { silent = true, noremap = true }

    local registry = require "mason-registry"

    ---mason ensure_installed
    ---@param packages table
    function registry:ensure_installed(packages)
      for _, package in ipairs(packages) do
        local version = nil
        if type(package) == "table" then
          version = package["version"]
          package = package[1]
        end
        if self.has_package(package) and not self.is_installed(package) then
          local pkg = self.get_package(package)
          pkg:install(version)
        end
      end
    end

    registry:ensure_installed {
      "clang-format",
      { "stylua", version = "v0.15.3" },
    }

    require("formatter").setup {
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {

        lua = {
          require("formatter.filetypes.lua").stylua,
          -- function()
          --   return {
          --     exe = mason_bin_prefix "stylua",
          --   }
          -- end,
        },

        cpp = {
          require "formatter.defaults.clangformat",
        },

        c = {
          require "formatter.defaults.clangformat",
        },

        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      },
    }
    map("n", "<leader>f", "<cmd>Format<cr>", default_map)
    map("n", "<leader>F", "<cmd>FormatWrite<cr>", default_map)
  end,
}
