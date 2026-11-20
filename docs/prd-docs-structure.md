# PRD: Documentation Structure for the Dotfiles Repository

> Status: **Draft — pending user review.** No files are moved or renamed by this document; it is a plan only.

## Problem Statement

The `docs/` directory has grown organically into ~20 markdown files with no index, no taxonomy, and inconsistent conventions:

- **No entry point.** There is no `docs/README.md`; the only way to discover content is `ls docs/`.
- **Mixed content types at the same level.** Cheatsheets (`kubectl.md`, `oneliners.md`), tool setup notes (`asdf.md`, `argocd.md`), OS guides (`GNOME.md`, `linux/`), install recipes (`install/`), and repo meta-docs (`private-setup.md`) all sit side by side.
- **Misleading or missing titles.** `curls.md` is actually Elasticsearch notes; `argocd.md` and `aws/rds/mariadb.md` have no H1 heading.
- **Inconsistent naming.** `GNOME.md` is uppercase while everything else is lowercase; some names describe a tool (`kubectl.md`), others a command (`curls.md`, `netcats.md`).
- **Root-level doc sprawl.** `README.md`, `AGENTS.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, and `TODO.md` each link into `docs/` ad hoc, so any rename silently breaks links (no link checking exists).

The cost is small but constant: content is hard to find, hard to place ("where do I put a new Helm note?"), and renames break cross-references.

## Goals

1. Every documentation file is reachable from a single index (`docs/README.md`) — 100% coverage.
2. A contributor can decide where a new doc belongs in under 30 seconds using a documented decision rule.
3. All doc filenames follow one convention (lowercase kebab-case, `.md`).
4. Every doc has an H1 title that matches its actual content.
5. Zero broken relative links in `README.md`, `CONTRIBUTING.md`, `AGENTS.md`, and `docs/**` after the reorganization (verified by a link check).

## Non-Goals

- **Rewriting content.** Files are moved, renamed, and given titles — their bodies are not edited beyond the H1 line.
- **Documentation for `private/`.** The private submodule keeps its own docs (`private/een/docs/`); they are out of scope, except that `docs/private-setup.md` (which documents the public/private boundary) stays in scope.
- **Generated documentation sites** (MkDocs, Docusaurus, GitHub Pages). Plain markdown browsed on GitHub/in-editor is the delivery format.
- **Restructuring root-level files.** `README.md`, `AGENTS.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `TODO.md` stay at the root; only their links into `docs/` are updated.
- **Documenting `src/functions/` per-function.** Function-level docs remain inline comments per `AGENTS.md` conventions.

## User Stories + Acceptance Criteria

### Story 1 — Discoverability
As the **repository owner**, I want a `docs/README.md` index grouped by category, so that I can find any note without grepping.

1. `docs/README.md` exists and links to every `.md` file under `docs/` (excluding itself).
2. Links are grouped under the category headings defined in the architecture doc.
3. The root `README.md` "Project Structure" section links to `docs/README.md`.

### Story 2 — Predictable placement
As a **contributor** (per `CONTRIBUTING.md`, PRs are welcome), I want a documented rule for where new docs go, so that I don't guess.

1. `docs/README.md` contains a short "Adding a doc" section with the category decision rule (see flowchart in arch doc).
2. `CONTRIBUTING.md` "Scope guidance" references that section.
3. Each category directory's purpose is stated in one line in the index.

### Story 3 — Consistent naming and titles
As a **reader**, I want filenames and H1 titles to describe the content, so that search results and editor tabs are meaningful.

1. All files under `docs/` are lowercase kebab-case.
2. `GNOME.md` → `gnome.md`; `curls.md` → `elasticsearch.md` (content is Elasticsearch); `netcats.md` → `netcat.md`.
3. Every doc starts with an H1 that matches its content (`argocd.md` and `aws/rds/mariadb.md` gain titles).
4. All moves use `git mv` so history is preserved.

### Story 4 — Link integrity
As the **repository owner**, I want cross-references checked, so that reorganizations don't silently break links.

1. After all moves, a link check over `*.md` (root + `docs/`) reports zero broken relative links.
2. The check is runnable locally via a Make target or pre-commit hook (decision recorded in arch doc).
3. `AGENTS.md` directory-structure snippet is updated to reflect the new `docs/` layout.

## Risks & Open Questions

| # | Item | Type | Needs user input? |
|---|------|------|-------------------|
| 1 | **Rename approvals.** `curls.md` → `elasticsearch.md` changes a name the owner may type from muscle memory. | Open question | Yes — confirm each rename in Task 2. |
| 2 | **Category granularity.** With ~20 files, 5 categories may be over- or under-split; the proposed taxonomy (see arch doc) assumes the collection keeps growing at the current rate. | Assumption | Confirm taxonomy before Task 2. |
| 3 | **Link-check tooling.** `lychee` and `markdown-link-check` both work; adding a pre-commit hook adds a dependency for all contributors. The plan proposes an *optional* Make target instead of a mandatory hook. | Decision pending | Yes — see ADR "Link checking" in arch doc. |
| 4 | **External bookmarks.** Anyone with deep links to old paths (e.g. `docs/GNOME.md`) gets a 404 on GitHub. No redirect mechanism exists for plain markdown. Mitigation: one-time break, acceptable for a personal repo. | Risk | No, unless user objects. |
| 5 | **`docs/templates/` overlap.** `src/functions/resources/template_README.md` also holds a template; whether to consolidate is deferred. | Open question | Yes — defaulted to "leave as is". |
| 6 | **Worktree copies.** `.claude/worktrees/*` contain stale copies of `docs/`; they are agent worktrees and are excluded from all tasks. | Assumption | No. |

**Explicit assumptions (kickoff answers inferred from the repo, not stated by the user):**
- Stack: plain Markdown rendered by GitHub and editors; Make-driven tooling; POSIX shell. No doc generators.
- Users: the repo owner (primary, daily reference use) and occasional external contributors (per `CONTRIBUTING.md`).
- Integration points: `README.md`, `AGENTS.md`, `CONTRIBUTING.md` links; `.pre-commit-config.yaml`; `makefiles/*.mk`.
- Success = goals above; no performance/auth/API/observability requirements apply to a static docs reorg.

## Implementation Tasks

```yaml
tasks:
  - id: 1
    title: "Confirm taxonomy and renames with owner"
    description: >
      Present the category map and the rename list (GNOME.md->gnome.md,
      curls.md->elasticsearch.md, netcats.md->netcat.md) for approval.
      Resolve open questions 1, 2, 3, and 5 from the PRD.
    depends_on: []
    files_to_create: []
    files_to_modify: []
    acceptance_criteria: "Owner has approved or amended the taxonomy and every rename; ADR statuses in arch doc updated from Proposed to Accepted."
    estimated_complexity: low
    notes: "Blocking gate — no file moves before this."

  - id: 2
    title: "Move and rename docs into category directories"
    description: >
      Using git mv only: create docs/cheatsheets/, docs/tools/ and move files
      per the target layout in arch-docs-structure.md. docs/install/,
      docs/linux/, docs/aws/, docs/templates/ already exist. Apply approved
      renames. Add missing H1 titles to argocd.md and aws/rds/mariadb.md;
      fix curls.md title to match Elasticsearch content.
    depends_on: [1]
    files_to_create: []
    files_to_modify:
      - "docs/** (git mv moves per approved layout)"
      - "docs/tools/argocd.md (add H1)"
      - "docs/aws/rds/mariadb.md (add H1)"
    acceptance_criteria: "git log --follow works for every moved file; all docs lowercase kebab-case; every doc has a content-accurate H1."
    estimated_complexity: medium
    notes: "Body content untouched except H1 lines. Exclude .claude/worktrees."

  - id: 3
    title: "Create docs index"
    description: >
      Create docs/README.md listing every doc grouped by category, with a
      one-line purpose per category and an 'Adding a doc' section containing
      the placement decision rule.
    depends_on: [2]
    files_to_create:
      - "docs/README.md"
    files_to_modify: []
    acceptance_criteria: "Every .md under docs/ (excluding worktrees and the index itself) is linked exactly once; placement rule present."
    estimated_complexity: low
    notes: ""

  - id: 4
    title: "Update cross-references in root docs"
    description: >
      Update links and directory-structure snippets in README.md (Project
      Structure section, docs/private-setup.md link), AGENTS.md (Directory
      Structure block), and CONTRIBUTING.md (private-setup links, scope
      guidance pointer to docs/README.md#adding-a-doc).
    depends_on: [2, 3]
    files_to_create: []
    files_to_modify:
      - "README.md"
      - "AGENTS.md"
      - "CONTRIBUTING.md"
    acceptance_criteria: "No reference to a pre-move path remains in root *.md files."
    estimated_complexity: low
    notes: "grep -rn 'docs/' *.md to find every reference."

  - id: 5
    title: "Add link check"
    description: >
      Per ADR decision in Task 1: add a 'make docs-lint' target (lychee or
      markdown-link-check, offline mode for relative links) in a makefiles
      module. Optionally wire into .pre-commit-config.yaml if owner accepts
      the contributor dependency.
    depends_on: [4]
    files_to_create: []
    files_to_modify:
      - "makefiles/tools.mk (or new makefiles/docs.mk)"
      - ".pre-commit-config.yaml (only if owner opted in)"
    acceptance_criteria: "make docs-lint exits 0 on the reorganized tree and exits non-zero when a link is deliberately broken in a scratch test."
    estimated_complexity: medium
    notes: "Follow makefiles/ conventions: ## help text, $(call info,...), idempotent."

  - id: 6
    title: "Changelog entry and final verification"
    description: >
      Add CHANGELOG.md entry describing the docs reorganization. Run
      pre-commit run --all-files and make docs-lint as final verification.
    depends_on: [5]
    files_to_create: []
    files_to_modify:
      - "CHANGELOG.md"
    acceptance_criteria: "CI lint job green; link check green; changelog updated."
    estimated_complexity: low
    notes: "Conventional commit type: docs or chore."
```

## Handoff Checklist
- [x] All user stories have acceptance criteria
- [x] All architectural decisions have rationale documented in arch doc
- [ ] No open questions remain unresolved — **items 1, 3, 5 in Risks table need owner input (Task 1)**
- [x] Task list is dependency-ordered
- [x] files_to_create and files_to_modify are specified for every task
- [ ] Stack and constraints confirmed with user — **inferred from repo; see explicit assumptions**
