# Tool installations

# TENV variables
TENV_VERSION := 'v4.7.6'

# Istio variables
ISTIO_VERSION ?= 1.24.2
PLATFORM ?= linux-amd64
ISTIOCTL_BINARY = istioctl-$(ISTIO_VERSION)
ISTIOCTL_PATH = $(INSTALL_DIR)/$(ISTIOCTL_BINARY)
ISTIOCTL_SYMLINK = $(INSTALL_DIR)/istioctl
ISTIO_URL = https://github.com/istio/istio/releases/download/$(ISTIO_VERSION)/istioctl-$(ISTIO_VERSION)-$(PLATFORM).tar.gz
TARBALL = istioctl-$(ISTIO_VERSION)-$(PLATFORM).tar.gz

.PHONY: tenv tenv-arch istioctl bitwarden ipaddr

tenv: ## Download and install `tenv` from Github
	wget https://github.com/tofuutils/tenv/releases/download/${TENV_VERSION}/tenv_${TENV_VERSION}_Linux_x86_64.tar.gz

tenv-arch: ## Install tenv on Arch Linux
	$(call info,Installing tenv dependencies...)
	sudo pacman -S --needed cosign
	$(call info,Downloading tenv $(TENV_VERSION)...)
	wget https://github.com/tofuutils/tenv/releases/download/$(TENV_VERSION)/tenv_$(TENV_VERSION)_Linux_x86_64.tar.gz
	$(call info,Installing tenv to /usr/local/bin...)
	sudo tar -zxvf tenv_$(TENV_VERSION)_Linux_x86_64.tar.gz -C /usr/local/bin/
	$(call info,Cleaning up tarball...)
	rm -f tenv_$(TENV_VERSION)_Linux_x86_64.tar.gz
	$(call success,tenv $(TENV_VERSION) installed successfully)

istioctl: ## Install istioctl binary
	$(call info,Downloading istioctl $(ISTIO_VERSION)...)
	@if [ ! -f "$(TARBALL)" ]; then \
		wget -O "$(TARBALL)" "$(ISTIO_URL)"; \
	else \
		echo "Tarball $(TARBALL) already exists, skipping download."; \
	fi
	$(call info,Extracting istioctl...)
	tar -xzf "$(TARBALL)" istioctl
	$(call info,Installing istioctl to $(INSTALL_DIR)...)
	sudo mv istioctl "$(ISTIOCTL_PATH)"
	sudo chmod +x "$(ISTIOCTL_PATH)"
	sudo ln -sf "$(ISTIOCTL_PATH)" "$(ISTIOCTL_SYMLINK)"
	$(call info,Cleaning up tarball...)
	rm -f "$(TARBALL)"
	$(call success,istioctl $(ISTIO_VERSION) installed successfully)

bitwarden: ## Download Bitwarden CLI
	wget -L 'https://bitwarden.com/download/?app=cli&platform=linux'

ipaddr: ## Get outbound IP address of this host
	@echo "$(COLOR_INFO)ℹ Querying outbound IP address...$(COLOR_RESET)"
	@dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com
