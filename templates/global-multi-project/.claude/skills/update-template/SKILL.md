---
name: update-template
description: "Safely upgrade this Cortex workspace to the latest template: detects on-disk state, reconciles infrastructure, and applies idempotent migrations — preserving your customizations and never overwriting your edits without asking."
disable-model-invocation: true
---

# Update Cortex (Migration Runner)

Safely bring this workspace up to date with the latest Cortex template — **without losing or
silently overwriting anything you changed.**

**Governing principle:** *The file system is the version.* We never rely on `.template-version`
(it was historically unreliable). We observe the files actually on disk and reconcile them to the
target, preserving anything you edited. This makes the run safe on any workspace, however old or
customized, and **idempotent** (re-running is safe).

There are two kinds of update and both are handled here:
- **Reconciliation** — new/updated template files (e.g. a newly added skill like `checkpoint`) are
  detected and offered. *No migration needed for additive changes.*
- **Migrations** — breaking, structural changes (delete/rename/restructure) run as idempotent,
  state-detecting steps from the template's `migrations/` directory.

---

## CONFIG

```
TEMPLATE_REPO = {TEMPLATE_REPO_URL}    # e.g. https://github.com/<you>/context-engineering-template
```

Set `TEMPLATE_REPO` to your template fork. If it's still a placeholder, ask the user for the URL
(or for a local `--source <path>` to a template checkout) before proceeding.

---

## PHASE 0 — Preflight (no changes)

1. **Confirm this is a Cortex workspace:** it has `context-engineering/` and a `.claude/` with
   `skills/` and/or `commands/`. If not, stop and report.
2. **Detect template kind:**
   - has `active-projects/` or `shared/` → `global-multi-project`
   - otherwise → `generic`
   Record as `KIND`. The corresponding source path is `templates/$KIND/`.
3. **Git safety net:** run `git status --porcelain`.
   - If the tree is **dirty**, STOP and ask the user to commit/stash first or explicitly say
     "proceed anyway". Strongly recommend committing — it's the cleanest rollback.
   - If it's **not a git repo**, warn that rollback relies on `.cortex-backup/` only.
   - Note: in this workspace template the **root** is often not git-tracked, but each project under
     `active-projects/` is its own repo. Check git status **per project** before touching that
     project's files, and back up regardless.
4. **Read the ledger** `.cortex/state.json` if present. If absent → first run → pure detection.

---

## PHASE 1 — Fetch the template source (read-only)

```bash
TMP="$(mktemp -d)"
git clone "$TEMPLATE_REPO" "$TMP"        # full clone — history required
SRC="$TMP/templates/$KIND"               # the matching template root
SRC_VERSION="$(cat "$SRC/.template-version")"
SRC_COMMIT="$(git -C "$TMP" rev-parse HEAD)"
```

If cloning fails, fall back to a user-provided local `--source <path>`, or stop and report.
**Never** invent file contents.

---

## PHASE 2 — Plan / dry-run (STILL no changes)

Map each repo file `P` to the template path `$SRC/P`.

### 2a. Classify infrastructure files

Infrastructure = template-owned files the user normally shouldn't hand-edit:
`.claude/skills/*/SKILL.md`, `shared/docs/*.md`, `shared/templates/*.md`,
`context-engineering/PRPs/templates/*.md`, `knowledge-base/_TEMPLATES/*.md`. Classify each:

```bash
hist() {  # every blob hash this path has had in template history
  local tpath="$1"
  git -C "$TMP" log --all --format=%H -- "$tpath" \
    | while read -r c; do git -C "$TMP" rev-parse "$c:$tpath" 2>/dev/null; done | sort -u
}
classify() {
  local repofile="$1" tpath="$2"
  [ -f "$repofile" ] || { echo MISSING; return; }
  local h; h="$(git hash-object "$repofile")"
  if hist "$tpath" | grep -qx "$h"; then echo PRISTINE; else echo MODIFIED; fi
}
```

- **PRISTINE** → safe to update (auto, but listed).
- **MODIFIED** → you edited it → prompt with a diff (keep mine / take new / merge / skip).
- **MISSING** → offer to **add** it. *(This is how newly-added skills such as `checkpoint` /
  `continue-prp` land in old workspaces — no migration required.)*
- **USER-ADDED** (path the template never had) → **leave untouched, never remove.**

### 2b. Evaluate migrations

