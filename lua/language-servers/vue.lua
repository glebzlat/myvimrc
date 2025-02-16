local mason = require("mason-registry")
local util = require("lspconfig.util")

local ok, ts_ls_path = pcall(mason.get_package, "typescript-language-server")
if not ok then return { "volar" } end

local function get_ts_path(root_dir)
  local global_ts = ts_ls_path .. "/node_modules/typescript/lib"
  local found_ts = ""

  local function check_dir(path)
    found_ts = table.concat({ path, "node_modules", "typescript", "lib" }, "/")
    if vim.uv.fs_stat(found_ts) then return path end
  end

  if util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    return global_ts
  end
end

return {
  "volar",
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_ts_path(new_root_dir)
  end,
}
