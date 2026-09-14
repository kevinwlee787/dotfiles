#!/bin/bash
# Symlinks this repo into place. Anything already there is moved to .bak first.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# ln -sfn overwrites a regular file silently, and against a real directory it
# links *inside* it instead of replacing it. Move it aside either way.
link() {
    local src=$1 dst=$2
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "$dst.bak"
        echo "moved existing $dst -> $dst.bak"
    fi
    ln -sfn "$src" "$dst"
    echo "linked $dst"
}

mkdir -p ~/.config
link "$DOTFILES/nvim" ~/.config/nvim
link "$DOTFILES/tmux.conf" ~/.tmux.conf
link "$DOTFILES/gitconfig" ~/.gitconfig

link "$DOTFILES/bashrc" ~/.bashrc

echo "done; open a new shell"
