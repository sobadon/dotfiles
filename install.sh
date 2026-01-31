#!/bin/bash

set -eu
set -o pipefail

# https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
fi

DOT_DIR="${HOME}/dotfiles"

mkdir -p ~/.config
ln -snf ${DOT_DIR}/.config/aquaproj-aqua ~/.config/aquaproj-aqua
ln -snf ${DOT_DIR}/.config/git ~/.config/git
ln -snf ${DOT_DIR}/.config/nvim ~/.config/nvim
ln -snf ${DOT_DIR}/.config/systemd ~/.config/systemd
ln -snf ${DOT_DIR}/.config/wezterm ~/.config/wezterm
ln -snf ${DOT_DIR}/.config/zsh ~/.config/zsh

rm -rf ~/.tmux.conf
ln -snf ${DOT_DIR}/.tmux.conf ~/.tmux.conf

rm -rf ~/.bashrc
ln -snf ${DOT_DIR}/.bashrc ~/.bashrc

rm -rf ~/.zshrc
ln -snf ${DOT_DIR}/.zshrc ~/.zshrc

mkdir -p ~/.ssh
rm -rf ~/.ssh/rc
ln -snf ${DOT_DIR}/.ssh/rc ~/.ssh/rc

rm -rf ~/.digrc
ln -snf ${DOT_DIR}/.digrc ~/.digrc

ln -snf ${DOT_DIR}/.local/bin/scripts ~/.local/bin/
