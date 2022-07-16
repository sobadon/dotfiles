#!/bin/bash

# install asdf
# https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2

# install dein.vim
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm ./installer.sh

rm -rf ~/.config
rm -rf ~/.tmux.conf
rm -rf ~/.bashrc
rm -rf ~/.zshrc
rm -rf ~/.ssh/rc


DOT_DIR="${HOME}/dotfiles"

#  ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}

ln -snfv ${DOT_DIR}/.config ~/.config
ln -snfv ${DOT_DIR}/.tmux.conf ~/.tmux.conf
ln -snfv ${DOT_DIR}/.bashrc ~/.bashrc
ln -snfv ${DOT_DIR}/.zshrc ~/.zshrc
ln -snfv ${DOT_DIR}/.ssh/rc ~/.ssh/rc
