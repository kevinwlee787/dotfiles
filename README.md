# Dotfiles

Personal development environment config for Linux containers.

## Contents

- `nvim/` - Neovim config (lazy.nvim, native LSP, blink-cmp, fzf-lua, catppuccin)
- `tmux.conf` - tmux config
- `bashrc` - Shell setup (editor, prompt, fzf, tmux, history)
- `gitconfig` - Git defaults (set email per-machine)
- `install.sh` - Symlinks everything into place

## Prerequisites

- **Neovim** 0.11+ (0.12 for the `:lsp` command; `:LspRestart` no longer exists)
- **tmux**
- **fzf** - https://github.com/junegunn/fzf
- **bash-prompt-vcs** - https://github.com/meadowface/bash-prompt-vcs
  - copy `bash-prompt-vcs.bash` to `~/.bash-prompt-vcs.bash`
- **Git**
- **Node.js** (required by some LSP servers via Mason)
- **Java 21+** (jdtls refuses to launch below 21)

## LSP Servers

Managed by Mason (auto-installed on first launch):

- `clangd` - C/C++ (deliberately **not** from Mason; uses the toolchain's own clangd from PATH)
- `jdtls` - Java
- `basedpyright` - Python
- `lua_ls` - Lua
- `rust_analyzer` - Rust
- `starpls` - Starlark / Bazel BUILD files
- `bazelrc_lsp` - `.bazelrc` files

### Project setup

- **C/C++**: Requires `compile_commands.json` at the project root. Generate with `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, or with whatever your build system provides.
- **Java**: With Maven or Gradle, nothing extra is needed. On Bazel there is no `pom.xml`/`build.gradle`, so jdtls imports the workspace as an "invisible project" and needs `java.project.sourcePaths` and `referencedLibraries` set per repository.

## Install

```bash
git clone <repo-url> ~/dotfiles
~/dotfiles/install.sh
```

It symlinks `nvim`, `tmux.conf`, `gitconfig` and `bashrc` into place, moving
anything already there to `.bak` rather than overwriting it, so it is safe on a
machine that already has config.

It assumes bash reads `~/.bashrc`, which is not true on macOS: Terminal opens
login shells, and the default shell is zsh.

For machine-specific settings, `bashrc` sources `~/.bashrc.local` if it exists.

Then set your git email:

```bash
git config --global user.email "you@company.com"
```

Open nvim and let lazy.nvim install plugins. Mason will handle LSP servers. Note: might have to use custom clangd binary
