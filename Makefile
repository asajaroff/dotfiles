

all:
	echo $(OS_ARCH)

## Programming
GOBIN ?= (shell go bin) # Will only occur if GOBIN is not already present


OS_ARCH= (shell )

.PHONY: test kubernetes

test:
	echo ${OS_ARCH}

kubernetes:
ifeq ($(OS_ARCH),darwin)
	KUBERNETES_VERSION := (shell curl -L -s https://dl.k8s.io/release/stable.txt)
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
	xattr -d com.apple.quarantine kubectl
	chmod +x kubectl
	mv kubectl /usr/local/bin/kubectl-$(curl -L -s https://dl.k8s.io/release/stable.txt)
	echo $(KUBERNETES_VERSION)
endif

shells: bash zsh

bash:

zsh:
