local util = require("lspconfig.util")

local function get_vue_plugin_path(root_dir)
  local global_path = "/usr/local/lib/node_modules/@vue/typescript-plugin"
  local found_path = ""

  local tbl = {
    name = "@vue/typescript-plugin",
    location = global_path,
    languages = { "typescript", "vue" },
  }

  local function check_dir(path)
    found_path =
      util.path.join(path, "node_modules", "@vue", "typescript-plugin")
    if vim.uv.fs_stat(found_path) then return path end
  end

  if util.search_ancestors(root_dir, check_dir) then
    tbl.location = found_path
    return tbl
  elseif not vim.uv.fs_stat(global_path) then
    return nil
  else
    return tbl
  end
end

return {
  "ts_ls",
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.plugins = { get_vue_plugin_path(new_root_dir) }
  end,
}
