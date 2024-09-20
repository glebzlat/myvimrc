local mason_package_path = require("mason-core.package"):get_install_path()
local jdtls_dir = mason_package_path .. "/jdtls"
local jdtls_bin_path = jdtls_dir .. "/bin/jdtls"

local plugins_dir = jdtls_dir .. "/plugins"
local launcher_path =
  vim.fn.glob(plugins_dir .. "/org.eclipse.ecuinox.launcher_*")

local config_dir
if jit.os == "Linux" then
  config_dir = "config_linux"
elseif jit.os == "Windows" then
  config_dir = "config_win"
elseif jit.os == "OSX" then
  config_dir = "config_mac"
end
config_dir = jdtls_dir .. "/" .. config_dir

local config = {
  cmd = {
    jdtls_bin_path,
    "-jar",
    launcher_path,
    "-configuration",
    config_dir,

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
  },
  root_dir = vim.fs.dirname(
    vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]
  ),
}
require("jdtls").start_or_attach(config)
