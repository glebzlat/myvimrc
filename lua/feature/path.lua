-- taken from here: https://github.com/williamboman/mason.nvim

local sep = (function()
  ---@diagnostic disable-next-line: undefined-global
  if jit then
    ---@diagnostic disable-next-line: undefined-global
    local os = string.lower(jit.os)
    if os == "linux" or os == "osx" or os == "bsd" then
      return "/"
    else
      return "\\"
    end
  else
    return string.sub(package.config, 1, 1)
  end
end)()

local M = {}

---@param path_components string[]
---@return string
function M.concat(path_components)
  return table.concat(path_components, sep)
end

return M
