# PRD: Dotfiles Refactor to GNU Stow

Source TRD: `docs/trd-stow-refactor.md`. This PRD turns that TRD into an
ordered, actionable task list. It does not re-open decisions the TRD already
made; where the TRD is internally inconsistent with itself or with the
current repo state, that's called out below rather than resolved silently.
See `docs/arch-stow-refactor.md` for the rationale behind each call.

## Problem Statement

Symlinking today is hand-implemented in `makefiles/{shells,editors,backup}.mk`
via direct `ln -sf` calls, and file ownership is split unclearly across
`config/`, `src/`, `private/`, `envs/`. Adding a new tool means guessing
which directory it belongs in and writing new Makefile targets. This work
replaces that with GNU Stow (one package per tool, mirroring `$HOME`) and
prunes files that turn out to be dead along the way.

## Goals

- `mkdir <package> + stow` is the entire cost of adding a new tool's config.
- No custom Makefile symlink targets remain — stow owns all linking.
- Every migrated package is verified (via `stow -n -v`) before the old
  Makefile targets it replaces are deleted.
- CI and pre-commit both gate on `stow -n -v` across all packages.
- Dead scripts/configs identified during migration are deleted, not carried
  forward into a package.

## Non-Goals

- Reorganizing `private/`'s internal contents (only how it's linked in
  changes; deferred to a later pass).
- Changing which tools are managed — only how they're linked. (Note: this
  is in tension with the prune-as-you-go goal above; see Risks below.)
- Automating secrets migration to Bitwarden (tracked separately).
- Automated backup/rollback of pre-existing dotfiles on install (deliberate;
  conflicts are surfaced, not auto-resolved).
- Re-auditing every OS-package-install Makefile target
  (`tools.mk`/`kubernetes.mk`/`wayland.mk`/`distros/*.mk`) for staleness —
  only the symlinking-related targets are in scope for deletion this pass,
  though candidates found elsewhere are flagged for a future pass.

## Consistency Check — Flags on the TRD as Written

These are gaps/contradictions found while turning the TRD into a plan, not
new decisions. Each is either an explicit TRD open item (§3, §10 — call them
out, don't guess) or a mismatch between the TRD's stated plan and what's
actually in the repo today.

1. **§3 dead-file audit — explicitly unresolved in the TRD**, both
   checkboxes unchecked. Candidates surfaced during this review (for the
   user to confirm/reject, not pre-decided):
   - `makefiles/editors.mk`'s `nvim` target symlinks
     `config/nvim/lua` — that directory doesn't exist in the repo
     (`config/nvim/` only has `init.lua`). Already a dangling reference
     today, independent of the stow migration.
   - `makefiles/tools.mk` has both a `bitwarden` target (generic wget) and a
     `bitwarden-cli` target pinned to a specific old version
     (`1.22.1`) — likely duplicated/stale.
   - `makefiles/kubernetes.mk`'s `kubernetes` target is Darwin-only,
     downloads a versioned `kubectl` binary, and never symlinks it to an
     unversioned name or chmods it executable — looks incomplete/broken as
     written.
   - `config/vscode.settings.json`, `config/vscode/workspaces/*`,
     `config/conky.conf`, `config/firefox/LeechBlockOptions.txt`,
     `config/llms/claude` (empty dir) — **none of these are referenced by
     any existing Makefile target.** They're not linked anywhere today.
     TRD §4 already marks `vscode` as "confirm during migration" and
     `firefox`/`conky`/`llms` as "TBD contents" — this review confirms all
     four currently have zero linking mechanism, strengthening the case
     they need an explicit keep-or-drop call, not just "TBD contents."
   - `config/profile` contains `export GITHUB_MCP_PAT="REDACTED"` — a
     credential-shaped line sitting in a file slated to become a public
     stow package. Needs explicit confirmation this is genuinely scrubbed
     (not just visually redacted) before `profile` is packaged, given §6's
     stance that secrets never sit in a public package dir.
   - `src/functions/.claude/settings.local.json`,
     `src/scripts/.claude/settings.local.json`, and stray
     `.claude/worktrees/*` checkouts — Claude Code tool artifacts, not
     dotfiles content; out of scope for stow packages but worth a decision
     on whether they're gitignored or removed.

2. **§10 open questions — explicitly empty in the TRD.** Items this review
   surfaces that belong there:
   - `bin` package scope: TRD §4 puts both `src/functions/` (sourced by a
     loop in `zshrc`/`bashrc`, not executed standalone) and `src/scripts/`
     (executable, invoked today via `config/aliases` pointing at an
     absolute repo path, e.g. `alias pyexec="${DOTFILES}/src/scripts/pyexec.py"`)
     into one `$PATH`-targeted package. Putting sourced function files on
     `$PATH` doesn't make them get sourced — they need a different
     mechanism. See arch doc's Key Decisions for the recommended split.
   - `git` package: TRD §4 names `.gitconfig`/`.gitignore_global` as its
     contents, but no such files exist in the repo — `git config --global`
     is set imperatively today by `makefiles/git.mk`. Introducing a real
     `.gitconfig` is a small design decision beyond "how it's linked."
   - GNU Stow itself is not installed on the primary machine yet — `make
     install` needs an explicit "install stow" step per OS; TRD doesn't
     name this step outright (implied by §5 but not spelled out).
   - `private/` is confirmed to already be a git submodule
     (`.gitmodules`). TRD §4's "cloned alongside/under `~/.dotfiles`" reads
     ambiguously as either "keep the existing submodule" or "replace it
     with a plain sibling clone" — needs a pick.
   - `emacs` package target ambiguity: TRD §4 offers `.emacs.d/...` *or*
     `.config/emacs/...` as options. Today only `config/emacs/init.el` is
     symlinked, to `~/.emacs` (not `~/.emacs.d/`) — the sibling `.el` files
     (`evil.el`, `ui.el`, etc.) are loaded by `init.el` relative to that
     directory, not individually symlinked. Whichever target is chosen
     changes Emacs's own config-discovery convention and needs the CI
     `emacs` job's hardcoded path updated to match.
   - Existing `make backup` / `make restore` targets
     (`makefiles/backup.mk`): TRD §5 rules out an *automated* backup step
     during install, but doesn't say whether the pre-existing manual
     opt-in backup/restore commands are kept as a standalone utility or
     deleted along with the rest of the symlinking-era Makefiles.
   - CI: does the existing `emacs` job's actual *content* check (does
     `init.el` load in batch mode without erroring) get kept as a
     supplementary job once `emacs` is a package, or dropped entirely per
     §8's "no smoke test beyond dry-run + shellcheck"? TRD §8 implies the
     latter but doesn't say so about this specific existing job.

