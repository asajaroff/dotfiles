# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2024-09-01

### Added
- **Modular Makefile Architecture**: Complete refactoring of monolithic Makefile into domain-specific modules
  - `makefiles/base.mk` - Base variables and workspace management
  - `makefiles/system.mk` - Cross-platform system updates
  - `makefiles/git.mk` - Git configuration and submodule management
  - `makefiles/shells.mk` - Shell configuration (bash, zsh, tmux)
  - `makefiles/editors.mk` - Editor setup and configuration
  - `makefiles/tools.mk` - Tool installations (tenv, istioctl, bitwarden)
  - `makefiles/kubernetes.mk` - Kubernetes tooling
  - `makefiles/distros/` - OS-specific package management
- **Enhanced Tmux Functions**: Extended tmux management capabilities
- **Emacs Minibuffer Support**: Added evil mode support for minibuffer interactions
- **Certificate Management**: Added oneliners for certificate operations
- **Debug Mode**: Added DEBUG_MODE functionality to dotfiles
- **Workflow Improvements**: Enhanced GitHub Actions and CI/CD workflows
- **Comprehensive Documentation**: Complete README overhaul with structure, installation guides, and examples

### Changed
- **Makefile Structure**: Moved from single 168-line Makefile to modular 28-line orchestrator
- **Shell Functions**: Improved organization and loading of shell functions
- **Tmux Configuration**: Enhanced tmux setup with better session management

### Fixed
- **Makefile Warnings**: Resolved duplicate target warnings (tenv conflict)
- **Trailing Whitespace**: Removed trailing whitespace throughout codebase
- **GitHub Actions**: Fixed workflow configurations and symlink creation
- **Shell Compatibility**: Improved cross-shell compatibility for functions

## [2024-07-25] - Major Emacs Migration

### Added
- **Emacs with Evil Mode**: Primary editor switch from Neovim to Emacs with evil mode
- **Use-Package Configuration**: Modern Emacs package management system
- **Starship Prompt**: Cross-shell prompt with Git integration
- **Arch Linux Setup**: Comprehensive Arch Linux installation and configuration
- **Enhanced Tmux**: Improved tmux configuration and session management

### Changed
- **Editor Strategy**: Moved from Neovim as primary to Emacs with evil mode
- **Configuration Management**: Streamlined config file organization

### Removed
- **Neovim Configurations**: Deprecated in favor of Emacs setup

## [v0.2.0] - 2021-09-11 - Major Refactor

### Added
- **Language Server Protocol (LSP)**: Full LSP support for Go, Python, Bash, and YAML
- **Neovim Enhancements**:
  - Live substitution and yank highlighting
  - Plugin architecture split from main vimrc
  - Nightly build support
  - 80-character line limit
  - Improved syntax error highlighting with colors
- **Shell Improvements**:
  - Automated Starship.rs installation and configuration
  - Enhanced bashrc with Starship integration
  - Improved aliases with color support
  - Vi keybindings for paste/copy in tmux
  - History limits and optimizations
- **Development Tooling**:
  - Automated symlink creation for bash, zsh, and tmux
  - Cross-platform editor installation scripts
  - GitHub Actions integration for automated testing
  - Private module system for sensitive configurations
- **Licensing and Documentation**:
  - Added GPLv3 license
  - Comprehensive README updates
  - Initial CHANGELOG implementation
- **Build System**:
  - Comprehensive Makefile with 90+ targets
  - Automated installation and setup processes
  - Cross-platform compatibility

### Changed
- **Configuration Architecture**: Major refactor of configuration management
- **Git Integration**: Enhanced git submodule support for private configurations
- **Colors**: Added color support to ls command and various shell outputs

### Removed
- **setup.sh**: Replaced by comprehensive Makefile system
- **vimrc**: Migrated to Neovim with modern configuration

### Fixed
- **LSP Configuration**: Resolved treesitter and LSP compatibility issues across different architectures

## [2021-09-08] - Development Phase

### Added
- **Makefile System**: Initial implementation of automated setup (Work in Progress)
- **Script Collection**: Comprehensive utility scripts for development workflow
- **Neovim Migration**: Transition from vim to neovim with modern plugins
- **Telescope Integration**: Fuzzy finder and file navigation
- **Treesitter Configuration**: Enhanced syntax highlighting and code parsing
- **ASDF Version Manager**: Runtime version management system
- **Private Functions**: Secure function library for sensitive operations

### Removed
- **setup.sh**: Deprecated in favor of Makefile-based automation

### Known Issues
- **LSP Compatibility**: Neovim treesitter and LSP inconsistencies across different architectures

## [2019-03-18] - Foundation

### Added
- **Arch Linux Guides**: Installation and configuration documentation for Arch Linux

## [2019-03-17] - Initial Release

### Added
- **Initial Vimrc**: First version of vim configuration
- **ZSH Configuration**: Basic zsh setup and customization
- **Project Foundation**: Repository structure and initial commit

---

## Migration Guide

### From v0.2.0 to Current
1. **Makefile Changes**: The Makefile has been completely modularized but all existing targets remain functional
2. **Editor Transition**: If using Neovim, consider migrating to the new Emacs setup with evil mode
3. **Private Submodules**: Continue to work seamlessly with the new modular structure

### Breaking Changes
- **Editor Focus**: Primary development shifted from Neovim to Emacs (Neovim configs deprecated but still available)

## Future Roadmap
- [ ] Enhanced container development support
- [ ] Improved cross-platform compatibility for Windows
- [ ] Plugin system for community contributions  
- [ ] Automated backup and restore functionality
- [ ] Integration with cloud synchronization services