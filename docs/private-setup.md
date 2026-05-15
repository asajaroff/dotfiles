# Private Submodule

The `private/` directory is a separate git repository attached as a submodule. It holds anything that shouldn't live in the public dotfiles: identity, work-specific configs, credentials helpers, internal scripts.

## What goes where

| Path | Purpose |
|---|---|
| `private/config/git/gitconfig` | Identity, signing keys, credential helpers |
| `private/config/ssh/config` | SSH hosts (work proxies, jump boxes) |
| `private/een/functions/*.sh` | Work-specific shell functions (auto-sourced by bashrc/zshrc) |
| `private/bin/` | Private scripts on `$PATH` |
| `private/archive/` | Old configs kept for reference |

The public shell config sources from `private/` only if the directory exists, so a public-only clone still works.

## Initial setup

```bash
make git-submodules-private   # clones private repo into ./private
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
- **`private` shows as dirty in `git status`**: you have uncommitted changes inside the submodule. `cd private && git status` to see them.
