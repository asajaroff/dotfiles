# TRD: Dotfiles Refactor to GNU Stow

Status: DRAFT — fill in before implementation starts
Owner: asajaroff
Date opened: 2026-07-22

> This is a skeleton. Fill in every section below with your actual decisions.
> Nothing here is prescriptive yet — the prompts under each heading exist to
> make sure you don't forget to decide something. Delete prompts as you
> answer them. Once this is filled in and you say "go", implementation starts
> from this doc.

---

## 1. Motivation

Why now? What's actually wrong with the current setup?

- Ownership of files is unclear: `config/`, `src/`, `private/`, `envs/`
  overlap in purpose, so adding a new tool means guessing which dir it
  belongs in.
- The Makefiles (`makefiles/*.mk`) reimplement symlinking/install logic by
  hand. Stow does this natively — that custom code should go away.
- This is reorg **and** prune: since everything is being touched anyway,
  dead scripts/configs get retired along the way, not just moved.

---

## 2. Goals / Non-goals

### Goals
- KISS: prefer the simplest thing that works over the more "correct" or
  extensible one. If a decision anywhere in this doc adds a knob, a layer
  of indirection, or a script to save a few keystrokes, default to
  cutting it. This principle overrides other goals when they conflict.
- Adding a new tool's config is `mkdir <package> + stow`, nothing else.
- No custom Makefile targets for symlinking — stow owns all of that.
- One package per tool, mirroring `$HOME` layout inside it, so ownership
  of any given file is obvious from which package dir it sits in.
- Dead/unused scripts and configs get deleted during migration, not
  carried forward.

### Non-goals
- Not refactoring `private/` internals in this pass. It keeps being a
  separate, private repo — this TRD only decides how it's *linked in*
  (see §4, §6). Its own reorg into stow packages happens later, once the
  public dotfiles side is done.
- Not changing which tools are managed, only how they're linked.

---

## 3. Current-state inventory (reference, not decisions)

Top-level today, for reference while you decide the new layout:

```
config/    — aliases, bashrc, zshrc, profile, nvim, emacs, tmux, starship, vscode, firefox, conky, llms
private/   — separate git repo nested inside (secrets, homelab, een, bin, archive, own .claude)
src/       — functions/, scripts/
makefiles/ — base, backup, editors, git, kubernetes, shells, system, tools, wayland, distros
docs/      — install/, templates/, various *.md guides
envs/      — harness, minikube
.claude/   — settings, worktrees
Makefile, AGENTS.md, CONTRIBUTING.md, CHANGELOG.md, TODO.md, README.md
```

- [ ] Anything in this list that's already dead / unused? Mark for deletion.
- [ ] Anything missing from this list that matters to the reorg?

---

## 4. Target package layout

Stow works in **packages**: one top-level dir per tool, mirroring `$HOME`
structure inside it, symlinked in with `stow -d <dir> -t ~ <package>`.

- Stow root is the repo root itself (`~/.dotfiles`). Each top-level dir is
  a package, passed via `stow -d ~/.dotfiles -t ~ <package>`. No
  intermediate `packages/` subdir.
- Package list (draft — refine as each is migrated):
      - `zsh` → `.zshrc`, `.zsh/...` (from `config/zshrc`, `config/aliases`,
        `config/profile`)
      - `bash` → `.bashrc` (from `config/bashrc`) — or fold into `zsh` if
        bash is unused day-to-day; decide during migration (§7)
      - `nvim` → `.config/nvim/...`
      - `git` → `.gitconfig`, `.gitignore_global` — real files authored
        from the current `make git-config` values (§10); imperative
        target deleted once packaged
      - `tmux` → `.tmux.conf`, `.config/tmux/...`
      - `starship` → `.config/starship.toml`
      - `emacs` — **out of scope for this pass** (§10); not migrated,
        left as-is or deleted per §3's dead-file audit
      - `vscode` → editor settings (only if actually symlinked anywhere —
        confirm during migration, VS Code settings sync may make this moot)
      - `bin` → contents of `src/scripts/` only, targeting somewhere on
        `$PATH` (e.g. `~/.local/bin` or `~/bin`)
      - `functions` → contents of `src/functions/`, sourced by path from
        the shell rc (not PATH-based) — kept separate from `bin` since
        these are sourced, not executed (§10)
      - `firefox`, `conky`, `llms` → one package each, TBD contents
- `makefiles/*.mk`: symlinking logic is deleted outright (stow replaces
  it). Whatever's left — OS package installs, non-linking setup — collapses
  into a much smaller `Makefile`/`install.sh` (see §5), not one `.mk` per
  concern.
- `private/`: stays the git submodule it already is today (confirmed via
  `.gitmodules`, §10) — not replaced with a sibling clone. It becomes a
  stow package (or set of packages) itself so its own contents get
  symlinked the same way as the public ones, stowed from
  `~/.dotfiles/private` with its own `-d`. Its internal reorg is deferred (non-goal,
  §2) — for this pass it's linked in as one lightly-adapted package, not
  redesigned.
- `docs/`, `envs/`, `.claude/`: repo-internal only, never stowed/symlinked
  anywhere.

---

## 5. Bootstrap / install flow

- Single command is `make install` (or similarly named target). The
  Makefile survives but shrinks to orchestration only: installing stow
  itself + OS deps, then invoking `stow` across the package list. No
  per-tool symlink targets — those are deleted along with the old `.mk`
  linking logic.
