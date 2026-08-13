# Contributing

This is a personal dotfiles repo, but PRs are welcome for portable improvements (cross-platform fixes, new shell helpers, Makefile cleanups, doc updates). Personal/work-specific bits live in the [private submodule](docs/private-setup.md), not here.

## Dev setup

```bash
git clone --recurse-submodules git@github.com:asajaroff/dotfiles.git
cd dotfiles

# Install the pre-commit framework, then wire up local hooks
pipx install pre-commit   # or: brew install pre-commit
make git-hooks
```

`make git-hooks` installs the hooks listed in [`.pre-commit-config.yaml`](.pre-commit-config.yaml) (shellcheck, trailing-whitespace, end-of-file-fixer, check-yaml, check-merge-conflict, check-added-large-files).

## Conventions

Editing rules live in [`AGENTS.md`](AGENTS.md):

- **Shell functions**, **Makefile targets**, **config files** — see *File Editing Guidelines*.
- **Path references**: `${DOTFILES}` in shell code, `${DOTFILES_DIR}` in Makefiles. Avoid `~/.dotfiles` and `$HOME/.dotfiles` in tracked code. See *Path References*.
- **OS detection**: use `$(OS_FAMILY)` and `$(IS_ARCH)` / `$(IS_DEBIAN)` / `$(IS_MACOS)` from `makefiles/base.mk`. See *OS Detection*.

## Before submitting

Run the same checks CI will run:

```bash
pre-commit run --all-files
```

This is gated by the `lint` job in [`.github/workflows/make-stages.yaml`](.github/workflows/make-stages.yaml); a failing run will block merge.

For UI/shell changes that hooks can't verify, source the modified rc in a fresh shell and exercise the affected aliases/functions manually.

## PR process

1. Fork and create a feature branch off `master`.
2. Make changes following the conventions above.
3. Commit using [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, `refactor:`, etc.). The `ai-commit` helper in `functions/ai.sh` follows the same spec if you want to generate messages.
4. Push, open a PR against `master`, describe the *why*.
5. CI must be green.

## Scope guidance

Good PRs:
- Cross-platform improvements (Linux + macOS).
- New shell helpers in `functions/` (sourced) or `bin/.local/bin/` (on `$PATH`), organized by domain.
- New stow packages (`mkdir <package>` + add to `STOW_PACKAGES` in `makefiles/base.mk`) or install-recipe fixes in `docs/install/`.
- Documentation, troubleshooting notes.

Out of scope:
- Personal identity, signing keys, work-specific hosts — those belong in [`private/`](docs/private-setup.md).
- Opinionated rewrites of working configs without a stated portability/correctness reason.
