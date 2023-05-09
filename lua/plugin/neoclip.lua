return {
  "matveyt/neoclip",
  build = function()
    local plugin_path = vim.fn.stdpath "data"
      .. "/site/pack/packer/start/neoclip"
    local plugin_src_path = plugin_path .. "/src"

    local function handler(_, data, event)
      local loglevel = vim.log.levels.INFO
      if event == "stderr" then
        local msg = "Error compiling neoclip: " .. data .. "\n"
        vim.api.nvim_notify(msg, loglevel, {})
      elseif "stdout" then
        local msg = "Neoclip compiled successfully: " .. data .. "\n"
        vim.api.nvim_notify(msg, loglevel, {})
      else
        local msg = "Neoclip complilation process exited\n"
        vim.api.nvim_notify(msg, loglevel, {})
      end
    end

    vim.fn.jobstart(
      "cmake -B build -S . && cmake --build build --target install",
      {
        cwd = plugin_src_path,
        on_stdout = handler,
        on_stderr = handler,
      }
    )
  end,
}
