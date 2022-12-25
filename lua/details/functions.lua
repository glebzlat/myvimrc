table.unpack = table.unpack or unpack

function UpdateFolding()
  vim.api.nvim_input('zX')
end

function OpenAllFolds()
  vim.api.nvim_input('zR')
end

function SafeRequire(modules, callback, notify)
  notify = notify or true
  local notifymsg = function(module)
    if notify then
      vim.notify(module .. " not found", vim.log.levels.WARN)
    end
  end

  if type(modules) == "string" then
    modules = { modules }
  end

  local mods = {}

  for _, module in ipairs(modules) do
    local ok, mod = pcall(require, module)
    if not ok then
      notifymsg(module)
      return
    end

    table.insert(mods, mod)
  end

  callback(table.unpack(mods))
end
