# Private Submodule

The `private/` directory is a separate git repository attached as a submodule. It holds anything that shouldn't live in the public dotfiles: identity, work-specific configs, credentials helpers, internal scripts.

## What goes where

| Path | Purpose |
|---|---|
| `private/config/ssh/config` | SSH hosts (work proxies, jump boxes) — stowed to `~/.ssh/config` via `make ssh` |
| `private/een/functions/*.sh` | Work-specific shell functions (auto-sourced by `zsh/.zshrc`/`bash/.bashrc`) |
| `private/bin/.local/bin/*` | Private scripts on `$PATH` — stowed to `~/.local/bin` via `make private-bin` |
| `private/archive/` | Old configs kept for reference |

The public shell config sources from `private/een/functions/` only if the directory exists, so a public-only clone still works. `private/`'s own contents aren't stow packages in the usual sense — the top-level `Makefile`'s `ssh` and `private-bin` targets each stow a subdirectory of `private/` against their own `-d`/`-t` pair (`~/.ssh` and `~/`, respectively), separate from the root `STOW_PACKAGES` loop.

## Initial setup

```bash
make init   # or: make git-submodules-private — clones private repo into ./private
```

This requires SSH access to `git@github.com:asajaroff/private.git`.

## Creating your own private submodule

If you fork this dotfiles repo:

1. Create an empty private repo (GitHub, GitLab, self-hosted — anywhere).
2. Add it as a submodule:
   ```bash
   git submodule add git@github.com:<you>/private.git private
   ```
3. Mirror the structure above for whatever you need.

## Updating

```bash
cd private && git pull && cd ..
git add private && git commit -m "bump private submodule"
```

## Troubleshooting

- **`private/` is empty after clone**: forgot `--recursive`. Run `git submodule update --init --recursive`.
- **SSH config not picked up**: `~/.ssh/config` should symlink to `private/config/ssh/config`. Run `make ssh`.
- **Private scripts not found on `$PATH`**: run `make private-bin`, then confirm `~/.local/bin` is on `$PATH` (the `bin` package already puts it there).
- **`private` shows as dirty in `git status`**: you have uncommitted changes inside the submodule. `cd private && git status` to see them.
