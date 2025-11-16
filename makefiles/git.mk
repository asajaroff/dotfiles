# Git configuration and submodule management

.PHONY: git-config git-submodules-private gitconfig

git-submodules-private: ## Fetch and pull private git-submodules (requires auth)
ifneq ($(wildcard ${DOTFILES_DIR}/private),)
	echo "Found a 'private' directory"
	exit 0
else
	echo "Did not find a 'private' directory, so let's clone it"
	git submodule update --init --recursive private
endif

git-config: ## Configure git user and email
	git config --global user.name "Alejandro Sajaroff"
	git config --global user.email "29068982+asajaroff@users.noreply.github.com"

gitconfig: ## Symlink gitconfig to ~/.gitconfig
	$(call log_info,"Setting up gitconfig")
	$(call symlink,${DOTFILES_DIR}/config/gitconfig,${HOME}/.gitconfig)