return {
  "matveyt/neoclip",
  run = function()
    local plugin_path = vim.fn.stdpath "data"
      .. "/site/pack/packer/start/neoclip"
    local plugin_src_path = plugin_path .. "/src"

    local function handler(_, _, event)
      if event == "stderr" then
        vim.api.nvim_notify("Error compiling neoclip", vim.log.levels.WARN, {})
      elseif "stdout" then
        vim.api.nvim_notify(
          "Neoclip compiled successfully",
          vim.log.levels.INFO,
          {}
        )
      end
    end

    vim.fn.jobstart(
      "cmake -B build -S . && cmake --build build --target install",
      {
        cwd = plugin_src_path,
        on_stdout = handler,
        on_stderr = handler
      }
    )
  end,
}
