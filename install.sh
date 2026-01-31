#!/bin/bash

set -eu
set -o pipefail

# https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
fi

export PATH=${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH
if ! type aqua > /dev/null 2>&1; then
curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.2/aqua-installer
echo "98b883756cdd0a6807a8c7623404bfc3bc169275ad9064dc23a6e24ad398f43d  aqua-installer" | sha256sum -c -
chmod +x aqua-installer
./aqua-installer
rm -rf ./aqua-installer
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

mkdir -p ~/.local/bin
rm -rf ~/.local/bin/scripts
ln -snf ${DOT_DIR}/.local/bin/scripts ~/.local/bin/scripts
