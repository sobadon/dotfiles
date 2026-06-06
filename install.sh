#!/usr/bin/env bash

set -eu
set -o pipefail

# https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
if [ ! -d ~/.asdf ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
fi

if ! type mise > /dev/null 2>&1; then
  curl -sSfL --output install-mise.sh https://github.com/jdx/mise/releases/download/v2026.6.0/install.sh
  echo "b6ba278bfbdf76a5aa1a7cc5972832976a72d17408be489774367ffceed31efe  install-mise.sh" | sha256sum -c -
  chmod +x install-mise.sh
  export MISE_QUIET=1
  ./install-mise.sh
  rm -rf ./install-mise.sh
fi

DOT_DIR="${HOME}/dotfiles"

mkdir -p ~/.config
ln -snf ${DOT_DIR}/.config/git ~/.config/git
ln -snf ${DOT_DIR}/.config/nvim ~/.config/nvim
ln -snf ${DOT_DIR}/.config/systemd ~/.config/systemd
ln -snf ${DOT_DIR}/.config/wezterm ~/.config/wezterm
ln -snf ${DOT_DIR}/.config/zsh ~/.config/zsh
ln -snf ${DOT_DIR}/.config/mise ~/.config/mise

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
