#!/bin/bash

set -eu
set -o pipefail

# install peco
PECO_VERSION=v0.5.10
wget https://github.com/peco/peco/releases/download/${PECO_VERSION}/peco_linux_amd64.tar.gz
tar xzvf peco_linux_amd64.tar.gz peco_linux_amd64/peco
mv peco_linux_amd64/peco ~/.local/bin/
rm -rf peco_linux_amd64.tar.gz peco_linux_amd64

DOT_DIR="${HOME}/dotfiles/small"

mkdir -p ~/.config
ln -snf ${DOT_DIR}/.config/git ~/.config/git
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
