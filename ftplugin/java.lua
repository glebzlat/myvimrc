local mason = require("mason-registry")
local jdtls_path = mason.get_package("jdtls"):get_install_path()

local launcher_path =
  vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok_path = jdtls_path .. "/lombok.jar"

local config_dir
if jit.os == "Linux" then
  config_dir = "linux"
elseif jit.os == "Windows" then
  config_dir = "win"
elseif jit.os == "OSX" then
  config_dir = "mac"
end
config_dir = jdtls_path .. "/config_" .. config_dir

local project_data_dir = vim.fn.getcwd()

local config = {
  cmd = {
    vim.fn.exepath("java"),

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

    "-javaagent:" .. lombok_path,

   "-jar",
    launcher_path,
    "-configuration",
    config_dir,

    "-data",
    project_data_dir,
  },

  root_dir = vim.fs.root(0, { ".git", "mvnw", "pom.xml", "gradlew" }),

  settings = {
    java = {
      server = { launchMode = "Hybrid" },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
    },
    references = { includeDecompiledSources = true },
    redhat = { telemetry = { enabled = false } },
  },
}

require("jdtls").start_or_attach(config)
