# Debian specific targets

.PHONY: all clean test debian

all:
clean:
test:

debian: ## Install Debian packages
	sudo apt update -y
	sudo apt install -y \
		build-essential \
		dnsutils \
		net-tools \
		netcat-traditional \
		jq \
		yq
	sudo apt clean
	sudo apt autoremove