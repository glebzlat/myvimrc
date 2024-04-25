-- Colorscheme saver

local log_levels = vim.log.levels
local path = require("feature.path")

---@class ColorschemeSaver
---@field colorscheme_file string path to a file with the colorscheme data
---@field colorscheme string current colorscheme, read from the colorscheme_file
---@field background? string
local M = {
  colorscheme_file = path.concat({
    vim.fn.stdpath("data"),
    "colorscheme-saver.lua",
  }),
}

---@return nil|string, string?
local function _get_colorscheme()
  local ok, data = pcall(dofile, M.colorscheme_file)
  if not ok then return nil end
  return data.colorscheme, data.background
end

---@param background string?
local function _valid_background_option(background)
  if background and background ~= "dark" and background ~= "light" then
    vim.notify(
      'background may be either "light" or "dark", not "' .. background .. '"',
      log_levels.ERROR
    )
    return false
  end
  return true
end

---@param name string colorscheme name
---@param background string? either "light" or "dark"
local function _write_colorscheme(name, background)
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
  if background then config["background"] = background end

  f:write("return " .. vim.inspect(config) .. "\n")
  f:close()
end

---@return nil|table
local function _colorscheme_list()
  local scheme_files = vim.fn.globpath(vim.o.runtimepath, "colors/*.vim")
    .. vim.fn.globpath(vim.o.runtimepath, "colors/*.lua")
  local files_list = vim.fn.split(scheme_files, "\n")
  local schemes = vim.fn.map(files_list, function(_, v)
    return vim.fn.fnamemodify(v, ":t:r")
  end)
  return vim.fn.uniq(schemes) ---@diagnostic disable-line
end

---@class ColorschemeSaverConfig
---@field default_scheme string default colorscheme
---@field background string? default appearance - light or dark

---@param colorscheme string colorscheme name
---@param background string?
local function _setup(colorscheme, background)
  M.colorscheme = colorscheme
  M.background = background

  local cmd = ("colorscheme %s"):format(M.colorscheme)
  vim.cmd(cmd)
  if M.background then
    cmd = ("set background=%s"):format(M.background)
    vim.cmd(cmd)
  end
end

---@param config? ColorschemeSaverConfig
function M.setup(config)
  config = config or {}
  vim.validate({
    default_scheme = { config.default_scheme, "string", true },
    background = { config.background, "string", true },
  })

  local colorscheme, background = _get_colorscheme()
  if not _valid_background_option(background) then return end

  if not colorscheme then
    -- if no default colorscheme set, neovim's default colorscheme
    -- will be applied implicitly
    if not config.default_scheme then return end
    colorscheme = config.default_scheme
    _write_colorscheme(colorscheme, background)
  end

  _setup(colorscheme, background)
end

vim.api.nvim_create_user_command("Colorscheme", function(opts)
  local args = opts.fargs
  local argslen = #args

  if argslen == 0 then
    local colorscheme = _get_colorscheme()
    if not colorscheme then return end
    print(colorscheme)
  else
    local colorscheme, background = args[1], args[2]
    if not _valid_background_option(background) then return end
    _write_colorscheme(colorscheme, background)
    _setup(colorscheme, background)
  end
end, {
  nargs = "*",
  desc = "Print or set current colorscheme",
  complete = function(_, cmdline, _)
    local parts = vim.tbl_filter(
      function(v)
        return #v > 0
      end,
      vim.fn.split(cmdline, " ") ---@diagnostic disable-line
    )

    local len = #parts

    if len < 2 then
      return _colorscheme_list()
    elseif len < 3 then
      return { "light", "dark" }
    end

    -- if #parts > 1 then return end
    -- return _colorscheme_list()
  end,
})

return M
