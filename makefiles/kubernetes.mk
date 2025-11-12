# Kubernetes tools installation

.PHONY: kubernetes kubectx

kubernetes: ## Install kubectl, kubens, kubectx and helm
ifeq ($(OS_FAMILY),Darwin)
	$(eval KUBERNETES_VERSION := $(shell curl -L -s https://dl.k8s.io/release/stable.txt))
	curl -LO "https://dl.k8s.io/release/$(KUBERNETES_VERSION)/bin/darwin/amd64/kubectl"
	xattr -d com.apple.quarantine kubectl
	chmod +x kubectl
	mv kubectl /usr/local/bin/kubectl-$(KUBERNETES_VERSION)
	echo $(KUBERNETES_VERSION)
endif

kubectx: ## Setup kubectx and kubens from git
	$(call info,Cloning kubectx repository...)
	sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
	sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
	sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens
ifeq ($(IS_ARCH),true)
	$(call info,Installing fzf on Arch Linux...)
	sudo pacman -S --needed fzf
else ifeq ($(IS_DEBIAN),true)
	$(call info,Installing fzf on Debian...)
	sudo apt install -y fzf
else ifeq ($(IS_MACOS),true)
	$(call info,Installing fzf on macOS...)
	brew install fzf
endif
	$(call success,kubectx and kubens installed successfully)