Read `$TMP/migrations/*.md` in order. For each whose `id` is **not** in the ledger, evaluate its
**Guard** against this workspace. For migration `002`, that includes the **root** docs **and each**
`active-projects/<project>/` that still has `CLAUDE.md`/`PLANNING.md`, plus
`shared/templates/PLANNING-template.md`. List what will run.

### 2c. List USER-CONTENT (never auto-written)

Root `AGENTS.md`, `CLAUDE.md`, `CONFIG.md`, `README.md`; every `active-projects/<project>/AGENTS.md`
and `CLAUDE.md`; `src/` in each project; `knowledge-base/` topics; `context-engineering/` PRPs &
feature-inputs; `_STATUS.md`. Changed only by a structural migration, with backup + consent.

### 2d. Present the PLAN and get the go-ahead

Show: **Migrations to run** (root + which projects), **Infra to update** (pristine auto +
modified-needs-you), **New files to add**, **Untouched (your content & additions)**. Change nothing
until the user confirms. Offer "select per-item" vs "accept recommended".

---

## PHASE 3 — Backup (before the first change)

1. `TS="$(date +%Y%m%d-%H%M%S)"; mkdir -p ".cortex-backup/$TS"`
2. Copy **every** file the plan will modify or delete into `.cortex-backup/$TS/` preserving
   relative paths — including root `CLAUDE.md`/`PLANNING.md`, **every** per-project
   `active-projects/*/CLAUDE.md` and `PLANNING.md`, all of `.claude/commands/`,
   `shared/templates/PLANNING-template.md`, and every MODIFIED infra file.
3. Offer an opt-in git snapshot **per project** (and root if tracked):
   `git add -A && git commit -m "cortex: pre-migration snapshot"` — only with explicit consent.

---

## PHASE 4 — Apply (with per-item consent)

Order: **migrations first** (structural), then **infra reconciliation**, then **new files**.

1. **Run each planned migration** per its spec in `$TMP/migrations/NNN-*.md`. Each is idempotent
   and re-checks its guard. For `002`, process the **root** and **each** `active-projects/<project>/`
   independently. Honor user-edit handling exactly (MODIFIED & USER-CONTENT need explicit choice;
   back up before any delete/overwrite). The CLAUDE.md + PLANNING.md → AGENTS.md fold is an
   **intelligent merge you perform** with preview + confirmation — preserve all of the user's text;
   when unsure, keep more and ask.
2. **Reconcile infra:** PRISTINE → update; MODIFIED → diff + ask (default keep-mine); MISSING → ask
   to add (default yes) from `$SRC`; USER-ADDED → skip silently.
3. **USER-CONTENT** → never auto-write (only via a migration, with its own backup + confirmation).

---

## PHASE 5 — Record (ledger + version)

Write `.cortex/state.json`:

```json
{
  "templateVersion": "<SRC_VERSION>",
  "templateRepo": "<TEMPLATE_REPO>",
  "templateKind": "<KIND>",
  "syncedToCommit": "<SRC_COMMIT>",
  "appliedMigrations": ["...","<each migration applied or already satisfied>"],
  "lastRun": "<current ISO timestamp>"
}
```

Then set the workspace `.template-version` to `<SRC_VERSION>`.

---

## PHASE 6 — Report

- ✅ **Migrations applied** (root + per project) and any **skipped/pending**
- ✅ **Infra updated / added** (incl. newly installed skills like `checkpoint`)
- 🔒 **Preserved** — your edited files and your own additions
- 📋 **Needs your review** — skipped MODIFIED files, `PLANNING.md` references in your prose, anything ambiguous
- 💾 **Backup:** `.cortex-backup/$TS/` — and how to roll back

---

## SAFETY RULES (non-negotiable)

- **Plan before touching anything.** Phase 2 changes nothing; the user approves first.
- **Back up before every destructive step.** Never delete/overwrite unless a copy already exists in `.cortex-backup/$TS/`.
- **Never overwrite MODIFIED or USER-CONTENT files** without an explicit user choice. Default to keeping the user's version.
- **Never remove USER-ADDED files or skills.**
- **Never commit to git** on the user's behalf, except the opt-in Phase-3 snapshot they approve.
- **Idempotent & resumable** — re-running re-evaluates guards; already-done work is a no-op.
- **When anything is ambiguous, STOP and ask.**

---

## FALLBACK

- **Offline / clone fails:** accept `--source <path>` to a local template checkout; if it isn't a
  full clone, classify conservatively (treat as MODIFIED) and prompt on everything.
- **Not a git repo (root):** can't fingerprint history → treat infra files as potentially MODIFIED
  and prompt before changing; recommend `git init` per project for safer future runs.