- OS/distro differences: handled by having separate packages where a
  config genuinely diverges (e.g. `zsh-linux` / `zsh-macos`), not by
  branching logic inside one package. Most packages stay OS-agnostic and
  need no variant. `make install` picks the right package set for the
  detected OS.
- `stow -D` / re-stow after a rename: no custom tooling — `make install`
  is idempotent (safe to re-run), and renames are handled by `stow -D
  <old-package>` then `stow <new-package>` by hand, same as any stow
  workflow. Not automated because renames are rare enough not to justify
  a wrapper.
- Conflict handling: no automated backup step. If a target already exists
  and isn't a symlink, `stow` errors out as usual and it's resolved by
  hand on that machine. Deliberate choice — avoids `install.sh` silently
  moving files the user didn't expect touched.

---

## 6. Secrets / private data

- Deferred beyond this pass: secrets management moves to Bitwarden
  (import/export secrets.env, secrets.env.gpg from/to Bitwarden), replacing
  the gpg-file approach entirely. Tracked as a follow-up task, not part of
  this refactor's scope — for now `secrets.env`/`secrets.env.gpg` stay as
  they are inside `private/`.
- Any requirement that `private/` never gets symlinked into a package
  that could be shared/committed by accident? — n/a once secrets move to
  Bitwarden; until then, same protection as today (private/ stays a
  separate, gitignored/private repo, no secrets file ever placed in a
  public package dir).

---

## 7. Migration plan

- Incremental: old Makefile-based setup and new stow packages coexist
  during migration. Each package is cut over and verified independently
  (§8) before moving to the next — nothing is deleted from the old setup
  until its replacement package is confirmed working.
- Order of migration: `starship` first (single file, zero dependencies) to
  prove out the package pattern and CI check, then work outward. Shell
  startup (`zsh`) — the package everything else implicitly depends on —
  is migrated only after the pattern is proven, not first.
- Single primary machine, reinstall acceptable. No cross-machine migration
  script needed — conflicting old symlinks are resolved by hand as they
  come up during migration (consistent with the manual conflict handling
  in §5), not via an automated teardown step.

---

## 8. Testing / verification

- CI job added (GitHub Actions or equivalent) that runs `stow -n -v`
  across all packages on every push, catching structural mistakes
  (conflicting targets, malformed package dirs) before they land.
- `.pre-commit-config.yaml`: kept and extended, not just reviewed at the
  end. New hooks added as part of this refactor:
  - `stow -n -v` dry-run check (mirrors the CI job above, catches
    structural mistakes before they're even pushed).
  - Bash script validation via `shellcheck` (and `shfmt` or similar for
    formatting, if that doesn't fight KISS) over `src/scripts/`,
    `src/functions/`, and any package containing shell scripts.
  - Existing hooks reviewed for stale path references (`makefiles/`,
    `config/`) once the corresponding package migration lands, not
    deferred to one big end-of-migration pass.
- No smoke test beyond dry-run + shellcheck in this pass. `stow -n -v`
  structural checks (CI + pre-commit) and shellcheck are the bar;
  verifying a shell config loads without error is left to manual testing
  on the primary machine, not automated — revisit only if a real
  regression slips through.

---

## 9. Documentation impact

- `README.md`, `CONTRIBUTING.md`, `docs/install/*`: left stale during
  migration, rewritten in one pass at the very end once the package
  layout has settled — avoids repeatedly rewriting docs mid-migration.
- [ ] Does `AGENTS.md` / `.claude/` config need updating to reflect new
      paths? (Fold into the same end-of-migration docs pass.)

---

## 10. Open questions

Surfaced by the `/software-architect` review against the actual repo tree,
resolved below:

- `bin`/`functions` split: `src/scripts/*` (executable) become the `bin`
  package on `$PATH`. `src/functions/*` (sourced by `zshrc`/`bashrc`, not
  executable) do **not** go in `bin` — they get their own `functions`
  package, sourced by path from the shell rc, not PATH-based. §4's `bin`
  package description is corrected by this.
- `git` package: no `.gitconfig`/`.gitignore_global` exist today (git
  config is set imperatively via `make git-config`). This pass creates
  real `git/.gitconfig` and `git/.gitignore_global` files authored from
  the current `git-config` target's values, and deletes that imperative
  target.
- `private/`: confirmed already a git submodule — keeps that relationship.
  Stow runs against `~/.dotfiles/private` (the submodule checkout) with
  its own `-d`, not a separate sibling clone. Corrects §4's "cloned
  alongside/under" phrasing to mean "submodule, same as today."
- `emacs`: **removed from scope entirely for this pass.** Not migrated to
  a package; `config/emacs/*` and its Makefile target are left as-is
  (or deleted if the §3 audit calls them dead — decide there, not here).
  Drop `emacs` from the §4 package list.
- `make backup`/`make restore` (`makefiles/backup.mk`): deleted along
  with the rest of the symlinking-era Makefiles. Consistent with §5's
  "no automated backup" stance and KISS (§2) — stow's own conflict
  errors are the safety net, not a separate manual utility.
- GNU Stow install step: not currently installed on the primary machine.
  `make install` (§5) must install it as an explicit first step, per OS
  (`pacman -S stow` / `apt install stow` / `brew install stow`).
- CI `emacs` content-validation job (`.github/workflows/make-stages.yaml`):
  moot now that `emacs` is out of scope — removed, not migrated.

---

## 11. Sign-off

- [ ] All sections above filled in
- [ ] Ready to instruct implementation to begin
