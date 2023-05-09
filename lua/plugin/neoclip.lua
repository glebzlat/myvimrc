return {
  "matveyt/neoclip",
  build = function()
    local plugin_path = vim.fn.stdpath "data" .. "/lazy/neoclip"
    local src_path = plugin_path .. "/src"
    local build_path = src_path .. "/build"
    local configure = "cmake -B " .. build_path .. " -S " .. src_path
    local build = "cmake --build " .. build_path .. " --target install"
    local cmd = configure .. " && " .. build

    local output = vim.fn.system(cmd)
    vim.api.nvim_notify(output, vim.log.levels.INFO, {})
  end,
}
