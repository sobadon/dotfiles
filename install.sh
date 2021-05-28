#!/bin/bash

# install anyenv
git clone https://github.com/anyenv/anyenv ${HOME}/.anyenv
${HOME}/.anyenv/bin/anyenv init
# anyenv install --init

# install dein.vim
mkdir -p ~/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.cache/dein
rm ./installer.sh

rm -rf ~/.config
rm -rf ~/.tmux.conf
rm -rf ~/.bashrc
rm -rf ~/.zshrc
rm -rf ~/.vimrc
rm -rf ~/.zprofile
rm -rf ~/.ssh/rc


DOT_DIR="${HOME}/dotfiles"

#  ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}

ln -snfv ${DOT_DIR}/.config ~/.config
ln -snfv ${DOT_DIR}/.tmux.conf ~/.tmux.conf
ln -snfv ${DOT_DIR}/.bashrc ~/.bashrc
ln -snfv ${DOT_DIR}/.zshrc ~/.zshrc
ln -snfv ${DOT_DIR}/.vimrc ~/.vimrc
ln -snfv ${DOT_DIR}/.zprofile ~/.zprofile
ln -snfv ${DOT_DIR}/.ssh/rc ~/.ssh/rc

