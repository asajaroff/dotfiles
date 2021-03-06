#!/bin/bash
# zsh theming
echo "General configurations"
mkdir -p ~/Workspace/Logs ~/Workspace/minikube ~/Workspace/Scripts ~/Workspace/tmp ~/Workspace/Repos ~/Projects

# echo "Installing ZSH"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Generating symlinks for ~/.zshrc" 
ln -sf ~/.dotfiles/zshrc ~/.zshrc
echo "Installing Bullet train theme"
wget http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
mv bullet-train.zsh-theme $ZSH_CUSTOM/themes

# vim setup
echo "Creating necesary directories for vim's swapfiles, backupfiles and undodir"
mkdir -p $HOME/.vim/swapfiles $HOME/.vim/swapfiles $HOME/.vim/backupfiles $HOME/.vim/undodir $HOME/.local/bin
echo "Generating symlink to vimrc"
ln -sf ~/.dotfiles/vimrc ~/.vimrc

# kops
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 $HOME/.local/bin/kops

# Install SRE Tools
echo "Installing aws cli for Linux"
curl -O https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py --user && pip install awscli --upgrade --user
echo "aws-iam-authenticator"
curl https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator -o aws-iam-authenticator
mv aws-iam-authenticator $HOME/.local/bin/aws-iam-authenticator
chmod +x $HOME/.local/bin/aws-iam-authenticator
echo "kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl

# kubens & kubectx
echo "kubens and kubectx"
curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -o kubectx
curl https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -o kubens
chmod +x kube* 
mv kube* $HOME/.local/bin/

# Terraform 
echo "Terraform 0.11 and 0.12"
curl https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip -o terraform11.zip
unzip terraform11.zip
mv terraform $HOME/.local/bin/terraform11
chmod +x $HOME/.local/bin/terraform11
ln -s $HOME/.local/bin/terraform11 $HOME/.local/bin/terraform11
rm -rf terraform terraform11.zip
curl https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip -o terraform12.zip
unzip terraform12.zip
chmod +x terraform
mv terraform $HOME/.local/bin/terraform12
chmod +x $HOME/.local/bin/terraform12
ln -s $HOME/.local/bin/terraform12 $HOME/.local/bin/terraform
rm -rf terraform terraform12.zip



echo "Mozilla SOPS"
wget https://github.com/mozilla/sops/releases/download/3.2.0/sops-3.2.0.linux
chmod +x sops-3.2.0.linux
mv sops $HOME/.local/bin/sops
echo "stern"
wget https://github.com/wercker/stern/releases/download/1.10.0/stern_linux_amd64
chmod +x stern_linux_amd64
mv stern_linux_amd64 $HOME/.local/bin/stern
echo "helm"
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz
tar -xvf helm-v2.9.1-linux-amd64.tar.gz
chmod +x ./linux-amd64/helm 
mv ./linux-amd64/helm $HOME/.local/bin/helm
