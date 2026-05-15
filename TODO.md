# Dotfiles Repository TODO

This document tracks improvements and enhancements for the dotfiles repository.

**Current Assessment: 7.5/10**
**Target: 9/10**

---

## High Priority - Quick Wins

### 1. Clean up tracked/untracked files
- [x] Remove `Makefile.old` (already gone)
- [x] Remove `makefiles/#editors.mk#` (Emacs backup file)
- [x] Decide on i3 config: either `git add config/i3/` or add to `.gitignore` (dir doesn't exist)
- [ ] Resolve private submodule changes (`m private` in git status) — deferred

**Commands:**
```bash
rm Makefile.old
rm makefiles/#editors.mk#
git add config/i3/ || echo "config/i3/" >> .gitignore
cd private && git status
```

### 2. Fix typos and broken references
- [x] Fix typo in `src/functions/terraform.sh:5` - `tf-module-teplate` → `tf-module-template`
- [x] Fix path in `src/functions/terraform.sh:20` - Update from `$HOME/.dotfiles/functions/` to `$HOME/.dotfiles/src/functions/`
- [x] Fix path in `src/functions/git.sh` - Same old path issue
- [x] Fix unreachable code in `terraform.sh:21` (code after return 0)

### 3. Add missing .gitconfig (SKIPPED for now)
- [ ] Create `config/gitconfig` file
- [ ] Include common aliases (co, br, ci, st, etc.)
- [ ] Set core.editor
- [ ] Configure pull/push strategies
- [ ] Add diff and merge tool configurations
- [ ] Add commit signing configuration (if using GPG)
- [ ] Add Makefile target to symlink gitconfig

**Example structure:**
```ini
[alias]
  co = checkout
  br = branch
  ci = commit
  st = status
  lg = log --graph --oneline --decorate
[core]
  editor = nvim
[pull]
  rebase = false
[push]
  default = current
```

### 4. Unify EDITOR variable
- [x] Decide: Emacs or Neovim as primary editor → **Neovim**
- [x] Update both `config/bashrc` and `config/zshrc` consistently (already consistent: nvim local, vim over SSH)
- [x] Update README.md to match actual editor preference
- [x] Check all aliases that reference editor (only `alias vim='nvim'`, correct)

**Current inconsistency:**
- README says: "Emacs with evil mode" is primary
- bashrc/zshrc: `EDITOR='nvim'`

---

## Medium Priority - Filling Gaps

### 5. Add SSH configuration
- [x] Create `config/ssh_config` file → lives in `private/config/ssh/config` (work-sensitive)
- [x] Add common SSH patterns (ServerAliveInterval, AddKeysToAgent, etc.) — already in current config
- [x] Add Makefile target to symlink SSH config (`make ssh` in shells.mk)
- [ ] Document SSH key management in README — deferred

**Example structure:**
```
Host *
  ServerAliveInterval 60
  AddKeysToAgent yes

Host github.com
  IdentityFile ~/.ssh/github_key
```

### 6. Complete or remove empty files
- [x] Decide fate of `config/emacs/files.el` (not empty: 96B — sets backup dir)
- [x] Decide fate of `config/emacs/keybindings.el` (not empty: 43B — recompile binding)
- [x] Either populate them with content or remove (kept; both have content)
- [x] If removing, clean up references in `config/emacs/init.el` (fixed: removed duplicate `files.el` load, added missing `keybindings.el` load)

### 7. Add shell enhancement configs (SKIPPED for now)
- [ ] Add `.config/fzf/fzf.bash` configuration
- [ ] Add `.config/fzf/fzf.zsh` configuration
- [ ] Create `.config/ripgrep/ripgreprc` (if using ripgrep)
- [ ] Create `.config/bat/config` (if using bat)
- [ ] Create `.shellcheckrc` for shell script linting
- [ ] Add Makefile targets for these tools

### 8. Standardize shell function loading
- [x] Review bashrc array-based loading pattern
- [x] Review zshrc wildcard-based loading pattern (was missing src/functions entirely!)
- [x] Choose one consistent pattern (simple guarded glob loop)
- [x] Apply to both bashrc and zshrc
- [ ] Document the pattern in README — deferred

**Current inconsistency:**
- bashrc: Careful array-based loading with debug support
- zshrc: Simple wildcard sourcing

### 9. Document private submodule setup
- [x] Create `docs/private-setup.md`
- [x] Explain how to create private submodule
- [x] Document what belongs in public vs private
- [x] Provide example private structure
- [x] Add troubleshooting for submodule issues
- [x] Link from main README

### 10. Add backup/restore mechanism
- [x] Create `makefiles/backup.mk`
- [x] Implement `backup` target (saves existing configs)
- [x] Implement `restore` target (restores from backup)
- [x] Add timestamped backup directories (~/dotfiles-backups/<YYYYMMDD-HHMMSS>/)
- [ ] Document in README — deferred
- [x] Include backup in main Makefile

**Example structure:**
```makefile
backup: ## Backup current configs before applying dotfiles
	mkdir -p ~/dotfiles-backup-$(shell date +%Y%m%d-%H%M%S)
	# backup existing configs

restore: ## Restore previous configs
	# restore from most recent backup
```

---

## Low Priority - Nice to Have

### 11. Add pre-commit hooks
- [x] Create `.pre-commit-config.yaml` (pre-commit framework, not raw .git/hooks)
- [x] Add shellcheck validation for shell scripts
- [x] Add yamllint validation for YAML files (check-yaml hook)
- [ ] Add markdown linting — deferred (overkill)
- [x] Make hooks executable (`make git-hooks` installs)
- [ ] Document hooks in CONTRIBUTING.md — deferred (CONTRIBUTING.md doesn't exist yet, item #21)

### 12. Add terminal emulator config (SKIPPED — no terminal emulator installed yet)
- [ ] Create `config/ghostty/config` (macOS)
- [ ] Consider adding Alacritty config (cross-platform)
- [ ] Consider adding Kitty config (cross-platform)
- [ ] Add Makefile targets for terminal configs

### 13. Add language-specific tooling
- [ ] Create `.python-version` or add to `.tool-versions`
- [ ] Add `.prettierrc` for JavaScript/TypeScript formatting
- [ ] Add `.eslintrc` for JavaScript/TypeScript linting
- [ ] Add `.rustfmt.toml` for Rust formatting
- [ ] Add `.clang-format` for C/C++
- [ ] Add language-specific Makefile targets

### 14. Add testing infrastructure
- [ ] Create `tests/` directory — deferred
- [ ] Install bats or shunit2 for shell testing — deferred
- [ ] Write tests for shell functions — deferred
- [ ] Write tests for Makefile targets — deferred
- [ ] Write tests for OS detection — deferred
- [x] Add CI/CD integration (GitHub Actions) — pre-commit job added to make-stages.yaml
- [ ] Document testing in README — deferred

### 15. Create troubleshooting guide (SKIPPED for now)
- [ ] Create `docs/TROUBLESHOOTING.md`
- [ ] Document symlink conflicts resolution
- [ ] Document permission issues
- [ ] Document OS-specific problems
- [ ] Add FAQ section
- [ ] Link from main README

---

## Organizational Improvements

### 16. Deprecate /distros/ directory
- [x] Audit `/distros/` legacy scripts
- [x] Verify all functionality moved (some moved to docs/install/, others deleted)
- [x] Remove `/distros/` directory
- [ ] Update CHANGELOG with migration notes — deferred
- [x] Update README if it references old scripts

**Context:** Both `/distros/` (legacy) and `/makefiles/distros/` (modern) existed. Resolution: /distros/ contents moved to `docs/install/` (they were install recipes, not part of the Make-driven flow). `makefiles/distros/` retained.

### 17. Unify path references
- [ ] Audit all files for path references
- [ ] Choose one standard: `${DOTFILES_DIR}`, `~/.dotfiles`, or `${HOME}/.dotfiles`
- [ ] Update all inconsistent references
- [ ] Document the standard in AGENTS.md

**Current inconsistency:** All three patterns used throughout codebase

### 18. Fix zshrc macOS hardcoding
- [ ] Fix hardcoded `/opt/homebrew/bin/brew` path in zshrc
- [ ] Add detection for Homebrew location
- [ ] Add existence check before sourcing
- [ ] Test on both Intel and Apple Silicon Macs

**Issue:** Hardcoded path won't work on Intel Macs where Homebrew is in `/usr/local`

### 19. Unify function naming conventions
- [ ] Audit all shell functions
- [ ] Choose convention: snake_case or kebab-case
- [ ] Rename inconsistent functions
- [ ] Update all references
- [ ] Document naming convention

**Current inconsistency:**
- Most use snake_case: `pods_in_node`, `aws_instance`
- Some use kebab-case: `repo-template`

### 20. Complete vim configuration or remove TODO
- [ ] Either create proper vimrc file
- [ ] Or remove the vim target from editors.mk
- [ ] Update README accordingly
- [ ] Consider if nvim config is sufficient

**Current issue:** `editors.mk` has vim target marked as TODO

---

## Documentation Improvements

### 21. Create CONTRIBUTING.md
- [ ] Create `CONTRIBUTING.md` (referenced in README but missing)
- [ ] Add contribution guidelines
- [ ] Document code style and conventions
- [ ] Explain PR process
- [ ] Add testing requirements

### 22. Enhance existing documentation
- [ ] Add architecture diagram to README
- [ ] Expand brief docs (e.g., `docs/curls.md` is only 96 bytes)
- [ ] Add visual demos (GIFs/screenshots)
- [ ] Document all Makefile variables
- [ ] Add migration guides for breaking changes

### 23. Add security documentation
- [ ] Create `SECURITY.md`
- [ ] Document secrets management approach
- [ ] Explain private submodule security
- [ ] Add GPG/signing documentation
- [ ] Document credential handling

---

## Feature Additions

### 24. Add dotfile update mechanism
- [ ] Create `make dotfiles-update` target
- [ ] Pull latest changes from git
- [ ] Update submodules
- [ ] Check for tool version updates
- [ ] Notify about breaking changes

**Current gap:** `make update` only updates OS packages, not dotfiles

### 25. Add dependency checking
- [ ] Create `make check-deps` target
- [ ] Verify required tools are installed
- [ ] Check minimum versions
- [ ] Provide installation suggestions
- [ ] Add to init/install process

### 26. Expand OS support
- [ ] Add full Fedora support (currently minimal)
- [ ] Consider Windows/WSL support
- [ ] Consider Android/Termux support
- [ ] Update README with supported platforms

### 27. Add secrets management
- [ ] Document current secrets approach
- [ ] Consider adding vault integration
- [ ] Add GPG encryption for sensitive files
- [ ] Create secrets template files
- [ ] Document in private-setup.md

---

## Quality Assurance

### 28. Add linting and formatting
- [ ] Install shellcheck
- [ ] Install shfmt
- [ ] Install yamllint
- [ ] Create `.shellcheckrc` configuration
- [ ] Add `make lint` target
- [ ] Add `make format` target
- [ ] Integrate into CI/CD

### 29. Improve error handling
- [ ] Audit Makefiles for error handling
- [ ] Add `set -e` where appropriate
- [ ] Add meaningful error messages
- [ ] Add rollback mechanisms
- [ ] Test failure scenarios

### 30. Add logging
- [ ] Enhance logging functions (info, success, error, warning)
- [ ] Add verbose mode option
- [ ] Log installation steps
- [ ] Create installation logs for debugging
- [ ] Document logging approach

---

## Top 3 Priority Items

If you only do three things, do these:

1. **Add .gitconfig** (Item #3) - Most glaring omission for a dotfiles repo
2. **Fix typos and clean up old files** (Items #1, #2) - Quick credibility wins
3. **Document private submodule** (Item #9) - Your best pattern but undocumented

---

## Progress Tracking

- **Total Items:** 30 major improvements
- **Completed:** 0
- **In Progress:** 0
- **Not Started:** 30

---

## Notes

This TODO list was generated based on a comprehensive analysis of the dotfiles repository on 2025-11-13.

The repository is already well-structured with excellent documentation (README, CHANGELOG, AGENTS.md) and a solid modular Makefile architecture. These improvements would take it from **7.5/10 to 9/10**.

**Strengths to maintain:**
- Modular Makefile architecture
- Cross-platform OS detection
- Private submodule approach
- Comprehensive documentation
- Clear design philosophy

**Focus areas:**
- Complete partially-implemented features
- Add common missing dotfile components
- Clean up legacy code and inconsistencies
- Enhance testing and quality assurance
