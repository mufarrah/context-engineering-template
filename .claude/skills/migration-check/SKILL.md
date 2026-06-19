---
name: migration-check
description: "Maintainer auto-check for the Cortex source repo. Invoke this PROACTIVELY and automatically WHENEVER files under templates/ have been added, edited, deleted, renamed, or restructured — and before committing template changes — to classify the change as ADDITIVE (handled by the runner's reconciliation) or MIGRATION-NEEDED (breaking/structural), and scaffold a migrations/NNN-*.md if one is required. Do not wait to be asked. For use INSIDE the template source repo only; it is never shipped to user projects."
---

# Migration Check (maintainer tool)

> **Repo-internal only.** This skill lives in the template **source** repo's `.claude/skills/` and
> is **not** shipped to user projects — the setup script copies only `templates/<kind>/`, never the
> repo-root `.claude/`. Run it after you change anything under `templates/` to decide whether the
> change needs a migration.

**What it answers:** *Does my pending change need a `migrations/NNN-*.md`, or will the runner's
reconciliation deliver it automatically?*

---

## The rule (from `migrations/README.md`)

- **ADDITIVE → NO migration.** New files, or updated *infrastructure* files users don't hand-edit
  (skills, `docs`/`shared/docs`, `templates`/`shared/templates`, PRP templates, KB `_TEMPLATES`).
  The runner installs new files (MISSING) and updates pristine copies automatically; users' edited
  copies are preserved/prompted. → This is why adding a skill like `checkpoint` needs no migration.
- **MIGRATION NEEDED → write `migrations/NNN-*.md`.** A change that **deletes, renames, or moves** a
  file, **restructures** the layout, or must **rewrite content inside files users customize**
  (USER-CONTENT) so the change reaches their already-edited copies.

---

## STEP 1 — Gather the change set

Inspect pending changes scoped to the shipped templates (rename-aware), plus untracked files:

```bash
# vs working tree (default): staged + unstaged changes under templates/
git diff --name-status --find-renames HEAD -- templates/
# untracked additions:
git status --porcelain --untracked-files=all -- templates/
```

If you're comparing against a baseline instead (e.g. the last release tag or `main`):

```bash
git diff --name-status --find-renames <base>..HEAD -- templates/
```

Also glance at `migrations/`, `tools/`, and root docs if your change touched them, but the verdict
is driven by what changed under `templates/` (that's what reaches user repos).

---

## STEP 2 — Classify each changed path

Apply this decision tree:

| Git status | Path kind | Verdict |
|------------|-----------|---------|
| `A` (added) | any | **ADDITIVE** — runner's MISSING pass installs it |
| `M` (modified) | infra (skill / docs / templates / PRP templates / KB `_TEMPLATES`) | **ADDITIVE** — reconciliation updates pristine copies; users' edited copies preserved/prompted |
| `M` (modified) | a **seed users customize** (CLAUDE/AGENTS/CONFIG/README scaffolds, per-project templates) **and the change must reach their edited copies** | **MIGRATION** (additive-guard: "if marker absent, insert section") |
| `D` (deleted) | a file downstream repos have | **MIGRATION** — safe removal with backup |
| `R` (renamed/moved) | any | **MIGRATION** — detect old, create new, remove old |
| layout / directory restructure | any | **MIGRATION** |

**Nuances to check explicitly:**
- A change to a source-repo-only file (not under `templates/`, e.g. this skill, `tools/`, repo docs) → **no migration** (it never reaches user repos).
- Renaming a skill's directory changes its `/command` trigger → **MIGRATION** (old skill removed, new added; users may have edited the old one → MODIFIED handling).
- A pure content improvement to a skill body → **ADDITIVE**, even though the file changed.
- A change that's breaking only **in combination** (e.g. you deleted a path another skill references) → **MIGRATION**, and note the coupling.
- If a single change set mixes both, the **migration verdict wins** — write the migration; the additive parts ride along via reconciliation.

---

## STEP 3 — Verdict + next action

### If ADDITIVE (no migration needed)
- State which files and why (each is "new file" or "infra update").
- Remind: bump `.template-version` (**MINOR**) in both templates so the version/ledger advances; the
  runner delivers the change via reconciliation. No migration file required.

### If MIGRATION NEEDED
Scaffold the next migration:

1. **Next id:** highest existing `migrations/NNN-*.md` number + 1, zero-padded (e.g. `003`).
2. **Create `migrations/NNN-<short-name>.md`** using the exact format from `migrations/README.md`
   (`id`, `applies-to`, `breaking`, **Guard**, **Steps**, **User-edit handling**, **Verify**,
   **Rollback**), pre-filled from the detected change (the deleted/renamed/restructured paths and
   the target end-state).
3. **Make the Guard an observable on-disk condition** so the migration is idempotent (running twice
   is a no-op). Example guards: "`old/path` exists", "`X` present but `Y` absent".
4. **Bake in safety:** anything deleted/overwritten backs up to `.cortex-backup/` first; MODIFIED and
   USER-CONTENT files require an explicit user choice; USER-ADDED files are never removed.
5. Remind: bump `.template-version` (**MAJOR** if breaking) in both templates, and update the docs
   that describe the changed structure.

---

## STEP 4 — Pre-finish sanity checks

- [ ] New migration's **Guard** is idempotent (second run = no-op)?
- [ ] It **preserves user edits** (MODIFIED → ask; USER-ADDED → never remove; USER-CONTENT → backup + confirm)?
- [ ] It **backs up** before any destructive step?
- [ ] `.template-version` bumped appropriately (**MAJOR** breaking / **MINOR** additive) in **both** templates?
- [ ] Reflected the change in `migrations/README.md` only if the *system itself* changed (not for ordinary migrations)?

---

## Scope & safety

- This skill only **inspects this repo's diff** and (optionally) **scaffolds** a `migrations/` file.
  It never touches user repos.
- **When unsure whether a change is breaking, default to MIGRATION NEEDED** and explain. A redundant
  migration is harmless (its guard just no-ops); a *missing* migration can lose user data.
