---Get path to Python executable, nil if not found
---@return string?
local function get_python_exepath()
  return vim.fn.exepath("python3")
    or vim.fn.exepath("python")
    or vim.fn.exepath("py")
end

---Get Pip command
---@param python_path string
---@return nil|table[string]
local function get_pip_command(python_path)
  local pip = vim.fn.exepath("pip3") or vim.fn.exepath("pip")
  if pip then
    pip = { pip }
  else
    pip = { python_path, "-m", "pip" }
    local obj = vim.system(pip):wait()
    if obj.code ~= 0 then return nil end
  end
  return pip
end

---Collect all paths where Pip stores packages and add them as extra_paths
---@param pip table[string]
---@return nil|table[string]
local function get_python_extra_paths(pip)
  local command = { table.unpack(pip), "list", "-v", "--format", "json" }
  local result = vim.system(command, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify(
      'process "'
        .. table.concat(command, " ")
        .. '" exited with code '
        .. result.code,
      vim.log.levels.DEBUG
    )
    return nil
  end

  local data = vim.json.decode(result.stdout, {
    luanil = { object = true, array = true },
  })

  local paths = {}
  for _, obj in ipairs(data) do
    paths[obj.location] = 1
  end

  local i = 0
  local keyset = {}
  for k, _ in pairs(paths) do
    i = i + 1
    keyset[i] = k
  end

  return keyset
end

local function write_cache(cache_file, data)
  local f = io.open(cache_file, "w")
  if not f then
    vim.notify(
      ("failed to open file %s"):format(cache_file),
      vim.log.levels.ERROR,
      {}
    )
    return
  end
  f:write("return " .. vim.inspect(data) .. "\n")
  f:close()
end

---@class PythonExtraPathsGetter
---@field cache_file string path to a cache file
local M = {
  cache_file = table.concat(
    { vim.fn.stdpath("data"), "python-extra-paths.lua" },
    "/"
  ),
}

---Get extra paths from cache
---@return table
function M.get_paths()
  local ok, data = pcall(dofile, M.cache_file)
  if not ok then return {} end
  return data
end

vim.api.nvim_create_user_command("PythonExtraPaths", function(_)
  local python_exe = get_python_exepath()
  if not python_exe then
    print("python not found")
    return
  end

  local pip_cmd = get_pip_command(python_exe)
  if not pip_cmd then
    print("pip not found")
    return
  end

  local paths = get_python_extra_paths(pip_cmd)
  if not paths then
    print("error while getting the paths")
    return
  end

  write_cache(M.cache_file, paths)
end, {})

return M
