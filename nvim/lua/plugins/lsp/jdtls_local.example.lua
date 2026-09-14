-- Copy to jdtls_local.lua and edit. The file is gitignored because every value
-- in it is specific to one machine and one repository.
--
-- On a Bazel repository there is no pom.xml or build.gradle, so jdtls imports
-- the workspace as an "invisible project": it cannot discover source roots or
-- third-party jars, and both have to be listed here. Paths are relative to the
-- workspace root.
local java_home = '/path/to/jdk-21'

local settings = {
  java = {
    configuration = {
      -- The JDK the project compiles against, which need not be the one jdtls
      -- itself runs on. Match `default` to the bytecode your build produces.
      runtimes = {
        { name = 'JavaSE-17', path = '/path/to/jdk-17', default = true },
        { name = 'JavaSE-21', path = '/path/to/jdk-21' },
      },
    },
    import = {
      -- Both default to true and would otherwise try to import the workspace.
      gradle = { enabled = false },
      maven = { enabled = false },
      exclusions = {
        '**/bazel-*/**',
        '**/external/**',
      },
    },
    project = {
      sourcePaths = {
        'module/src/main/java',
        'module/src/test/java',
      },
      -- Defaults to lib/**/*.jar, which finds nothing under a Bazel output
      -- tree, so external dependencies go unresolved until they are listed.
      referencedLibraries = {
        include = {
          'bazel-bin/external/**/*.jar',
        },
        exclude = {
          '**/*-sources.jar',
          '**/*-src.jar',
          '**/header_*.jar',
          '**/processed_*.jar',
        },
      },
    },
  },
}

return {
  cmd_env = {
    JAVA_HOME = java_home,
    PATH = java_home .. '/bin:' .. vim.env.PATH,
    -- lspconfig turns each token into --jvm-arg=<token>. The launcher default
    -- heap is far too small to index a large dependency set.
    JDTLS_JVM_ARGS = '-XX:+UseParallelGC -Xms2G -Xmx8G',
  },
  -- jdtls reads project.sourcePaths and referencedLibraries while importing,
  -- which happens before the didChangeConfiguration that Nvim drives from
  -- `settings`, so the same table has to arrive as an init option too.
  init_options = { settings = settings },
  settings = settings,
}
