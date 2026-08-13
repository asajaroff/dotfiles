# Alejandro's Dotfiles

> A modular and well-organized collection of configuration files for development environments across multiple operating systems.

## Design Philosophy

- **Modularity**: Each tool's config is its own [GNU Stow](https://www.gnu.org/software/stow/) package; shell functions/scripts live in `functions/` and `bin/`
- **Cross-platform**: Support for Linux (Arch, Ubuntu), macOS, and various development environments
- **Privacy-conscious**: Private configurations managed via git submodules
- **Make-driven**: Simple, documented automation for setup and maintenance

## Project Structure

Each tool's config lives in its own [GNU Stow](https://www.gnu.org/software/stow/)
package, one directory per tool, mirroring `$HOME`'s layout for the files it
owns (e.g. `zsh/.zshrc`, `nvim/.config/nvim/init.lua`). `make install` stows
all of them at once; `stow <package>` links just one.

```
dotfiles/
├── starship/         # Starship prompt (.config/starship.toml)
├── tmux/             # Tmux (.tmux.conf)
├── nvim/             # Neovim (.config/nvim/init.lua)
├── git/              # Git (.gitconfig, .gitignore_global)
├── zsh/              # Zsh (.zshrc, .aliases)
├── bash/             # Bash (.bashrc, .profile)
├── bin/              # Standalone scripts on $PATH (.local/bin/*)
├── functions/        # Shell functions, sourced (not $PATH) by zsh/bash rc
├── vscode/           # VS Code settings + workspace files
├── firefox/          # Firefox LeechBlock config
├── config/           # Config not yet migrated to a package (emacs/ only)
├── makefiles/        # Modular Makefile components
│   ├── base.mk       # Base variables, OS detection, install-stow, install
│   ├── editors.mk    # Emacs setup (out of scope for the stow migration)
│   ├── tools.mk      # Standalone tool installations
│   └── distros/      # OS-specific package installs
├── private/          # Private configurations (git submodule, its own stow -d)
└── docs/             # Documentation and install recipes
```

## Quick Start

### Prerequisites

- **POSIX-compatible shell** (bash, zsh)
- **make** build system
- **git** for cloning and submodule management
- **NERD font** for proper display of shell prompts

### Platform-specific Requirements

#### Arch Linux
```bash
sudo pacman -Syu base-devel git make
```

#### Ubuntu/Debian
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential git make dnsutils
```

#### macOS
```bash
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Installation

Note: dotfiles must live at `~/.dotfiles` — that's the tree stow mirrors
against `$HOME`.

1. **Clone the repository**:
   ```bash
   git clone --recurse-submodules https://github.com/asajaroff/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Initialize the private submodule** (if not cloned with `--recurse-submodules`):
   ```bash
   make init
   ```

3. **Install stow and stow every package**:
   ```bash
   make install
   ```
   This installs GNU Stow (if missing), stows the `private/` submodule's ssh
   config, then loops `stow` across every package listed in
   `STOW_PACKAGES` (`makefiles/base.mk`). Safe to re-run — stowing an
   already-stowed package is a no-op. A pre-existing real file (not a
   symlink) at a stow target makes `stow` error out rather than overwrite
   it; move or remove that file and re-run `make install`.

### Adding a new tool

`mkdir <package>` mirroring `$HOME` under it (e.g.
`newtool/.config/newtool/config.toml`), add `<package>` to `STOW_PACKAGES`
in `makefiles/base.mk`, then `stow <package>`. No Makefile target to write.

## Available Make Targets

Run `make help` to see all available targets:

### Core Setup
- `make install` - Install stow (if missing) and stow every package (bootstrap)
- `make install-stow` - Install GNU Stow only
- `make ssh` - Stow SSH config from the private submodule
- `make init` - Initialize private git submodule
- `make workspace` - Create workspace directory structure

### Platform-specific
- `make archlinux` - Install Arch Linux packages
- `make debian` - Install Debian/Ubuntu packages
- `make macos-base` - Install basic macOS packages

### Tools & Development
- `make emacs` - Set up Emacs configuration (not stow-managed, out of scope for this migration)
- `make kubernetes` - Install kubectl, helm, kubectx
- `make tenv` - Install Terraform environment manager
- `make istioctl` - Install Istio service mesh CLI

### System Maintenance
- `make update` - Update system packages (OS-agnostic)
- `make lint` - Run pre-commit hooks against all files (includes `stow -n -v`)

## Configuration Features

### Shell Environment
- **Starship prompt** with Git integration
- **Custom aliases** for common development tasks
- **Modular functions** organized by domain (AWS, Git, Kubernetes, etc.)
- **Cross-shell compatibility** (bash/zsh)

### Development Tools
- **Tmux** with vi key bindings and proper clipboard integration
- **Neovim** (primary editor, `$EDITOR`) with LSP support for Go, Python, Bash, YAML
- **Emacs** with evil mode and use-package management (secondary)
- **Git** with sensible defaults and helpful aliases

### Platform Integration
- **Arch Linux**: pacman integration and AUR helpers
- **macOS**: Homebrew integration and native app management
- **Ubuntu/Debian**: apt integration and package management

## Private Configurations

This dotfiles setup supports private configurations through a git submodule:

1. **Set up the private submodule**:
   ```bash
   make init   # or: git submodule update --init --recursive private
   ```

2. **Private configurations are stored in**:
   ```
   private/
   ├── config/ssh/   # SSH config, stowed to ~/.ssh via `make ssh`
   ├── een/          # Work-specific functions and scripts
   └── bin/          # Private scripts and binaries
   ```

See [docs/private-setup.md](docs/private-setup.md) for details, including how to set up your own private submodule.

## Customization

### Adding New Functions
Add a new file to the `functions/` package, organized by domain — it's
sourced by `zsh/.zshrc` and `bash/.bashrc`, not put on `$PATH`:

```bash
functions/
├── aws.sh         # AWS-related functions
├── git.sh         # Git utilities
├── kubernetes.sh  # Kubernetes helpers
└── your-domain.sh # Your custom functions
```

Standalone scripts you want to *invoke* by name go in `bin/.local/bin/`
instead (it's on `$PATH`).

### Adding OS-specific Configurations
Add new OS support in `makefiles/distros/`:

```bash
makefiles/distros/
├── arch.mk     # Arch Linux
├── debian.mk   # Debian/Ubuntu
├── macos.mk    # macOS
└── fedora.mk   # Your new OS
```

## Contributing

PRs welcome for portable improvements. See [CONTRIBUTING.md](CONTRIBUTING.md) for dev setup (`make git-hooks`), conventions, and the PR process.

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## Version

Current version: Development branch (feat/workflows)
Latest stable: v0.2.0

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.
