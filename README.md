# Dotfiles

Personal development environment config for Linux containers.

## Contents

- `nvim/` - Neovim config (lazy.nvim, native LSP, blink-cmp, fzf-lua, catppuccin)
- `tmux.conf` - tmux config
- `bashrc` - Portable shell setup (editor, prompt, compiler switching, fzf)
- `gitconfig` - Git defaults (set email per-machine)
- `install.sh` - Symlinks everything into place

## Prerequisites

- **Neovim** 0.10+
- **tmux**
- **fzf** - https://github.com/junegunn/fzf
- **bash-prompt-vcs** - https://github.com/meadowface/bash-prompt-vcs
  - Copy `bash-prompt-vcs.bash` to `~/.bash-prompt-vcs.bash`
- **Git**
- **Node.js** (required by some LSP servers via Mason)
- **Java 11+** (required for jdtls)

## LSP Servers

Managed by Mason (auto-installed on first launch):

- `clangd` - C/C++ (update path in `nvim/lua/plugins/lsp/init.lua` if not in PATH)
- `jdtls` - Java
- `basedpyright` - Python
- `lua_ls` - Lua
- `rust_analyzer` - Rust

### Project setup

- **C/C++**: Requires `compile_commands.json` at the project root for clangd to resolve includes and flags. Generate with `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`.
- **Java**: No extra files needed. jdtls reads `pom.xml` (Maven) or `build.gradle` (Gradle) directly.

## Install

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then set your git email:

```bash
git config --global user.email "you@company.com"
```

Open nvim and let lazy.nvim install plugins. Mason will handle LSP servers. Note: might have to use custom clangd binary
