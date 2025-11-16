# Backup and restore mechanism for dotfiles

.PHONY: backup restore list-backups

BACKUP_DIR := ${HOME}/dotfiles-backup
TIMESTAMP := $(shell date +%Y%m%d-%H%M%S)
BACKUP_PATH := ${BACKUP_DIR}/${TIMESTAMP}

backup: ## Backup current configs before applying dotfiles
	$(call log_info,"Creating backup at ${BACKUP_PATH}")
	@mkdir -p ${BACKUP_PATH}
	@echo "Backing up existing configurations..."
	@if [ -f ${HOME}/.bashrc ]; then cp ${HOME}/.bashrc ${BACKUP_PATH}/bashrc; fi
	@if [ -f ${HOME}/.zshrc ]; then cp ${HOME}/.zshrc ${BACKUP_PATH}/zshrc; fi
	@if [ -f ${HOME}/.tmux.conf ]; then cp ${HOME}/.tmux.conf ${BACKUP_PATH}/tmux.conf; fi
	@if [ -f ${HOME}/.gitconfig ]; then cp ${HOME}/.gitconfig ${BACKUP_PATH}/gitconfig; fi
	@if [ -f ${HOME}/.gitignore_global ]; then cp ${HOME}/.gitignore_global ${BACKUP_PATH}/gitignore_global; fi
	@if [ -d ${HOME}/.ssh ]; then cp -r ${HOME}/.ssh ${BACKUP_PATH}/ssh; fi
	@if [ -d ${HOME}/.config/nvim ]; then cp -r ${HOME}/.config/nvim ${BACKUP_PATH}/nvim; fi
	@if [ -d ${HOME}/.emacs.d ]; then cp -r ${HOME}/.emacs.d ${BACKUP_PATH}/emacs.d; fi
	@echo "Backup location: ${BACKUP_PATH}" > ${BACKUP_PATH}/backup-info.txt
	@echo "Backup date: ${TIMESTAMP}" >> ${BACKUP_PATH}/backup-info.txt
	@echo "Hostname: $$(hostname)" >> ${BACKUP_PATH}/backup-info.txt
	$(call log_success,"Backup completed at ${BACKUP_PATH}")

restore: ## Restore configs from most recent backup
	@if [ ! -d ${BACKUP_DIR} ]; then \
		echo "No backups found in ${BACKUP_DIR}"; \
		exit 1; \
	fi
	$(eval LATEST_BACKUP := $(shell ls -t ${BACKUP_DIR} | head -n 1))
	@if [ -z "${LATEST_BACKUP}" ]; then \
		echo "No backups found"; \
		exit 1; \
	fi
	$(call log_info,"Restoring from ${BACKUP_DIR}/${LATEST_BACKUP}")
	@if [ -f ${BACKUP_DIR}/${LATEST_BACKUP}/bashrc ]; then cp ${BACKUP_DIR}/${LATEST_BACKUP}/bashrc ${HOME}/.bashrc; fi
	@if [ -f ${BACKUP_DIR}/${LATEST_BACKUP}/zshrc ]; then cp ${BACKUP_DIR}/${LATEST_BACKUP}/zshrc ${HOME}/.zshrc; fi
	@if [ -f ${BACKUP_DIR}/${LATEST_BACKUP}/tmux.conf ]; then cp ${BACKUP_DIR}/${LATEST_BACKUP}/tmux.conf ${HOME}/.tmux.conf; fi
	@if [ -f ${BACKUP_DIR}/${LATEST_BACKUP}/gitconfig ]; then cp ${BACKUP_DIR}/${LATEST_BACKUP}/gitconfig ${HOME}/.gitconfig; fi
	@if [ -f ${BACKUP_DIR}/${LATEST_BACKUP}/gitignore_global ]; then cp ${BACKUP_DIR}/${LATEST_BACKUP}/gitignore_global ${HOME}/.gitignore_global; fi
	@if [ -d ${BACKUP_DIR}/${LATEST_BACKUP}/ssh ]; then cp -r ${BACKUP_DIR}/${LATEST_BACKUP}/ssh ${HOME}/.ssh; fi
	@if [ -d ${BACKUP_DIR}/${LATEST_BACKUP}/nvim ]; then cp -r ${BACKUP_DIR}/${LATEST_BACKUP}/nvim ${HOME}/.config/nvim; fi
	@if [ -d ${BACKUP_DIR}/${LATEST_BACKUP}/emacs.d ]; then cp -r ${BACKUP_DIR}/${LATEST_BACKUP}/emacs.d ${HOME}/.emacs.d; fi
	$(call log_success,"Restore completed from ${LATEST_BACKUP}")

list-backups: ## List all available backups
	@echo "Available backups in ${BACKUP_DIR}:"
	@if [ -d ${BACKUP_DIR} ]; then \
		ls -lht ${BACKUP_DIR} | tail -n +2; \
	else \
		echo "No backups directory found"; \
	fi
