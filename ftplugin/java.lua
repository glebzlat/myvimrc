local mason_package_path = require("mason-core.package"):get_install_path()
local jdtls_path = mason_package_path .. "/jdtls/bin/jdtls"
local config = {
  cmd = { jdtls_path },
  root_dir = vim.fs.dirname(
    vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]
  ),
}
require("jdtls").start_or_attach(config)
