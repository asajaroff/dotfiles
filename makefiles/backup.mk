# Backup and restore existing dotfiles before applying symlinks

BACKUP_ROOT := ${HOME}/dotfiles-backups
BACKUP_TARGETS := \
    ${HOME}/.bashrc \
    ${HOME}/.zshrc \
    ${HOME}/.profile \
    ${HOME}/.tmux.conf \
    ${HOME}/.vimrc \
    ${HOME}/.emacs \
    ${HOME}/.gitconfig \
    ${HOME}/.ssh/config \
    ${HOME}/.config/starship.toml \
    ${HOME}/.config/nvim

.PHONY: backup restore backup-list

backup: ## Snapshot existing dotfiles to ~/dotfiles-backups/<timestamp>/
	@stamp=$$(date +%Y%m%d-%H%M%S); \
	dest="$(BACKUP_ROOT)/$$stamp"; \
	mkdir -p "$$dest"; \
	for f in $(BACKUP_TARGETS); do \
	    if [ -e "$$f" ] || [ -L "$$f" ]; then \
	        rel=$${f#$(HOME)/}; \
	        mkdir -p "$$dest/$$(dirname $$rel)"; \
	        cp -aP "$$f" "$$dest/$$rel"; \
	        echo "  backed up $$rel"; \
	    fi; \
	done; \
	echo "Backup saved to $$dest"

backup-list: ## List available backups
	@ls -1t $(BACKUP_ROOT) 2>/dev/null || echo "No backups yet."

restore: ## Restore from the most recent backup
	@latest=$$(ls -1t $(BACKUP_ROOT) 2>/dev/null | head -n1); \
	if [ -z "$$latest" ]; then \
	    echo "No backups in $(BACKUP_ROOT)"; exit 1; \
	fi; \
	src="$(BACKUP_ROOT)/$$latest"; \
	echo "Restoring from $$src"; \
	cd "$$src" && find . -type f -o -type l | while read f; do \
	    rel=$${f#./}; \
	    dest="$(HOME)/$$rel"; \
	    mkdir -p "$$(dirname $$dest)"; \
	    cp -aP "$$f" "$$dest"; \
	    echo "  restored $$rel"; \
	done
