---
name: update-template
description: "Safely upgrade this Cortex repo to the latest template: detects on-disk state, reconciles infrastructure, and applies idempotent migrations — preserving your customizations and never overwriting your edits without asking."
disable-model-invocation: true
---

# Update Cortex (Migration Runner)

Safely bring this repo up to date with the latest Cortex template — **without losing or silently
overwriting anything you changed.**

**Governing principle:** *The file system is the version.* We never rely on `.template-version`
(it was historically unreliable). We observe the files actually on disk and reconcile them to the
target, preserving anything you edited. This makes the run safe on any repo, however old or
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

1. **Confirm this is a Cortex repo:** it has `context-engineering/` and a `.claude/` with
   `skills/` and/or `commands/`. If not, stop and report.
2. **Detect template kind:**
   - has `active-projects/` or `shared/` → `global-multi-project`
   - otherwise → `generic`
   Record as `KIND`. The corresponding source path is `templates/$KIND/`.
3. **Git safety net:** run `git status --porcelain`.
   - If the tree is **dirty**, STOP and ask the user to either commit/stash first or explicitly
     say "proceed anyway". Strongly recommend committing — it's the cleanest rollback.
   - If it's **not a git repo**, warn that rollback will rely on `.cortex-backup/` only, and
     recommend `git init && git add -A && git commit` first.
4. **Read the ledger** `.cortex/state.json` if present (applied migrations, last synced commit).
   If absent → this is a first run → rely on pure detection (every guard re-evaluated).

---

## PHASE 1 — Fetch the template source (read-only)

Clone the template **with history** (needed for fingerprinting) into a temp dir:

```bash
TMP="$(mktemp -d)"
git clone "$TEMPLATE_REPO" "$TMP"        # full clone — history required
SRC="$TMP/templates/$KIND"               # the matching template root
SRC_VERSION="$(cat "$SRC/.template-version")"
SRC_COMMIT="$(git -C "$TMP" rev-parse HEAD)"
```

If cloning fails (offline, bad URL), fall back to a user-provided local `--source <path>` that
points at a template checkout, or stop and report. **Never** invent file contents.

---

## PHASE 2 — Plan / dry-run (STILL no changes)

Compute, but do not apply, the full plan. Map each repo file `P` to the template path `$SRC/P`.

### 2a. Classify infrastructure files

Infrastructure = template-owned files the user normally shouldn't hand-edit:
`.claude/skills/*/SKILL.md`, `docs/*.md`, `context-engineering/PRPs/templates/*.md`,
`knowledge-base/_TEMPLATES/*.md`. For each, classify (see `migrations/README.md`):

