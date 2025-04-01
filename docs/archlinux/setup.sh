#!/usr/bin/env bash
#
# Script to install tools for EEN networks on Arch Linux

## Virtualization tools, docker, docker-compose and minikube
sudo pacman -Sy libvirt qemu-base dnsmasq cockpit-machines gnome-boxes

# Add necesary permissions to user
sudo usermod -aG libvirt ${USER}


# Setup `docker`
sudo pacman -Sy docker docker-compose docker-buildx