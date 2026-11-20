# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

`AGENTS.md` in the repo root is the authoritative contributor guide (conventions, constraints, patterns). Read it; the points below are the essentials plus the cross-file architecture.

## Architecture

Dotfiles managed entirely by [GNU Stow](https://www.gnu.org/software/stow/): **one top-level directory per tool, mirroring `$HOME`** (e.g. `zsh/.zshrc` → `~/.zshrc`, `nvim/.config/nvim/init.lua` → `~/.config/nvim/init.lua`, `bin/.local/bin/*` → `~/.local/bin/*`). Edit files inside the package, never in a symlinked copy under `$HOME`.

- Stow is always invoked with `--no-folding` (files are linked individually, never whole directories): `stow --no-folding -d "$DOTFILES_DIR" -t "$HOME" <pkg>`.
- `STOW_PACKAGES` in `makefiles/base.mk` is the registry of packages. A new package must be added in **three places that must stay in sync**: `STOW_PACKAGES` in `makefiles/base.mk`, the `stow-dry-run` hook in `.pre-commit-config.yaml`, and the `stow -n -v` step in `.github/workflows/make-stages.yaml`.
- There are no custom symlink Makefile targets (the only exception is `emacs` in `makefiles/editors.mk`, intentionally unmigrated; `config/emacs/` is the only content left under `config/`). Don't add symlink targets — add a stow package.
- `functions/` is sourced by `zsh/.zshrc` / `bash/.bashrc` (not on `$PATH`); standalone executables go in `bin/.local/bin/`.
- `private/` is a git submodule with its own stow roots (`-d private/config` → `~/.ssh`, `-d private` for `bin` and `systemd`). Never commit changes inside it; a modified `private` in `git status` is just a submodule pointer bump. Targets: `make ssh`, `make private-bin`, `make openvpn3` (Linux only).
- `makefiles/*.mk` are included by the root `Makefile`; OS detection vars (`OS_FAMILY`, `IS_ARCH`, `IS_DEBIAN`, `IS_MACOS`) come from `base.mk`, and per-distro installs live in `makefiles/distros/`.
- Paths: use `${DOTFILES}` in shell code and `${DOTFILES_DIR}` in Makefiles; avoid hardcoding `~/.dotfiles`.

## Commands

```bash
make help                          # list targets (documented with `##`)
make install                       # install stow + stow all STOW_PACKAGES
make install-pkg PACKAGE_NAME=nvim # stow a single package
make uninstall                     # unstow everything
make init                          # init private submodule + workspace dirs

stow --no-folding -n -v -d . -t "$HOME" <pkg>   # dry-run a package (what CI/pre-commit do)
pre-commit run --all-files                      # shellcheck (--severity=warning) + stow dry-runs + hygiene hooks
pre-commit run shellcheck --files bin/.local/bin/rook-restart.sh   # lint one script
```

There is no unit test suite; verification is stow dry-runs, shellcheck, and sourcing/running the changed script. `zsh/.zshrc` is excluded from shellcheck (zsh-only syntax).

## Notes

- Branch `refactor/stow-rewrite` is the in-progress stow migration; PRs target `master`. Design history is in `docs/prd-stow-refactor.md`, `docs/trd-stow-refactor.md`, `docs/arch-stow-refactor.md`.
- Untracked `config/nvim/` and `README.org` are leftovers; the live nvim config is `nvim/.config/nvim/`.
