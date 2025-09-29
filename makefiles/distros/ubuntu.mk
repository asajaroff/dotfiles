# Ubuntu/Debian specific targets

.PHONY: ubuntu

ubuntu: ## Install Ubuntu/Debian packages
	sudo apt update -y
	sudo apt install -y \
		build-essential \
		dnsutils \
		net-tools \
		netcat-traditional \
		jq yq
	sudo apt clean
	sudo apt autoremove