```bash
# Set of every blob hash this path has had in template history (handles old locations too):
hist() {
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

- **PRISTINE** → safe to update to latest (auto, but listed).
- **MODIFIED** → you edited it → will prompt with a diff (keep mine / take new / merge / skip).
- **MISSING** → template has it, repo doesn't → offer to **add** it. *(This is how newly-added
  skills such as `checkpoint` / `continue-prp` land in old repos — no migration required.)*
- **USER-ADDED** (a skill/file whose path the template never had — `hist` returns empty for it)
  → **leave untouched, never remove.**

### 2b. Evaluate migrations

Read `$TMP/migrations/*.md` in order. For each whose `id` is **not** already in the ledger,
evaluate its **Guard** against this repo. List the ones that will run (and what they'll do).
Migrations whose guard is false are already satisfied → skip.

### 2c. List USER-CONTENT (will never be auto-written)

`AGENTS.md`, `CLAUDE.md`, `CONFIG.md`, `README.md`, `src/`, `knowledge-base/` topic dirs,
`context-engineering/` PRPs & feature-inputs, `_STATUS.md`. These are only ever changed by a
structural migration, with backup + explicit consent.

### 2d. Present the PLAN and get the go-ahead

Show four lists: **Migrations to run**, **Infra to update** (pristine auto + modified-needs-you),
**New files to add**, **Untouched (your content & additions)**. Change nothing until the user
confirms. Offer "select per-item" vs "accept recommended".

---

## PHASE 3 — Backup (before the first change)

1. `TS="$(date +%Y%m%d-%H%M%S)"; mkdir -p ".cortex-backup/$TS"`
2. Copy **every** file the plan will modify or delete into `.cortex-backup/$TS/` preserving
   relative paths. (At minimum: all of `.claude/commands/`, `CLAUDE.md`, `PLANNING.md`, any
   per-project `CLAUDE.md`/`PLANNING.md`, and every MODIFIED infra file.)
3. Offer an opt-in git snapshot: `git add -A && git commit -m "cortex: pre-migration snapshot"`
   (only with explicit consent — never commit silently).

---

## PHASE 4 — Apply (with per-item consent)

Order: **migrations first** (structural), then **infra reconciliation**, then **new files**.

1. **Run each planned migration** following its spec in `$TMP/migrations/NNN-*.md`. Each is
   idempotent and re-checks its own guard. Honor its user-edit handling exactly (MODIFIED and
   USER-CONTENT files require an explicit choice; back up before any delete/overwrite). The
   content-folding in `002` (CLAUDE.md + PLANNING.md → AGENTS.md) is an **intelligent merge you
   perform** with a preview + confirmation — preserve all of the user's text; when unsure, keep
   more and ask.
2. **Reconcile infra:**
   - PRISTINE → overwrite with the latest version.
   - MODIFIED → show the diff; ask keep-mine / take-new / merge / skip. Default to **keep-mine**.
   - MISSING → ask to add (default yes); copy from `$SRC`.
   - USER-ADDED → skip silently (never touch).
3. **USER-CONTENT** → never auto-write. If a migration must transform it, that happens inside the
   migration with its own backup + confirmation.

---

## PHASE 5 — Record (ledger + version)

Write `.cortex/state.json`:

```json
{
  "templateVersion": "<SRC_VERSION>",
  "templateRepo": "<TEMPLATE_REPO>",
  "templateKind": "<KIND>",
  "syncedToCommit": "<SRC_COMMIT>",
  "appliedMigrations": ["...","<each migration whose guard ran or was already satisfied>"],
  "lastRun": "<current ISO timestamp>"
}
```

Then set the repo's `.template-version` to `<SRC_VERSION>`. (Now provenance is real, so the next
run is fast — but detection still backstops everything.)

---

## PHASE 6 — Report

Print:
- ✅ **Migrations applied** (and any **skipped/pending** because you chose "skip")
- ✅ **Infra updated / added** (incl. newly installed skills like `checkpoint`)
- 🔒 **Preserved** — your edited files and your own additions (list them)
- 📋 **Needs your review** — MODIFIED files you skipped, `PLANNING.md` references found in your
  prose, anything ambiguous
- 💾 **Backup:** `.cortex-backup/$TS/` — and how to roll back (restore from backup, or `git restore`
  if you took the snapshot)

---

## SAFETY RULES (non-negotiable)

- **Plan before touching anything.** Phase 2 changes nothing; the user approves first.
- **Back up before every destructive step.** Never delete/overwrite unless a copy already exists in `.cortex-backup/$TS/`.
- **Never overwrite MODIFIED or USER-CONTENT files** without an explicit user choice. Default to keeping the user's version.
- **Never remove USER-ADDED files or skills.**
- **Never commit to git** on the user's behalf, except the opt-in Phase-3 snapshot they explicitly approve.
- **Idempotent & resumable** — re-running re-evaluates guards; already-done work is a no-op.
- **When anything is ambiguous, STOP and ask.** Losing user work is far worse than pausing.

---

## FALLBACK

- **Offline / clone fails:** accept `--source <path>` to a local template checkout and run the same
  phases against it (history-based classification still works if it's a full clone; otherwise
  classify MODIFIED conservatively and prompt on everything).
- **Not a git repo:** classification can't fingerprint history → treat every infra file as
  potentially MODIFIED and prompt before changing it; recommend `git init` for safer future runs.
