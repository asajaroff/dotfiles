#!/bin/bash

# ZSH setup
echo "Installing ZSH"
# CURL
echo "Generating symlinks for ~/.zshrc" 
ln -sf ~/.dotfiles/zshrc ~/.zshrc

# vim setup
echo "Creating necesary directories for vim's swapfiles, backupfiles and undodir"
mkdir -p $HOME/.vim/swapfiles $HOME/.vim/swapfiles $HOME/.vim/backupfiles $HOME/.vim/undodir $HOME/.local/bin
echo "Generating symlink to vimrc"
ln -sf ~/.dotfiles/vimrc ~/.vimrc


# Install all needed software
# sudo pacman -Syu npm jre

# Install SRE software

# aws-iam-authenticator
curl -o https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
mv aws-iam-authenticator $HOME/.local/bin/aws-iam-authenticator
chmod +x $HOME/.local/bin/aws-iam-authenticator

# kubens & kubectx
curl -o https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx 
curl -o https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens
chmod +x kube* 
mv kube* $HOME/.local/bin/

