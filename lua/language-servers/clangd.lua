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

return {
  "clangd",
  cmd = {
    "clangd",
    "--completion-style=detailed",
    "--enable-config",
    clang_query_drivers_opt,
  },
}
