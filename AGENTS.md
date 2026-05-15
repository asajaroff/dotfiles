# AGENTS.md - AI Assistant Guide

> Guidelines and context for AI coding assistants working with this dotfiles repository.

## Repository Overview

This is a modular dotfiles repository designed for cross-platform development environment configuration. The repository supports Linux (Arch, Ubuntu), macOS, and uses a Make-driven approach for automation.

## Key Design Principles

1. **Modularity**: Functions and scripts are organized in `./src/` and loaded dynamically
2. **Cross-platform**: Support for multiple operating systems with OS-specific logic in `makefiles/distros/`
3. **Make-driven**: All automation is handled through Makefile targets
4. **Privacy-conscious**: Private configurations managed via git submodules in `./private/`
5. **Idempotent**: Scripts and Makefiles should be safe to run multiple times

## Directory Structure

```
dotfiles/
├── config/           # Configuration files (bashrc, zshrc, tmux.conf, emacs/, nvim/)
├── src/              # Modular shell functions and scripts
│   ├── functions/    # Domain-specific shell functions (aws.sh, git.sh, kubernetes.sh, etc.)
│   └── scripts/      # Standalone utility scripts
├── makefiles/        # Modular Makefile components
│   ├── base.mk       # Base variables and OS detection
│   ├── shells.mk     # Shell configuration targets
│   ├── editors.mk    # Editor setup
│   ├── tools.mk      # Development tool installations
│   ├── kubernetes.mk # K8s tooling
│   └── distros/      # OS-specific targets (arch.mk, ubuntu.mk, macos.mk)
└── private/          # Private configs (git submodule - DO NOT commit changes here)
```

## Working with This Repository

### File Editing Guidelines

1. **Shell Functions**: Add new functions to `src/functions/` organized by domain
   - Use POSIX-compatible syntax where possible for cross-shell compatibility
   - Functions should be self-contained and well-documented
   - Follow existing naming conventions (lowercase with underscores)

2. **Makefile Targets**: Add new targets to appropriate modular Makefiles
   - Use `##` comments for help text documentation
   - Follow the pattern: `target: dependencies ## Help text`
   - Ensure idempotency (safe to run multiple times)
   - Use `$(call info,message)` and `$(call success,message)` for output

3. **Configuration Files**: Edit files in `config/` directory
   - Maintain cross-platform compatibility where possible
   - Use conditional logic for OS-specific configurations
   - Keep configurations well-commented

### Path References

To refer to the dotfiles root:
- **In shell code** (rcs, functions, scripts): use `${DOTFILES}` (exported by bashrc/zshrc at startup).
- **In Makefiles**: use `${DOTFILES_DIR}` (set in `makefiles/base.mk`).
- Avoid `~/.dotfiles` and `$HOME/.dotfiles` in tracked code — they bypass the convention.

### OS Detection

The repository uses OS detection variables defined in `makefiles/base.mk`:
- `$(OS_FAMILY)`: Darwin (macOS) or Linux
- `$(IS_ARCH)`, `$(IS_DEBIAN)`, `$(IS_MACOS)`: Boolean flags for OS detection

Use these variables for conditional logic in Makefiles.

### Common Tasks

#### Adding a New Shell Function

1. Create or edit a file in `src/functions/` (e.g., `src/functions/your-domain.sh`)
2. Add the function with proper documentation
3. Functions are auto-loaded by shell configs

#### Adding a New Makefile Target

1. Choose the appropriate makefile in `makefiles/`
2. Add target with help text: `target: ## Description`
3. Use OS detection variables for platform-specific logic
4. Test on target platforms

#### Updating Configuration Files

1. Edit files in `config/` directory
2. For shell configs (bashrc, zshrc), maintain cross-shell compatibility
3. For tool configs (tmux, emacs, nvim), follow existing patterns

### Testing Changes

1. **Shell functions**: Source the function file and test manually
   ```bash
   source src/functions/your-function.sh
   your_function
   ```

2. **Makefile targets**: Run with verbose output
   ```bash
   make your-target
   ```

3. **Configuration files**: Reload the relevant application
   ```bash
   # For shells
   source ~/.bashrc  # or ~/.zshrc

   # For tmux
   tmux source-file ~/.tmux.conf
   ```

## Important Constraints

### DO NOT

- **Commit changes to `private/` directory** - This is a git submodule for private configs
- **Break cross-platform compatibility** - Test changes on multiple platforms when possible
- **Modify files without reading them first** - Always read existing files to understand context
- **Create new documentation files unprompted** - Only create docs when explicitly requested
- **Use non-idempotent patterns** - Ensure scripts can be run multiple times safely

### DO

- **Follow existing patterns** - Match the style and structure of existing code
- **Add help text to Makefile targets** - Use `##` comments for documentation
- **Test changes thoroughly** - Verify functionality before committing
- **Keep functions modular** - Each function should do one thing well
- **Document complex logic** - Add comments for non-obvious code

## Common Patterns

### Makefile Pattern
```make
target: dependencies ## Help text shown in 'make help'
	@$(call info,Starting task...)
	@command1
	@command2
	@$(call success,Task completed!)
```

### Shell Function Pattern
```bash
# Function: description
# Usage: function_name [args]
function_name() {
    local arg1="${1}"
    local arg2="${2:-default_value}"

    # Implementation
    echo "Output"
}
```

### OS-Specific Logic in Makefiles
```make
install-tool: ## Install development tool
ifeq ($(OS_FAMILY),Darwin)
	brew install tool
else ifeq ($(IS_ARCH),true)
	sudo pacman -S tool
else ifeq ($(IS_DEBIAN),true)
	sudo apt install tool
endif
```

## Integration Points

### Shell Configuration Loading

The shell configs (`config/bashrc` and `config/zshrc`) dynamically source files from:
- `src/functions/*.sh` - All custom functions
- `private/functions/*.sh` - Private functions (if available)
- `config/aliases` - Shell aliases

### Makefile Entry Point

The main `Makefile` includes all modular makefiles:
```make
include makefiles/base.mk
include makefiles/system.mk
include makefiles/git.mk
include makefiles/shells.mk
# ... etc
```

### Key Make Targets

- `make help` - Show all available targets
- `make init` - Initialize the environment
- `make shells` - Set up shell configurations
- `make workspace` - Create workspace directory structure
- OS-specific: `make archlinux`, `make ubuntu`, `make macos-base`

## Questions to Ask

When uncertain about changes, ask:

1. **Cross-platform compatibility**: "Should this work on all platforms or be OS-specific?"
2. **Scope**: "Should this be a function, script, or Makefile target?"
3. **Location**: "Which file/directory is most appropriate for this change?"
4. **Dependencies**: "What other components does this interact with?"
5. **Testing**: "How should we verify this works correctly?"

## Reference Files

- `README.md` - User-facing documentation
- `CHANGELOG.md` - Version history
- `Makefile` - Main entry point
- `makefiles/base.mk` - Core variables and OS detection
- `config/bashrc` & `config/zshrc` - Shell configuration entry points

## Version Information

- Current Development Branch: `dev`
- Main Branch: `master`
- Latest Stable: v0.2.0

When creating pull requests, target the `master` branch unless working on experimental features.
