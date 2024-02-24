#!/bin/bash

# install asdf
# https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

rm -rf ~/.config
rm -rf ~/.tmux.conf
rm -rf ~/.bashrc
rm -rf ~/.zshrc
rm -rf ~/.ssh/rc
rm -rf ~/.digrc


DOT_DIR="${HOME}/dotfiles"

mkdir -p ~/.local/bin/scripts

#  ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}

ln -snfv ${DOT_DIR}/.config ~/.config
ln -snfv ${DOT_DIR}/.tmux.conf ~/.tmux.conf
ln -snfv ${DOT_DIR}/.bashrc ~/.bashrc
ln -snfv ${DOT_DIR}/.zshrc ~/.zshrc
ln -snfv ${DOT_DIR}/.ssh/rc ~/.ssh/rc
ln -snfv ${DOT_DIR}/.digrc ~/.digrc
ln -snfv ${DOT_DIR}/.local/bin/scripts ~/.local/bin/
