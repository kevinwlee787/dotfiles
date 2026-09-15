# Dotfiles

Personal development environment config for Linux containers.

## Contents

- `nvim/` - Neovim config (lazy.nvim, native LSP, blink-cmp, fzf-lua, catppuccin)
- `tmux.conf` - tmux config
- `bashrc` - Shell setup (editor, prompt, fzf, tmux, history)
- `gitconfig` - Git defaults (set email per-machine)
- `install.sh` - Symlinks everything into place

## Prerequisites

- **Neovim** 0.12+
- **tmux**
- **fzf** - https://github.com/junegunn/fzf
- **bash-prompt-vcs** - https://github.com/meadowface/bash-prompt-vcs
  - copy `bash-prompt-vcs.bash` to `~/.bash-prompt-vcs.bash`
- **Git**
- **Java 21+** - jdtls refuses to launch below 21
- **rustup** - only if you want `rust_analyzer`

## LSP Servers

- `clangd` - C/C++. Not installed by Mason, see below.
- `basedpyright` - Python. Installed by Mason on first launch.
- `jdtls` - Java. Installed by Mason on first launch.
- `rust_analyzer` - Rust, run through `rustup`.
- `lua_ls` - Lua, for editing this config. Install it with `:Mason`.

Java and Rust are configured at defaults, with no per-project setup. To add a
server, put an entry in the `servers` table in `nvim/lua/plugins/lsp/init.lua`
and add it to `ensure_installed` if Mason should fetch it.

### Project setup

- **C/C++**: Requires `compile_commands.json` at the project root. Generate with
  `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, or with whatever your build system
  provides.
- **Java**: With Maven or Gradle, nothing extra is needed. Build systems without
  a project file need `java.project.sourcePaths` and `referencedLibraries` set.

## Install

```bash
git clone <repo-url> ~/dotfiles
~/dotfiles/install.sh
```

It symlinks `nvim`, `tmux.conf`, `gitconfig` and `bashrc` into place, moving
anything already there to `.bak` rather than overwriting it, so it is safe on a
machine that already has config.

Then set your git email:

```bash
git config --global user.email "you@company.com"
```

Open nvim and let lazy.nvim install plugins. Mason will handle the LSP servers.

### clangd

Mason does not install clangd, and the config invokes a bare `clangd`, so
whichever one is first on `PATH` wins. That is deliberate: a toolchain
frequently ships its own clang build, patched for that codebase's libraries and
tooling, and a stock clangd will disagree with it about include paths, standard
library internals and flags. Putting the toolchain's `bin` on `PATH` ahead of
anything else is usually enough. Where it is not, set an absolute path in
`cmd` in `nvim/lua/plugins/lsp/init.lua`.

`:checkhealth vim.lsp` reports the resolved binary and its version.
