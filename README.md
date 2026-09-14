# Dotfiles

Personal development environment config for Linux containers.

## Contents

- `nvim/` - Neovim config (lazy.nvim, native LSP, blink-cmp, fzf-lua, catppuccin)
- `tmux.conf` - tmux config
- `bashrc` - Portable shell setup (editor, prompt, compiler switching, fzf)
- `bashrc.user` - Shell setup for environments with a managed `~/.bashrc` (prompt, fzf, bazel shorthands, history)
- `gitconfig` - Git defaults (set email per-machine)

## Prerequisites

- **Neovim** 0.11+ (0.12 for the `:lsp` command; `:LspRestart` no longer exists)
- **tmux**
- **fzf** - https://github.com/junegunn/fzf
- **bash-prompt-vcs** - https://github.com/meadowface/bash-prompt-vcs
  - `bashrc` reads `~/.bash-prompt-vcs.bash`; `bashrc.user` reads `~/bash-prompt-vcs.bash`
- **Git**
- **Node.js** (required by some LSP servers via Mason)
- **Java 11+** (required for jdtls)

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
- **Java**: With Maven or Gradle, nothing extra is needed. On Bazel there is no `pom.xml`/`build.gradle`, so jdtls imports the workspace as an "invisible project" and cannot discover source roots or third-party jars; copy `nvim/lua/plugins/lsp/jdtls_local.example.lua` to `jdtls_local.lua` and fill it in. jdtls also needs Java 21+ to launch, which that file can supply via `JAVA_HOME`.

## Install

There is deliberately no install script. Linking these files is four commands,
but two of them destroy data if something is already in the way, and one of them
is a judgement call that depends on the machine. Both are easier to get right by
reading than by trusting a script you run once a year.

### 1. Clone and look at what is already there

```bash
git clone <repo-url> ~/dotfiles
ls -la ~/.bashrc ~/.bashrc.user ~/.config/nvim ~/.tmux.conf ~/.gitconfig
```

Anything that already exists needs a decision before you overwrite it:

- **A symlink into an old clone** - safe to replace.
- **A regular file or a real directory with content** - `mv` it to `.bak` first.
  `ln -sfn` overwrites a regular file with no warning, and against a *real*
  directory it silently creates a link *inside* it (`~/.config/nvim/nvim`),
  which leaves the config quietly not loading.

### 2. Decide which bashrc applies

Some environments manage `~/.bashrc` themselves, regenerate it, and source
`~/.bashrc.user` for your additions. Replacing that file breaks them, often in
ways that only show up on the next rebuild. Check:

```bash
grep -l '\.bashrc\.user' ~/.bashrc
```

- **A match** - the file is managed. Link `bashrc.user`, and leave `~/.bashrc`
  strictly alone:

  ```bash
  ln -sfn ~/dotfiles/bashrc.user ~/.bashrc.user
  ```

- **No match** - link the standalone `bashrc`:

  ```bash
  ln -sfn ~/dotfiles/bashrc ~/.bashrc
  ```

Only one of the two. They overlap (each sets up the prompt and fzf), so
sourcing both gives you the work twice.

### 3. Link the rest

```bash
mkdir -p ~/.config
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sfn ~/dotfiles/gitconfig ~/.gitconfig
```

### 4. Fill in the machine-specific files

Two files are gitignored, because every value in them belongs to one machine or
one repository. Copy the `.example` sibling of each and edit:

- `nvim/lua/plugins/lsp/jdtls_local.lua` - a jdtls server config table. The
  comment above the `pcall` that loads it, in `nvim/lua/plugins/lsp/init.lua`,
  says what has to be in it. Without it jdtls falls back to its defaults, which
  on a Bazel workspace means no source roots and no third-party jars - and it
  will not start at all unless `java` on PATH is 21 or newer.
- `~/.bashrc.user.local` - anything site-specific: internal tooling, private
  hostnames, per-machine paths. Copy `bashrc.user.local.example` to start.

Both are optional.

Then set your git email:

```bash
git config --global user.email "you@company.com"
```

Open nvim and let lazy.nvim install plugins. Mason will handle LSP servers. Note: might have to use custom clangd binary
