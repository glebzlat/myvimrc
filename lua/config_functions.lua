table.unpack = table.unpack or unpack

function UpdateFolding()
  vim.api.nvim_input('zX')
end

function OpenAllFolds()
  vim.api.nvim_input('zR')
end

function SafeRequire(modules, callback)
  if type(modules) == "string" then
    modules = { modules }
  end

  local mods = {}

  for _, module in ipairs(modules) do
    local ok, mod = pcall(require, module)
    if not ok then
      vim.notify(module .. " not found", vim.log.levels.WARN)
      return
    end

    table.insert(mods, mod)
  end

  callback(table.unpack(mods))
end
