#!/bin/bash

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

ln -sf "$DOTFILES/nvim" ~/.config/nvim
ln -sf "$DOTFILES/tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES/bashrc" ~/.bashrc
ln -sf "$DOTFILES/gitconfig" ~/.gitconfig
