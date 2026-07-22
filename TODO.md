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
- [x] Audit all files for path references
- [x] Choose one standard: `${DOTFILES}` in shell, `${DOTFILES_DIR}` in Makefiles
- [x] Update all inconsistent references (~/.dotfiles, $HOME/.dotfiles → ${DOTFILES})
- [x] Document the standard in AGENTS.md

**Resolved:** dropped duplicate `DOTFILES_DIR` from aliases; zshrc now also exports `DOTFILES`.

### 18. Fix zshrc macOS hardcoding
- [x] Fix hardcoded `/opt/homebrew/bin/brew` path in zshrc
- [x] Add detection for Homebrew location (checks /opt/homebrew, /usr/local)
- [x] Add existence check before sourcing
- [ ] Test on both Intel and Apple Silicon Macs — needs hardware; logic is correct

### 19. Unify function naming conventions (SKIPPED — both styles in active use; not blocking)
- [ ] Audit all shell functions
- [ ] Choose convention: snake_case or kebab-case
- [ ] Rename inconsistent functions
- [ ] Update all references
- [ ] Document naming convention

**Current inconsistency:**
- Most use snake_case: `pods_in_node`, `aws_instance`
- Some use kebab-case: `bare-clone`

### 20. Complete vim configuration or remove TODO
- [x] Removed the vim target from editors.mk (nvim is primary per #4; vim is just SSH fallback aliased to nvim)
- [x] README — already updated in #4
- [x] nvim config is sufficient

---

## Documentation Improvements

### 21. Create CONTRIBUTING.md
- [x] Create `CONTRIBUTING.md`
- [x] Add contribution guidelines
- [x] Document code style and conventions (links to AGENTS.md, no duplication)
- [x] Explain PR process
- [x] Add testing requirements (pre-commit + CI gate)

### 22. Enhance existing documentation (SKIPPED — brief docs are intentional cheatsheets; diagrams/GIFs out of scope for a personal repo)
- [ ] Add architecture diagram to README
- [ ] Expand brief docs (e.g., `docs/curls.md` is only 96 bytes)
- [ ] Add visual demos (GIFs/screenshots)
- [ ] Document all Makefile variables
- [ ] Add migration guides for breaking changes

### 23. Add security documentation (SKIPPED — secrets handling already covered in docs/private-setup.md; SECURITY.md is overkill for a personal dotfiles repo)
- [ ] Create `SECURITY.md`
- [ ] Document secrets management approach
- [ ] Explain private submodule security
- [ ] Add GPG/signing documentation
- [ ] Document credential handling

---

## Feature Additions

### 24. Add dotfile update mechanism
- [x] Create `make dotfiles-update` target
- [x] Pull latest changes from git (--ff-only for safety)
- [x] Update submodules (--remote --recursive)
- [ ] Check for tool version updates — deferred (no tool-versions file)
- [ ] Notify about breaking changes — deferred

### 25. Add dependency checking
- [x] Create `make check-deps` target (git, make, tmux, starship, pre-commit)
- [x] Verify required tools are installed
- [ ] Check minimum versions — deferred (no concrete min-version requirements known)
- [ ] Provide installation suggestions — deferred
- [ ] Add to init/install process — deferred

### 26. Expand OS support (SKIPPED — no current need for Fedora/WSL/Termux beyond what exists)
- [ ] Add full Fedora support (currently minimal)
- [ ] Consider Windows/WSL support
- [ ] Consider Android/Termux support
- [ ] Update README with supported platforms

### 27. Add secrets management (SKIPPED — private submodule is the current approach; documented in docs/private-setup.md)
- [ ] Document current secrets approach
- [ ] Consider adding vault integration
- [ ] Add GPG encryption for sensitive files
- [ ] Create secrets template files
- [ ] Document in private-setup.md

---

## Quality Assurance

### 28. Add linting and formatting
- [x] Install shellcheck (via pre-commit hook, item #11)
- [ ] Install shfmt — deferred (not currently needed; shellcheck covers correctness)
- [x] Install yamllint (check-yaml hook covers basic YAML parsing)
- [ ] Create `.shellcheckrc` configuration — deferred (current args inline in .pre-commit-config.yaml are sufficient)
- [x] Add `make lint` target
- [ ] Add `make format` target — deferred (no formatter chosen yet)
- [x] Integrate into CI/CD (item #14)

### 29. Improve error handling (SKIPPED — open-ended cleanup; address per-Makefile as concrete issues arise)
- [ ] Audit Makefiles for error handling
- [ ] Add `set -e` where appropriate
- [ ] Add meaningful error messages
- [ ] Add rollback mechanisms
- [ ] Test failure scenarios

### 30. Add logging (SKIPPED — DOTFILES_DEBUG already enables tracing in bashrc; broader logging framework is overkill)
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
