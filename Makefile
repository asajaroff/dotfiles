.DEFAULT_GOAL := help

# Include base configuration first
include makefiles/base.mk
include makefiles/system.mk

# Include feature modules
include makefiles/git.mk
include makefiles/shells.mk
include makefiles/editors.mk
include makefiles/tools.mk
include makefiles/kubernetes.mk

# Include OS-specific modules conditionally
ifeq ($(OS_FAMILY),Linux)
    include makefiles/distros/arch.mk
    include makefiles/distros/debian.mk
endif
ifeq ($(OS_FAMILY),Darwin)
    include makefiles/distros/macos.mk
endif

.PHONY: help init

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

init: git-config git-submodules-private workspace ## Initialize git-submodules