return {
  "mhartington/formatter.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    local map = vim.keymap.set
    local default_map = { silent = true, noremap = true }

    local registry = require("mason-registry")

    ---It seems that mason and mason-lspconfig don't provide an "official"
    ---way to ensure_installed not lsp servers, but formatters. So I've written
    ---this crutch
    ---@param packages table
    ---@diagnostic disable-next-line -- "Fields cannot injected into..."
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

    registry:ensure_installed({
      "clang-format",
      "stylua",
      "prettier",
    })

    local util = require("formatter.util")

    --Configuration can be defined as a function
    --It is needed to pass the function inside the table _without_ calling it
    local function clangformat()
      return {
        exe = "clang-format",
        args = {
          "-assume-filename",
          util.escape_path(util.get_current_buffer_file_name()),
        },
        stdin = true,
        try_node_modules = true,
      }
    end

    local prettier = require("formatter.filetypes.javascriptreact").prettier

    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {

        lua = { require("formatter.filetypes.lua").stylua },

        cpp = { clangformat },

        c = { clangformat },

        java = { clangformat },

        javascript = { prettier },
        javascriptreact = { prettier },
        typescriptreact = { prettier },

        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },

        css = { require("formatter.defaults.prettier") },

        html = { require("formatter.defaults.prettier") },

        xhtml = { require("formatter.defaults.prettier") },
      },
    })
    map("n", "<leader>f", "<cmd>Format<cr>", default_map)
    map("n", "<leader>F", "<cmd>FormatWrite<cr>", default_map)
  end,
}
