# AGENTS.md - AI Assistant Guide

> Guidelines and context for AI coding assistants working with this dotfiles repository.

## Repository Overview

This is a modular dotfiles repository designed for cross-platform development environment configuration. The repository supports Linux (Arch, Debian/Ubuntu), macOS, and uses [GNU Stow](https://www.gnu.org/software/stow/) — one package per tool, mirroring `$HOME` — for all symlinking, orchestrated by a thin Make-driven `install` target.

## Key Design Principles

1. **One package per tool**: Each tool's config is its own stow package (e.g. `zsh/`, `nvim/`, `git/`), mirroring `$HOME`'s layout under it. Adding a tool is `mkdir <package>` + `stow <package>` — no custom Makefile symlink targets.
2. **Cross-platform**: Support for multiple operating systems with OS-specific package installs in `makefiles/distros/`
3. **Make-driven bootstrap only**: `make install` installs stow and stows every package; it does not implement symlinking itself
4. **Privacy-conscious**: Private configurations managed via a git submodule in `./private/`, stowed with its own `-d`
5. **Idempotent**: Stowing an already-stowed package is a no-op; Makefile targets should be safe to run multiple times

## Directory Structure

```
dotfiles/
├── starship/         # Starship prompt package (.config/starship.toml)
├── tmux/             # Tmux package (.tmux.conf)
├── nvim/             # Neovim package (.config/nvim/init.lua)
├── git/              # Git package (.gitconfig, .gitignore_global)
├── zsh/              # Zsh package (.zshrc, .aliases)
├── bash/             # Bash package (.bashrc, .profile)
├── bin/              # Standalone scripts package, targets $PATH (.local/bin/*)
├── functions/        # Shell functions package, sourced by zsh/bash rc (not $PATH)
├── vscode/           # VS Code settings + workspace files package
├── firefox/          # Firefox LeechBlock config package
├── config/           # Anything not yet migrated to a package (currently: emacs/ only)
├── makefiles/        # Modular Makefile components
│   ├── base.mk       # Base variables, OS detection, STOW_PACKAGES, install-stow, install
│   ├── editors.mk    # emacs target only — deliberately out of scope for the stow migration
│   ├── tools.mk      # Standalone tool installations (tenv, istioctl, ...)
│   ├── kubernetes.mk # K8s tooling
│   └── distros/      # OS-specific package installs (arch.mk, debian.mk, macos.mk)
└── private/          # Private configs (git submodule - DO NOT commit changes here)
```

There is no custom symlinking Makefile target anywhere in this repo except
`makefiles/editors.mk`'s `emacs` target, which predates the stow migration
and was explicitly left out of scope. Every other tool is linked by stow.

## Working with This Repository

### File Editing Guidelines

1. **Shell Functions**: Add new functions to `functions/` organized by domain
   - Use POSIX-compatible syntax where possible for cross-shell compatibility
   - Functions should be self-contained and well-documented
   - Follow existing naming conventions (lowercase with underscores)
   - These are *sourced* by `zsh/.zshrc`/`bash/.bashrc`, not put on `$PATH` — standalone invocable scripts go in `bin/.local/bin/` instead

2. **Adding a new stow package**: `mkdir <package>` mirroring `$HOME` under it (e.g. `newtool/.config/newtool/config.toml`), add `<package>` to `STOW_PACKAGES` in `makefiles/base.mk`, verify with `stow -n -v <package>`. No Makefile symlink target to write.

3. **Makefile Targets**: Add new targets to the appropriate modular Makefile (never a symlink target for a tool that has, or should have, a stow package)
   - Use `##` comments for help text documentation
   - Follow the pattern: `target: dependencies ## Help text`
   - Ensure idempotency (safe to run multiple times)

4. **Configuration Files**: Edit the file inside its stow package (e.g. `zsh/.zshrc`, `nvim/.config/nvim/init.lua`), not a `config/` copy — `config/` only holds `emacs/`, which is unmigrated
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

1. Create or edit a file in `functions/` (e.g., `functions/your-domain.sh`)
2. Add the function with proper documentation
3. Functions are auto-loaded by `zsh/.zshrc`/`bash/.bashrc` — no re-stow needed once the package is linked

#### Adding a New Stow Package

1. `mkdir <package>` mirroring `$HOME`'s layout for the files it owns
2. Add `<package>` to `STOW_PACKAGES` in `makefiles/base.mk`
3. Verify: `stow -n -v <package>` from the repo root
4. Add `<package>` to the `stow-dry-run` hook in `.pre-commit-config.yaml` and the CI job in `.github/workflows/make-stages.yaml`

#### Adding a New Makefile Target

1. Choose the appropriate makefile in `makefiles/` (never a symlink target — that's stow's job now)
2. Add target with help text: `target: ## Description`
3. Use OS detection variables for platform-specific logic
4. Test on target platforms

#### Updating a Tool's Configuration

1. Edit the file inside its stow package (e.g. `zsh/.zshrc`, `tmux/.tmux.conf`), not `config/`
2. For shell configs (bash, zsh), maintain cross-shell compatibility
3. For tool configs (tmux, nvim), follow existing patterns

### Testing Changes

1. **Shell functions**: Source the function file and test manually
   ```bash
   source functions/your-function.sh
   your_function
   ```

2. **Stow packages**: Dry-run before linking
   ```bash
   stow -n -v <package>
   ```

3. **Makefile targets**: Run with verbose output
   ```bash
   make your-target
   ```

4. **Configuration files**: Reload the relevant application
   ```bash
   # For shells
   source ~/.bashrc  # or ~/.zshrc

   # For tmux
   tmux source-file ~/.tmux.conf
   ```

## Important Constraints

### DO NOT

- **Commit changes to `private/` directory** - This is a git submodule for private configs
- **Add a Makefile symlink target for a tool** - stow owns all linking now; add the package to `STOW_PACKAGES` instead
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
	@command1
	@command2
```

### Stow Package Layout
```
newtool/
└── .config/
    └── newtool/
        └── config.toml   # symlinked to ~/.config/newtool/config.toml
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

The shell configs (`zsh/.zshrc` and `bash/.bashrc`) dynamically source files from:
- `functions/*.sh` - All custom functions
- `private/een/functions/*.sh` - Private/work functions (if the submodule is present)
- `zsh/.aliases` - Shell aliases

### Makefile Entry Point

The main `Makefile` includes all modular makefiles:
```make
include makefiles/base.mk
include makefiles/system.mk
include makefiles/git.mk
include makefiles/editors.mk
# ... etc
```

`makefiles/base.mk` defines `STOW_PACKAGES` and the `install`/`install-stow`/`ssh` targets — it is the only place a new package needs to be registered.

### Key Make Targets

- `make help` - Show all available targets
- `make install` - Install stow + stow every package in `STOW_PACKAGES` (bootstrap)
- `make init` - Initialize the private git submodule
- `make workspace` - Create workspace directory structure
- OS-specific: `make archlinux`, `make debian`, `make macos-base`

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
