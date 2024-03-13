-- Colorscheme saver

local log_levels = vim.log.levels
local path = require "feature.path"

---@class ColorschemeSaver
---@field colorscheme_file string path to a file with the colorscheme data
---@field colorscheme string current colorscheme, read from the colorscheme_file
local M = {
  colorscheme_file = path.concat {
    vim.fn.stdpath "data",
    "colorscheme-saver.lua",
  },
}

---@return nil|string
local function _get_colorscheme()
  local ok, data = pcall(dofile, M.colorscheme_file)
  if not ok then return nil end
  return data.colorscheme
end

---@param name string colorscheme name
local function _write_colorscheme(name)
  local f = io.open(M.colorscheme_file, "w")
  if not f then
    vim.notify(
      ("Failed to open file %s"):format(M.colorscheme_file),
      log_levels.ERROR,
      {}
    )
    return
  end
  local config = { colorscheme = name }
  f:write("return " .. vim.inspect(config) .. "\n")
  f:close()
end

---@return nil|table
local function _colorscheme_list()
  local scheme_files = vim.fn.globpath(vim.o.runtimepath, "colors/*.vim")
    .. vim.fn.globpath(vim.o.runtimepath, "colors/*.lua")
  local files_list = vim.fn.split(scheme_files, "\n")
  local schemes = vim.fn.map(
    files_list,
    function(_, v) return vim.fn.fnamemodify(v, ":t:r") end
  )
  return vim.fn.uniq(schemes) ---@diagnostic disable-line
end

---@class ColorschemeSaverConfig
---@field default_scheme string default colorscheme

---@param colorscheme string colorscheme name
local function _setup(colorscheme)
  M.colorscheme = colorscheme
  local cmd = ("colorscheme %s"):format(M.colorscheme)
  vim.cmd(cmd)
end

---@param config? ColorschemeSaverConfig
function M.setup(config)
  config = config or {}
  vim.validate { default_scheme = { config.default_scheme, "string", true } }

  local colorscheme = _get_colorscheme()
  if not colorscheme then
    -- if no default colorscheme set, neovim's default colorscheme
    -- will be applied implicitly
    if not config.default_scheme then return end
    colorscheme = config.default_scheme
    _write_colorscheme(colorscheme)
  end

  _setup(colorscheme)
end

vim.api.nvim_create_user_command("Colorscheme", function(opts)
  local args = opts.args
  local argslen = #args

  if argslen == 0 then
    local colorscheme = _get_colorscheme()
    if not colorscheme then return end
  else
    local colorscheme = args
    _write_colorscheme(colorscheme)
    _setup(colorscheme)
  end
end, {
  nargs = "?",
  desc = "Print or set current colorscheme",
  complete = function(_, cmdline, _)
    local parts = vim.tbl_filter(
      function(v) return #v > 0 end,
      vim.fn.split(cmdline, " ") ---@diagnostic disable-line
    )

    if #parts > 1 then return end
    return _colorscheme_list()
  end,
})

return M
