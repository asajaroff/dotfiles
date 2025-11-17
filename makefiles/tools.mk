# Tool installations

# TENV variables
TENV_VERSION := 'v4.7.6'

.PHONY: tenv tenv-arch bitwarden ipaddr all clean test

all:
clean:
test:

tenv: ## Download and install `tenv` from Github
	wget https://github.com/tofuutils/tenv/releases/download/${TENV_VERSION}/tenv_${TENV_VERSION}_Linux_x86_64.tar.gz

tenv-arch: ## Install tenv on Arch Linux
	sudo pacman -S --needed cosign
	wget https://github.com/tofuutils/tenv/releases/download/$(TENV_VERSION)/tenv_$(TENV_VERSION)_Linux_x86_64.tar.gz
	sudo tar -zxvf tenv_$(TENV_VERSION)_Linux_x86_64.tar.gz -C /usr/local/bin/
	rm -f tenv_$(TENV_VERSION)_Linux_x86_64.tar.gz

bitwarden: ## Download Bitwarden CLI
	wget -L 'https://bitwarden.com/download/?app=cli&platform=linux'

ipaddr: ## Get outbound IP address of this host
	dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com
