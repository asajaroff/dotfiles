#!/bin/bash

# vim setup
echo "Creating necesary directories for vim's swapfiles, backupfiles and undodir"
mkdir -p $HOME/.vim/swapfiles $HOME/.vim/swapfiles $HOME/.vim/backupfiles $HOME/.vim/undodir
echo "Generating symlink to vimrc"
ln -sf ~/.dotfiles/vimrc ~/.vimrc


# Install all needed software
# sudo pacman -Syu npm jre


