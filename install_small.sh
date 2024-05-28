#!/bin/bash

set -eu
set -o pipefail

# prepare custom binary
mkdir -p ~/.local/bin/

# install peco
PECO_VERSION=v0.5.10
wget https://github.com/peco/peco/releases/download/${PECO_VERSION}/peco_linux_amd64.tar.gz
tar xzvf peco_linux_amd64.tar.gz peco_linux_amd64/peco
mv peco_linux_amd64/peco ~/.local/bin/
rm -rf peco_linux_amd64.tar.gz peco_linux_amd64


rm -rf ~/.config
rm -rf ~/.tmux.conf
rm -rf ~/.bashrc
rm -rf ~/.zshrc
rm -rf ~/.ssh/rc
rm -rf ~/.digrc

DOT_DIR="${HOME}/dotfiles/small"
ln -snfv ${DOT_DIR}/.config ~/.config
ln -snfv ${DOT_DIR}/.tmux.conf ~/.tmux.conf
ln -snfv ${DOT_DIR}/.bashrc ~/.bashrc
ln -snfv ${DOT_DIR}/.zshrc ~/.zshrc
mkdir -p ~/.ssh
ln -snfv ${DOT_DIR}/.ssh/rc ~/.ssh/rc
ln -snfv ${DOT_DIR}/.digrc ~/.digrc

# まぜこぜ
mkdir -p ~/.local/bin/scripts
DOT_DIR="${HOME}/dotfiles"
ln -snfv ${DOT_DIR}/.local/bin/scripts ~/.local/bin/
