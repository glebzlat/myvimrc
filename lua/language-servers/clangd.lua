-- check if esp-idf exported. if so, then specify --query-driver option to
-- clangd to avoid errors
local esp_idf_path = os.getenv("IDF_PATH")
local clang_query_drivers_opt = nil
if esp_idf_path ~= nil then
  clang_query_drivers_opt = "--query-driver="
    .. os.getenv("HOME")
    .. "/.espressif/tools/xtensa-esp32-elf/"
    .. "**/xtensa-esp32-elf/bin/xtensa-esp32-elf-*"
end

local pico_sdk_path = os.getenv("PICO_SDK_PATH")
if pico_sdk_path ~= nil then
  local compiler = "arm-none-eabi-gcc"
  local arm_gcc_exepath = vim.fn.exepath(compiler)

  if arm_gcc_exepath == nil then
    vim.notify(
      ("PICO_SDK_PATH is set, but %s is not installed"):format(compiler),
      vim.log.levels.ERROR
    )
  else
    clang_query_drivers_opt = "--query-driver=" .. arm_gcc_exepath
  end
end

return {
  "clangd",
  cmd = {
    "clangd",
    "--completion-style=detailed",
    "--enable-config",
    clang_query_drivers_opt,
  },
}
