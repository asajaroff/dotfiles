# Alejandro's dotfiles

*This is a constantly changing configuration meant to keep track of my workspace*

## Prerequisites
* A POSIX compatible shell
* `cmake`/`make`


### Arch
```bash
pacman -Syu base-devel
```


### Ubuntu
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install \
    build-essential \
    dnsutils
```

### MacOS
Make sure to install install [brew](https://brew.sh/) by running:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Usage
As indicated by the requriments, all you need is `make` (not love).

```bash
make setup
```
## Private submodules.
Faced with the problem of keeping track of my private config files, I'm trying to figure out how do so.

For this, I've come with the [git-submodules]() option which makes the most sense to me.

To grab the private repo 
```bash
make sync-private
```
