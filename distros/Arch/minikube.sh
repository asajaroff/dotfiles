# Install package dependencies
sudo pacman -Sy libvirt qemu ebtables dnsmasq
# Add to group
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
# Start services at boot
sudo systemctl start libvirtd.service
sudo systemctl enable libvirtd.service
sudo systemctl start virtlogd.service
sudo systemctl enable virtlogd.service
# Install Docker machine
sudo pacman -Sy docker-machine