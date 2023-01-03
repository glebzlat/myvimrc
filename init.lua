local option = vim.opt
local global = vim.api.nvim_set_var

-- Open help in a new tab
vim.cmd "cabbrev th tab h"

vim.cmd [[
filetype indent plugin on
syntax enable
]]

global("mapleader", ";")

option.termguicolors = false
-- IMHO, this theme looks good whenever termguicolors enabled or not
vim.cmd [[ colorscheme PaperColor ]]

option.mouse = "a"
option.encoding = "utf-8"
option.number = true -- Show line numbers
option.relativenumber = true
option.cursorline = true -- Highlight current cursor line
option.autoindent = true
option.colorcolumn = "80"
option.scrolloff = 5 -- Cursor indentation from window top and bottom edges
option.sidescrolloff = 12 -- Cursor indentation from the window left and right
option.matchpairs = "(:),{:},[:],<:>"
option.title = true -- Title of the window
option.showcmd = true
option.wrap = false -- Wrap long lines (do not carry to the next line)
option.linebreak = false -- Break long lines (carry)
option.showbreak = "=> " -- Break marker
option.expandtab = true
option.tabstop = 4
option.shiftwidth = 4
option.softtabstop = 4
option.smartindent = true
option.foldmethod = "indent"
option.foldcolumn = "auto:2"
option.foldlevelstart = 99 -- To prevent fold closing on enter
option.splitright = true -- Put a new window to the right
option.splitbelow = true -- Put a new window below
option.lazyredraw = true -- To prevent flicker, i think
option.synmaxcol = 512 -- Avoid to slow down redrawing for very long lines
option.ruler = false

vim.g.tagbar_compact = 1

