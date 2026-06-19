# Cortex Migration System

This directory powers **safe, repeatable upgrades** of downstream Cortex repos — even repos
that were copied long ago, were never version-stamped, and have been heavily customized.

It is built on one principle:

> **The file system is the version.** We never need to know which template version or which
> commits a repo started from. We observe the files that are actually on disk and reconcile
> them to the desired state — preserving anything the user changed.

---

## Why this exists

`.template-version` was unreliable (it sat at `1.0.0` across many template generations), and
most repos never cut GitHub Releases. So "diff version A → B" is impossible. Instead, the
runner uses **content fingerprinting against the template's full git history** plus a set of
**idempotent, state-detecting migrations**. Nothing depends on a trustworthy version number.

---

## The five file classes

When the runner inspects a downstream repo, it sorts every relevant file into one of these.
Classification is **computed**, never assumed from a version stamp.

| Class | How it's detected | What the runner may do |
|-------|-------------------|------------------------|
| **PRISTINE** | The file's hash (`git hash-object`) matches **some historical blob hash** of that path in the template source. It's an unmodified template file — possibly an old one. | Safe to update/transform automatically. |
| **MODIFIED** | The file exists but its hash matches **no** historical version of that path. → The user edited it. | **Never auto-overwrite.** Show a diff and ask: keep mine / take new / merge / skip. |
| **USER-ADDED** | A file/skill/command whose path the template has **never** owned (e.g. a skill the user wrote). | **Never touched, never removed.** Left exactly as-is. |
| **MISSING** | The template has the file; the repo doesn't. | Offer to add it (new feature/skill). |
| **USER-CONTENT** | Declared user-owned: `AGENTS.md`, `CLAUDE.md`, `CONFIG.md`, `README.md`, `src/`, `knowledge-base/` topics, `context-engineering/` PRPs & feature-inputs, `_STATUS.md`. | **Never auto-written.** Only a structural migration may transform it, and only after a backup + explicit confirmation. |

**The modification check (no provenance needed):**

```bash
# Build the set of every blob this path has ever had in the template source:
for c in $(git -C "$TMPL" log --all --pretty=%H -- "$path"); do
  git -C "$TMPL" rev-parse "$c:$path" 2>/dev/null
done | sort -u > /tmp/known_hashes

# Hash the user's current file the same way git would:
user_hash=$(git hash-object "$REPO/$path")

grep -qx "$user_hash" /tmp/known_hashes && echo PRISTINE || echo MODIFIED
```

A user's **unmodified** old command matches a historical hash → PRISTINE → migrated silently.
A user's **edited** command matches nothing → MODIFIED → the user decides. This is how we
preserve "I even edited some of the commands" without ever knowing their version.

---

## The runner's phases (see the `update-template` skill)

0. **Preflight** — confirm it's a Cortex repo; require a clean git tree (or explicit override); read/create the ledger.
1. **Fetch** — `git clone` the template **source** (with history) to a temp dir.
2. **Plan (dry-run)** — classify every file, evaluate each migration's guard, list new files. **Change nothing yet.** Present the full plan.
3. **Backup** — copy everything that will be touched into `.cortex-backup/<timestamp>/`, and recommend a git commit.
4. **Apply** — with per-item consent: PRISTINE infra auto-updates; MODIFIED infra prompts; migrations run idempotently; new files are offered; USER-CONTENT is never auto-written.
5. **Record** — write the ledger and set `.template-version`.
6. **Report** — what changed, what was preserved, what needs your manual review, and where the backup is.

---

## The ledger: `.cortex/state.json`

After the first reconciliation, every repo gains real provenance, so future runs are fast and
precise (apply only newer migrations) — with detection always as the idempotent backstop.

```json
{
  "templateVersion": "2.0.0",
  "templateRepo": "https://github.com/<you>/context-engineering-template",
  "syncedToCommit": "<sha the repo was last reconciled against>",
  "appliedMigrations": ["001-commands-to-skills", "002-planning-to-agents"],
  "lastRun": "<ISO timestamp>",
  "templateKind": "generic | global-multi-project"
}
```

If the ledger is missing or tampered with, the runner falls back to **pure detection** (every
migration's guard is re-evaluated against disk), so a lost ledger never causes harm or
double-application.

---

## Authoring a new migration (this is the "easy path forever")

When you change the template in a way existing repos need, add **one file** here:
`NNN-short-name.md`, numbered in order. The runner applies every migration whose guard matches
and whose id isn't already in the ledger. Each migration MUST be:

- **Idempotent** — running it twice is a no-op the second time. Always re-check the guard.
- **State-detecting** — its precondition is an observable fact on disk, not a version number.
- **Non-destructive without backup** — anything deleted/overwritten is copied to `.cortex-backup/` first.
- **Consent-respecting** — MODIFIED and USER-CONTENT files are never changed without an explicit user choice.
- **Reversible** — document exactly how to undo it (usually: restore from `.cortex-backup/`).

### Migration file format

```markdown
# NNN — <title>

- **id:** NNN-short-name
- **applies-to:** generic | global-multi-project | both
- **breaking:** yes | no

## Guard (skip if false)
<an observable on-disk condition; if false, this migration is already done — no-op>

## Steps
<ordered, idempotent steps; classify files first; back up before destructive ops>

## User-edit handling
<what to do for MODIFIED / USER-ADDED / USER-CONTENT files this touches>

## Verify
<post-conditions to confirm success>

## Rollback
<how to undo — e.g. restore from .cortex-backup/<ts>/>
```

Then friends just re-run the one command; only the new migration fires.
```
