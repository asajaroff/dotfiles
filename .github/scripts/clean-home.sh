#!/usr/bin/env bash
# CI-only: remove the runner's stock dotfiles (~/.bashrc, ~/.gitconfig, ...)
# that would make stow abort with "cannot stow ... over existing target".
#
# Usage: clean-home.sh <stow-dir> <package>...
#
# For every file a package would link into $HOME, delete the existing target
# unless it is already a symlink. Refuses to run outside CI so it can never
# wipe a real home directory.
set -euo pipefail

if [ "${CI:-}" != "true" ]; then
    echo "clean-home.sh: refusing to run outside CI (CI != true)" >&2
    exit 1
fi

stow_dir="${1:?usage: clean-home.sh <stow-dir> <package>...}"
shift

for pkg in "$@"; do
    while IFS= read -r -d '' file; do
        rel="${file#"${stow_dir}/${pkg}/"}"
        target="${HOME}/${rel}"
        if [ -e "${target}" ] && [ ! -L "${target}" ]; then
            echo "removing ${target}"
            rm -f "${target}"
        fi
    done < <(find "${stow_dir}/${pkg}" -type f -print0)
done
