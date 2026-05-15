#!/usr/bin/env bash
#
# Generate a backup on a mounted disk
#

if [ "$#" -ne 3 ]; then
	echo "Error: Illegal number of parameters."
	echo "Usage: $0 [--sync=<PATH> or --new] [source] [destination]"
	exit 1
fi

if ! command -v rsync; then
    echo "rsync is not available. Install it first"
    exit 1
fi

# TODO: Add exclude dirs dynamically (placeholder list, currently hardcoded inline below)
BACKUP_MOUNTPOINT='/media/asajaroff/Movil'
HOSTNAME='xps-13-debian'

function update_backup() {
	local BACKUP_DIR
	BACKUP_DIR=$(date +%Y-%m-%dT%H-%M)
	local BACKUP_PATH=${BACKUP_MOUNTPOINT}/Backups/xps-13/${BACKUP_DIR}/
	rsync -azh --delete \
		--stats \
		--info=progress2 \
		--exclude 'go' \
		--exclude '.dotfiles' \
		--exclude 'Downloads' \
		--exclude '.cache' \
		--exclude '.venv' \
		--exclude '.terragrunt-cache' \
		--exclude '.terraform' \
		--exclude 'lost+found' \
		${HOME}/ ${BACKUP_MOUNTPOINT}/Backups/xps-13/2025-12-10T07-49/
}

# /media/asajaroff/Bacap/Backups/xps-13-debian

function new_backup() {
	local BACKUP_DIR
	BACKUP_DIR=$(date +%Y-%m-%dT%H-%M)
	local BACKUP_PATH=${BACKUP_MOUNTPOINT}/Backups/${HOSTNAME}/${BACKUP_DIR}/
	if [ ! -d "$BACKUP_PATH" ]; then
	    mkdir -p ${BACKUP_PATH}
	    rsync -azh --delete \
		    --info=progress2 \
		    --stats \
		    --exclude 'go' \
		    --exclude '.dotfiles' \
		    --exclude 'Downloads' \
		    --exclude '.cache' \
		    --exclude '.venv' \
		    --exclude '.terragrunt-cache' \
		    --exclude '.terraform' \
		    --exclude 'lost+found' \
		    ${HOME}/ ${BACKUP_PATH}/
		    #--dry-run \
	else
	    echo "ERROR: Directory already exists"
	    exit 2
	fi
}

for arg in "$@"; do
	case $arg in
	--new)
		echo "Running new backup at $(date +%Y-%m-%dT%H-%M)"
		new_backup
		;;
	--sync)
		echo "Updating backup located at ${TARGET}"
		update_backup
		;;
	*)
		# 3. Catch anything that isn't a flag (e.g., source/destination paths)
		# and add it to our custom FILES array
		FILES+=("$arg")
		;;
	esac
done

#	--progress --stats \
#
