# Git configuration and submodule management

.PHONY: git-config git-submodules-private git-hooks lint

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

git-hooks: ## Install pre-commit hooks (requires pre-commit)
	@command -v pre-commit >/dev/null || { echo "pre-commit not installed (pipx install pre-commit)"; exit 1; }
	pre-commit install

lint: ## Run pre-commit hooks against all files
	@command -v pre-commit >/dev/null || { echo "pre-commit not installed (pipx install pre-commit)"; exit 1; }
	pre-commit run --all-files