3. **Minor internal tension, not a blocker:** TRD §1/§2 frame this as
   "reorg **and** prune" and list "dead scripts/configs get deleted" as a
   goal, while §2's non-goals say "not changing which tools are managed."
   These coexist fine as long as "prune" only removes files nobody uses
   (confirmed via §3), not tools still in active use — but the boundary is
   exactly what §3's audit is for, so §3 should be resolved deliberately,
   case by case, not as a rubber-stamp step.

4. **Minor cross-reference gap:** TRD §4 says the bash/zsh fold decision
   happens "during migration (§7)," but §7's migration plan never actually
   mentions it. Captured explicitly as its own task below (Task 3) so it
   doesn't fall through.

## User Stories + Acceptance Criteria

**As the maintainer, I want each tool's config in its own stow package, so
that adding a new tool is just `mkdir <package> + stow`.**
1. Every package directory mirrors `$HOME`'s layout for the files it owns
   (e.g. `zsh/.zshrc`, `nvim/.config/nvim/init.lua`).
2. `stow -n -v <package>` reports no conflicts for a clean `$HOME`.
3. The corresponding old Makefile symlink target no longer exists once the
   package is verified.

**As the maintainer, I want `make install` to be the only bootstrap
command, so that I don't need to remember per-tool targets.**
4. `make install` installs stow (if missing) + OS deps, then stows every
   package in the OS-appropriate set.
5. Running `make install` twice in a row produces no errors and no changed
   state on the second run (idempotent).
6. A pre-existing real file (not a symlink) at a stow target causes `stow`
   to error visibly, with no data silently overwritten.

**As a contributor, I want CI and pre-commit to catch structural stow
mistakes before merge, so that broken packages don't land.**
7. A GitHub Actions job runs `stow -n -v` across all packages on every push
   and fails the build on conflicts or malformed package dirs.
8. `.pre-commit-config.yaml` runs the same `stow -n -v` check locally plus
   `shellcheck` (and `shfmt` if adopted) over `src/scripts/`,
   `src/functions/`, and any package's shell files.
9. Existing pre-commit hooks are checked for stale `makefiles/`/`config/`
   path references as each corresponding package migration lands (not
   batched to the end).

**As the maintainer, I want dead files identified during migration removed,
not carried into a package.**
10. Every item in the Consistency Check's §3 candidate list above has an
    explicit keep/drop decision recorded before its owning package is
    finalized.