-- 2 spaces for selected filetypes
vim.cmd [[
autocmd FileType cpp,arduino,html,css,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------

local map = vim.keymap.set
local default_map = { silent = true, noremap = true }

-- Tabline --------------------------------------------------------------------

map("n", "<leader>l", "<cmd>tabnext<cr>", default_map)
map("n", "<leader>k", "<cmd>tabprevious<cr>", default_map)
map("n", "<leader>c", "<cmd>tabclose<cr>", default_map)
map("n", "<leader>n", "<cmd>tabnew<cr>", default_map)
map("n", "<leader>1", "1gt", default_map)
map("n", "<leader>2", "2gt", default_map)
map("n", "<leader>3", "3gt", default_map)
map("n", "<leader>4", "4gt", default_map)
map("n", "<leader>5", "5gt", default_map)
map("n", "<leader>6", "6gt", default_map)
map("n", "<leader>7", "7gt", default_map)
map("n", "<leader>8", "8gt", default_map)
map("n", "<leader>9", "9gt", default_map)
map("n", "<leader>0", "<cmd>tablast<cr>", default_map)

-------------------------------------------------------------------------------
-- Internal functions
-------------------------------------------------------------------------------

local path = require "config.path"

local function warning(message)
  vim.notify("[Config] warning: " .. message, vim.log.levels.WARN)
end

---Requires module safely
---@param module string
---@param callback function
---@return boolean
local function safe_require(module, callback)
  local ok, plugin = pcall(require, module)
  if not ok then
    warning(module .. " is not found")
    return false
  end
  callback(plugin)
  return true
end

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------

local packer_bootstrap = require "config.plugins"
if packer_bootstrap then return end

-- Mason ---------------------------------------------------------------------

local mason_root_dir = path.concat { vim.fn.stdpath "data", "mason" }
local mason_bin_dir = path.concat { mason_root_dir, "bin" }

safe_require("mason", function(mason)
  mason.setup {
    ui = {
      icons = {
        package_installed = "+",
        package_pending = ">",
        package_uninstalled = "-",
      },
    },
    install_root_dir = mason_root_dir,
  }

  -- Is mason really has not something like 'ensure_installed'?
  local registry = require "mason-registry"

  if not registry.is_installed "clang-format" then
    vim.cmd [[ MasonInstall clang-format ]]
  end

  if not registry.is_installed "stylua" then
    vim.cmd [[ MasonInstall stylua ]]
  end
end)

-- mason-lspconfig -----------------------------------------------------------

safe_require(
  "mason-lspconfig",
  function(mason)
    mason.setup {
      ensure_installed = {
        "clangd",
        "cmake",
        "pylsp",
        "cssls",
        "html",
        "bashls",
        "sumneko_lua",
        "arduino_language_server",
      },
    }
  end
)

-- Arduino -------------------------------------------------------------------

local arduino_ok, arduino = false, nil
safe_require("arduino", function(arduinonvim)
  arduino_ok = true
  arduino = arduinonvim

  arduinonvim.setup {
    arduino_config_dir = arduinonvim.get_arduinocli_datapath(),
    -- arduino_config_dir = "/home/dave/.arduino15",
  }

  vim.api.nvim_create_autocmd("User", {
    pattern = "ArduinoFqbnReset",
    callback = function() vim.cmd "LspRestart" end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "ArduinoOnNewConfig",
    callback = function()
      vim.notify("Hello", vim.log.levels.ERROR)
      vim.cmd "LspStop clangd"
    end,
  })
end)

-- Lspconfig -----------------------------------------------------------------

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.completionItem.snippetSupport =
  true

local lsp_flags = { debounce_text_changes = 150 }

local on_attach = function(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  map("n", "<leader><leader>ca", vim.lsp.buf.code_action, bufopts)
  map("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
  map("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
  map("n", "<leader>K", vim.lsp.buf.hover, bufopts)
  map("n", "<leader>gi", vim.lsp.buf.implementation, bufopts)
  map("n", "<leader>tD", vim.lsp.buf.type_definition, bufopts)
  map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  map(
    "n",
    "<leader>wl",
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    bufopts
  )
  map("n", "<leader><C-k>", vim.lsp.buf.signature_help, bufopts)
  map(
    "n",
    "<leader>bf",
    function() vim.lsp.buf.format { async = true } end,
    bufopts
  )

  local folding_ok, folding = pcall(require, "folding")
  if folding_ok then folding.on_attach() end
end

local on_attach_with_format = function(client, bufnr)
  on_attach(client, bufnr)
  local format_ok, format = pcall(require, "lsp-format")
  if format_ok then format.on_attach(client) end
end

local opts = { noremap = true, silent = true }
map("n", "<leader><leader>e", vim.diagnostic.open_float, opts)

safe_require("lspconfig", function(lspconfig)
  lspconfig["clangd"].setup {
    cmd = { "clangd", "--completion-style=detailed" },
    filetypes = { "c", "cpp" },
    on_attach = on_attach,
    capabilities = default_capabilities,
    flags = lsp_flags,
  }

  lspconfig["sumneko_lua"].setup {
    on_attach = on_attach,
    capabilities = default_capabilities,
    flags = lsp_flags,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim", "use" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }

  lspconfig["cmake"].setup {
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
    flags = lsp_flags,
  }

  -- Python
  lspconfig["pylsp"].setup {
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
    flags = lsp_flags,
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { "W391" },
            maxLineLength = 100,
          },
        },
      },
    },
  }

  -- HTML
  lspconfig["html"].setup {
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
    flags = lsp_flags,
  }

  -- CSS
  lspconfig["cssls"].setup {
    on_attach = on_attach_with_format,
    capabilities = default_capabilities,
    flags = lsp_flags,
  }

  if arduino_ok then
    lspconfig["arduino_language_server"].setup {
      on_attach = on_attach,
      capabilities = default_capabilities,
      flags = lsp_flags,
      on_new_config = arduino.on_new_config,
      filetypes = { "arduino" },
    }
  end
end)

-- formatter.nvim ------------------------------------------------------------

safe_require("formatter", function(formatter)
  formatter.setup {
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {

      lua = {
        function()
          return {
            exe = path.concat { mason_bin_dir, "stylua" },
            -- stdin = true,
            -- try_node_modules = true,
          }
        end,
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
end)

-- completion ----------------------------------------------------------------

require "config.cmp"

-- look ----------------------------------------------------------------------

require("tabline").setup {
  show_index = true,
  show_modify = true,
  modify_indicator = "[+]",
  no_name = "[No name]",
}

require("gitsigns").setup()

require("hardline").setup {
  bufferline = false,
  bufferline_settings = {
    exclude_terminal = false,
    show_index = false,
  },
  theme = "default",
  sections = { -- define sections
    { class = "mode", item = require("hardline.parts.mode").get_item },
    {
      class = "high",
      item = require("hardline.parts.git").get_item,
      hide = 100,
    },
    { class = "med", item = require("hardline.parts.filename").get_item },
    "%<",
    { class = "med", item = "%=" },
    {
      class = "low",
      item = require("hardline.parts.wordcount").get_item,
      hide = 100,
    },
    { class = "error", item = require("hardline.parts.lsp").get_error },
    { class = "warning", item = require("hardline.parts.lsp").get_warning },
    { class = "warning", item = require("hardline.parts.whitespace").get_item },
    {
      class = "high",
      item = require("hardline.parts.filetype").get_item,
      hide = 60,
    },
    { class = "mode", item = require("hardline.parts.line").get_item },
  },
}

-- Treesitter ----------------------------------------------------------------

local ts_path = tostring(vim.fn.stdpath "data") .. "ts_parsers"

safe_require("nvim-treesitter.configs", function(ts)
  vim.opt.runtimepath:append(ts_path) -- parsers directory

  ts.setup {
    ensure_installed = { "cpp", "c", "python", "bash", "ruby", "lua" },
    sync_install = false,
    auto_install = false,

    parser_install_dir = ts_path,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
end)

-- Telescope ------------------------------------------------------------------

safe_require("telescope", function(telescope)
  telescope.setup {
    theme = "ivy",
    extensions = {
      file_browser = {
        dir_icon = "‣",
        hidden = true,
      },
    },
  }
  pcall(telescope.load_extension, "file_browser")

  local builtin = require "telescope.builtin"

  map("n", "<leader>tf", builtin.find_files, default_map)
  map("n", "<Space>", "<cmd>Telescope file_browser<cr>", default_map)
  map("n", "<leader>tsg", builtin.git_status, default_map)
  map("n", "<leader>tg", builtin.live_grep, default_map)
  map("n", "<leader>tgs", builtin.grep_string, default_map)
  map("n", "<leader>tb", builtin.buffers, default_map)
  map("n", "<leader>th", builtin.help_tags, default_map)
  map("n", "<leader>tk", builtin.keymaps, default_map)
end)

require("Comment").setup()

-------------------------------------------------------------------------------
-- Backup
-------------------------------------------------------------------------------

local function get_backup_directory()
  local dir = vim.fn.stdpath "data" .. "/backup"
  if vim.fn.isdirectory(dir) ~= 1 then vim.fn.mkdir(dir, "p", "0700") end
  return dir
end

option.backup = true
option.backupdir = get_backup_directory()
option.backupcopy = "yes" -- Make a copy and overwrite the original file

-------------------------------------------------------------------------------
-- Dashboard
-------------------------------------------------------------------------------

safe_require("dashboard", function(db)
  db.custom_header = {
    "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
    "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  }
  db.custom_center = {
    {
      desc = "File browser",
      action = "Telescope file_browser",
    },
    {
      desc = "Find file",
      action = "Telescope find_files",
    },
    {
      desc = "Git status",
      action = "Telescope git_status",
    },
  }
end)
