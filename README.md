# Alejandro's Dotfiles

> A modular and well-organized collection of configuration files for development environments across multiple operating systems.

## Design Philosophy

- **Modularity**: Shell functions and scripts are organized in `./src/` and loaded dynamically
- **Cross-platform**: Support for Linux (Arch, Ubuntu), macOS, and various development environments
- **Privacy-conscious**: Private configurations managed via git submodules
- **Make-driven**: Simple, documented automation for setup and maintenance

## Project Structure

```
dotfiles/
├── config/           # Configuration files for various tools
│   ├── bashrc        # Bash configuration
│   ├── zshrc         # Zsh configuration
│   ├── tmux.conf     # Tmux configuration
│   ├── emacs/        # Emacs configuration
│   └── nvim/         # Neovim configuration
├── src/              # Modular shell functions and scripts
│   ├── functions/    # Domain-specific shell functions
│   └── scripts/      # Standalone utility scripts
├── makefiles/        # Modular Makefile components
│   ├── base.mk       # Base variables and utilities
│   ├── shells.mk     # Shell configuration
│   ├── tools.mk      # Tool installations
│   └── distros/      # OS-specific configurations
├── private/          # Private configurations (git submodule)
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

1. **Clone the repository**:
   ```bash
   git clone https://github.com/asajaroff/dotfiles.git ~/Code/github.com/asajaroff/dotfiles
   cd ~/Code/github.com/asajaroff/dotfiles
   ```

2. **Initialize everything**:
   ```bash
   make init
   ```

3. **Set up shell configurations**:
   ```bash
   make shells
   ```

## Available Make Targets

Run `make help` to see all available targets:

### Core Setup
- `make init` - Initialize git config and private submodules
- `make workspace` - Create workspace directory structure
- `make shells` - Set up bash, zsh, and tmux configurations

### Platform-specific
- `make archlinux` - Install Arch Linux packages
- `make ubuntu` - Install Ubuntu/Debian packages
- `make macos-base` - Install basic macOS packages

### Tools & Development
- `make emacs` - Set up Emacs configuration
- `make kubernetes` - Install kubectl, helm, kubectx
- `make tenv` - Install Terraform environment manager
- `make istioctl` - Install Istio service mesh CLI

### System Maintenance
- `make update` - Update system packages (OS-agnostic)

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

This dotfiles setup supports private configurations through git submodules:

1. **Set up private submodule**:
   ```bash
   make git-submodules-private
   ```

2. **Private configurations are stored in**:
   ```
   private/
   ├── config/       # gitconfig, ssh config
   ├── een/          # Work-specific functions and scripts
   └── bin/          # Private scripts and binaries
   ```

See [docs/private-setup.md](docs/private-setup.md) for details, including how to set up your own private submodule.

## Customization

### Adding New Functions
Create new shell functions in `src/functions/` organized by domain:

```bash
src/functions/
├── aws.sh         # AWS-related functions
├── git.sh         # Git utilities
├── kubernetes.sh  # Kubernetes helpers
└── your-domain.sh # Your custom functions
```

### Adding OS-specific Configurations
Add new OS support in `makefiles/distros/`:

```bash
makefiles/distros/
├── arch.mk     # Arch Linux
├── ubuntu.mk   # Ubuntu/Debian
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