## Risks & Open Questions

All items are cross-referenced from the Consistency Check section above;
repeated here per the PRD template's structure, not duplicated content:

- §3 dead-file audit is unresolved — this plan lists candidates but makes
  no deletions on the user's behalf.
- §10 is empty in the TRD; the six items above (bin-package scope, git
  package contents, stow install step, private/ submodule vs. clone
  semantics, emacs target path, backup/restore target fate, CI emacs-content
  job fate) need explicit answers before their respective tasks below can
  be marked complete.
- Risk: migrating `bin`/`functions` incorrectly (per gap #2 above) would
  silently break every currently-sourced shell function — flagged as a
  correctness risk, not just a style nit.
- Risk: `profile`'s `GITHUB_MCP_PAT` line ships into a public package
  before its redaction is confirmed genuine.

## Implementation Tasks

Process note: each task below ends with its own commit, in conventional
commit format (`type(scope): subject`, e.g. `feat(stow): migrate starship
package`, `chore(makefiles): remove shells.mk symlink targets`). One
commit per task, not one giant commit at the end — keeps each migration
step bisectable and reviewable independently. No
`Co-Authored-By` trailers.

```yaml
tasks:
  - id: 1
    title: "Resolve open questions blocking package scope"
    status: done
    description: >
      Get explicit answers to the §10 items above (bin-package split,
      git package contents, private/ submodule-vs-clone, emacs — dropped,
      backup/restore — deleted, CI emacs job — removed) before starting
      package migration — several later tasks depend on these answers.
    depends_on: []
    files_to_create: []
    files_to_modify: ["docs/trd-stow-refactor.md"]
    acceptance_criteria: "TRD §10 filled in with answers; no remaining blocking unknowns for tasks 4-11."
    estimated_complexity: low
    notes: "Answered and recorded in TRD §10/§4. Later tasks' depends_on: [1] are satisfied."

  - id: 2
    title: "Dead-file audit (§3)"
    description: >
      Walk the candidate list in the Consistency Check section, decide
      keep/drop/needs-rework for each, and record the decision (check off
      §3 in the TRD).
    depends_on: []
    files_to_create: []
    files_to_modify: ["docs/trd-stow-refactor.md"]
    acceptance_criteria: "Every candidate in the audit list has an explicit disposition; TRD §3 checkboxes checked."
    estimated_complexity: medium
    notes: "Do this before or alongside each package's migration task, not as one big end-of-project pass — deletions land with the package they belong to."

  - id: 3
    title: "Install GNU Stow prerequisite handling"
    description: >
      Add an `install-stow` (or similarly named) target/step to the
      Makefile that installs GNU Stow per OS_FAMILY before any `stow`
      invocation runs.
    depends_on: [1]
    files_to_create: []
    files_to_modify: ["makefiles/base.mk", "Makefile"]
    acceptance_criteria: "install-stow target exists and installs stow standalone on a machine that doesn't have it. (Not verifiable via 'make install' yet — that target doesn't exist until Task 14 wires install-stow into it.)"
    estimated_complexity: low
    notes: "Reworded acceptance criteria per developer review: the original wording assumed 'make install' already existed, which it doesn't until Task 14."

  - id: 4
    title: "Migrate starship package (proof of pattern)"
    description: >
      Create `starship/.config/starship.toml` package from
      `config/starship.toml`, stow it, verify with `stow -n -v`, then
      delete the `shell-requisites` target in `makefiles/shells.mk` that
      symlinked it.
    depends_on: [3]
    files_to_create: ["starship/.config/starship.toml"]
    files_to_modify: ["makefiles/shells.mk"]
    acceptance_criteria: "stow -n -v starship reports clean; ~/.config/starship.toml resolves through the new package; old shell-requisites target removed."
    estimated_complexity: low
    notes: "First package per TRD §7 — establishes the CI/pre-commit dry-run pattern used by every later package."

  - id: 5
    title: "Add stow dry-run check to CI and pre-commit"
    description: >
      Add a `stow -n -v` job to GitHub Actions and a matching local hook
      to `.pre-commit-config.yaml`, scoped to whatever packages exist at
      each point in the migration (grows as packages land).
    depends_on: [4]
    files_to_create: []
    files_to_modify: [".github/workflows/make-stages.yaml", ".pre-commit-config.yaml"]
    acceptance_criteria: "CI fails on a deliberately broken package dir; pre-commit blocks the same locally; CI's stow invocation works against $GITHUB_WORKSPACE (actions/checkout does not place the repo at ~/.dotfiles) — either pass -d \"$GITHUB_WORKSPACE\" explicitly or add the same 'ln -sf ${{ github.workspace }} ${HOME}/.dotfiles' workaround the existing emacs job already uses, before assuming stow -d ~/.dotfiles works unmodified in CI."
    estimated_complexity: medium
    notes: "Verify against the starship package first since it's the only one that exists at this point. Flagged by developer review: without the workspace-path fix, this job fails even on a correct package, not just a broken one."

  - id: 6
    title: "Migrate tmux package"
    description: "config/tmux.conf -> tmux/.tmux.conf; config/tmux/sessions/* mirrored under the package if still wanted (subject to task 2's audit)."
    depends_on: [5]
    files_to_create: ["tmux/.tmux.conf"]
    files_to_modify: ["makefiles/shells.mk"]
    acceptance_criteria: "stow -n -v tmux clean; old tmux target removed from shells.mk."
    estimated_complexity: low
    notes: ""

  - id: 7
    title: "Migrate nvim package"
    description: >
      config/nvim/init.lua -> nvim/.config/nvim/init.lua. Resolve the
      dangling config/nvim/lua reference found in task 2's audit before
      or during this migration.
    depends_on: [5, 2]
    files_to_create: ["nvim/.config/nvim/init.lua"]
    files_to_modify: ["makefiles/editors.mk"]
    acceptance_criteria: "stow -n -v nvim clean; nvim target removed from editors.mk; no dangling lua/ reference carried into the package."
    estimated_complexity: low
    notes: ""

  - id: 8
    title: "Remove emacs from CI (out of scope)"
    description: >
      Emacs is explicitly out of scope for this pass (TRD §10) — not
      migrated to a package. Remove the CI emacs content-validation job
      from make-stages.yaml since it tests a symlink mechanism this
      refactor doesn't touch; config/emacs/* is left as-is pending task 2's
      dead-file audit.
    depends_on: []
    files_to_create: []
    files_to_modify: [".github/workflows/make-stages.yaml"]
    acceptance_criteria: "emacs CI job removed; config/emacs/* and its Makefile target untouched by this task."
    estimated_complexity: low
    notes: "Resolved per TRD §10 — emacs migration dropped entirely, not deferred."

  - id: 9
    title: "Migrate git package"
    description: >
      Author git/.gitconfig and git/.gitignore_global from the current
      imperative git-config target's values (TRD §10), package them,
      delete the imperative target.
    depends_on: [1, 4]
    files_to_create: ["git/.gitconfig", "git/.gitignore_global"]
    files_to_modify: ["makefiles/git.mk"]
    acceptance_criteria: "stow -n -v git clean; git-config imperative target removed or explicitly kept with rationale recorded."
    estimated_complexity: low
    notes: "Decision resolved in TRD §10. depends_on corrected to include 4 per developer review: acceptance criteria needs stow -n -v, which requires stow to be proven working (Task 4) before this task can actually be verified — was previously only gated on Task 1, letting it run before stow was confirmed installed/working."

  - id: 10
    title: "Resolve bash/zsh fold decision, migrate zsh (and bash if kept separate)"
    description: >
      Decide whether bash gets folded into zsh or stays a separate
      package (TRD §4/§7 cross-reference gap — this task is where that
      decision actually gets made, since §7 never named a step for it).
      Migrate config/zshrc + config/aliases + config/profile accordingly.
      Note: config/profile is currently symlinked by the bash target in
      shells.mk, not zsh's — this task's scope crosses that Makefile
      boundary deliberately. Also update the five path-editing aliases in
      config/aliases (vimrc, zshrc, bashrc, tmuxrc, aliasrc) that hardcode
      ${DOTFILES}/config/... paths — those targets move once nvim/zsh/
      bash/tmux packages land, and nothing else in this task list updates
      them.
    depends_on: [1, 5]
    files_to_create: ["zsh/.zshrc", "zsh/.aliases (or wherever aliases lands)", "<bash-or-zsh-package>/.profile"]
    files_to_modify: ["makefiles/shells.mk", "config/aliases"]
    acceptance_criteria: "stow -n -v zsh (and bash, if kept) clean; shells.mk symlink targets removed; profile's GITHUB_MCP_PAT line confirmed genuinely scrubbed before profile is packaged; the vimrc/zshrc/bashrc/tmuxrc/aliasrc aliases in config/aliases point at the new package paths, not deleted config/ files."
    estimated_complexity: medium
    notes: "Migrated last among the 'core' set per TRD §7, since other packages implicitly depend on shell startup being stable. files_to_create/modify expanded per developer review — original list only had zsh/.zshrc despite the description covering aliases and profile too."

  - id: 11
    title: "Migrate bin and functions packages"
    description: >
      src/scripts/ -> bin package (executable, targets $PATH, e.g.
      ~/.local/bin). src/functions/ -> separate functions package, sourced
      by path from the shell rc — not folded into bin, not PATH-based
      (TRD §10). Update config/aliases entries that currently hardcode
      ${DOTFILES}/src/scripts/... paths now that scripts move to $PATH.
    depends_on: [10]
    files_to_create: ["bin/.local/bin/*", "functions/*", "functions/resources/template_CHANGELOG"]
    files_to_modify: ["config/aliases"]
    acceptance_criteria: "Every function still sourced correctly by the shell rc; every script still invocable by its alias or bare name; stow -n -v bin and stow -n -v functions both clean; src/functions/resources/template_CHANGELOG (referenced by terraform.sh, not itself a .sh file) lands in the functions package, not dropped."
    estimated_complexity: medium
    notes: "Highest-risk task in the list — the bin/functions split must be followed exactly or sourced functions silently stop working. resources/template_CHANGELOG called out explicitly per developer review since it's non-obvious cargo that a naive '*.sh split' could miss."

  - id: 12
    title: "vscode / firefox / conky / llms packages — keep-or-drop per task 2"
    description: >
      None of these are linked by any existing Makefile target today.
      Create packages only for the ones task 2's audit keeps; drop the
      rest.
    depends_on: [2]
    files_to_create: []
    files_to_modify: ["config/"]
    acceptance_criteria: "Each of vscode/firefox/conky/llms has an explicit created-package-or-deleted disposition, matching task 2's recorded decision."
    estimated_complexity: low
    notes: ""

  - id: 13
    title: "Migrate private/ as its own stowed package(s)"
    description: >
      Per task 1's submodule-vs-clone answer, stow private/'s contents
      (bin, config, een, homelab, archive) with their own -d, without
      reorganizing private/'s internals (non-goal).
    depends_on: [1, 5]
    files_to_create: []
    files_to_modify: ["makefiles/shells.mk (ssh target)", "private/ (as agreed with its own maintenance process)"]
    acceptance_criteria: "stow -n -v against private/'s own -d reports clean; ssh config still resolves through the new mechanism."
    estimated_complexity: medium
    notes: "private/ is a separate repo — coordinate changes there per its own process, this task only covers the linking side."

  - id: 14
    title: "Collapse remaining Makefile to orchestration-only"
    description: >
      Delete makefiles/shells.mk, editors.mk, backup.mk (per task 1's
      backup/restore fate answer) once every package they covered has
      migrated. Add the install target that computes STOW_PACKAGES per
      OS_FAMILY and loops stow across it.
    depends_on: [3, 4, 6, 7, 8, 9, 10, 11, 12, 13]
    files_to_create: []
    files_to_modify: ["Makefile", "makefiles/base.mk"]
    acceptance_criteria: "No ln -sf calls remain anywhere under makefiles/; make install is idempotent and covers every migrated package; install-stow (Task 3) is wired in as the first step of install, satisfying Task 3's deferred acceptance criteria."
    estimated_complexity: medium
    notes: ""

  - id: 15
    title: "Final docs pass"
    description: >
      Rewrite README.md, CONTRIBUTING.md, AGENTS.md, docs/install/* to
      reflect the new package layout, per TRD §9.
    depends_on: [14]
    files_to_create: []
    files_to_modify: ["README.md", "CONTRIBUTING.md", "AGENTS.md", "docs/install/"]
    acceptance_criteria: "No remaining references to deleted makefiles/*.mk targets or the old config/ layout in any doc."
    estimated_complexity: medium
    notes: "Deliberately done once at the end per TRD §9 — do not start this early."
```

## Handoff Checklist
- [x] TRD §10 open questions answered: bin/functions split, git package
      scope, private/ submodule semantics, emacs (dropped from scope),
      backup/restore fate (deleted), stow install step
- [ ] TRD §3 dead-file audit resolved (task 2) — still open, do
      alongside each package's migration per task 2's notes
- [x] All architectural decisions have rationale documented in
      `docs/arch-stow-refactor.md`
- [x] Task list is dependency-ordered (see `depends_on` above)
- [x] `files_to_create` / `files_to_modify` specified for every task
- [x] Stack and constraints confirmed with user — all §10 blockers
      resolved; only §3 (dead-file keep/drop calls) remains open, and is
      handled task-by-task rather than blocking kickoff
