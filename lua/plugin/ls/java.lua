local setup = function(lspconfig)
  local mason_package_path = require("mason-core.package"):get_install_path()
  local jdtls_path = mason_package_path .. "/jdtls"
  local path_to_plugins = jdtls_path .. "/plugins"
  local path_to_jar = path_to_plugins
    .. "/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"
  local lombok_path = jdtls_path .. "/lombok.jar"

  local root_dir_fn = require("lspconfig/util").root_pattern(
    ".git",
    "pom.xml",
    ".editorconfig",
    ".clang-format"
  )
  local root_dir = root_dir_fn(vim.fn.getcwd())

  local system = "linux"
  if vim.fn.has "mac" == 1 then
    system = "mac"
  elseif vim.fn.has "win32" == 1 then
    system = "windows"
  end

  local path_to_config = jdtls_path .. "/config_" .. system

  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.stdpath "data"
    .. "/site/workspace/java/"
    .. project_name

  lspconfig.jdtls.setup {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-javaagent:" .. lombok_path,
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",

      "-jar",
      path_to_jar,
      "-configuration",
      path_to_config,
      "-data",
      workspace_dir,
    },
    init_options = {
      workspace = root_dir,
    },
    root_dir = root_dir_fn,
    single_file_support = true,
  }
end

return setup
