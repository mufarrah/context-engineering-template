# 002 — PLANNING.md + CLAUDE.md → AGENTS.md

- **id:** 002-planning-to-agents
- **applies-to:** both
- **breaking:** yes (removes `PLANNING.md`; repurposes `CLAUDE.md`)

Adopts the AGENTS.md model: `AGENTS.md` becomes the single source of truth (the file other
agent tools also read), `CLAUDE.md` becomes a thin `@AGENTS.md` importer, and `PLANNING.md` is
folded in and removed. The user's customized content is **preserved by construction** — we build
`AGENTS.md` from *their* files, never from the bare template.

> **Paths by template kind:**
> - **generic:** root `CLAUDE.md` + root `PLANNING.md` → root `AGENTS.md`.
> - **global-multi-project:** root hub `CLAUDE.md` + `PLANNING.md` → root `AGENTS.md`; and for
>   **each** `active-projects/<project>/` that has `CLAUDE.md`/`PLANNING.md`, fold into
>   `active-projects/<project>/AGENTS.md`. Also migrate `shared/templates/` (see step 4).

---

## Guard (skip if false)

Run if **any** of these is true (otherwise the model is already adopted → no-op):
- a `PLANNING.md` exists (root, or any `active-projects/*/PLANNING.md`, or `shared/templates/PLANNING-template.md`), **or**
- a `CLAUDE.md` exists whose content is **not** already the thin importer (i.e. it isn't exactly `@AGENTS.md` plus header), **or**
- an expected `AGENTS.md` is missing while a `CLAUDE.md` with real content is present.

---

## Steps (per location — root, and each project for global)

### 1. Back up first

Copy the location's `CLAUDE.md` and `PLANNING.md` (if present) to
`.cortex-backup/<ts>/<location>/`. Do this before reading/writing anything.

### 2. Decide the source of `AGENTS.md` content (preserve user work)

Classify `CLAUDE.md` and `PLANNING.md` (PRISTINE vs MODIFIED — see `README.md`):

- **If both are PRISTINE** (untiched template files): create `AGENTS.md` from the **official new
  AGENTS.md template** for this kind. Nothing of the user's is lost (they'd customized nothing).

- **If either is MODIFIED** (the common case — the user filled these in): **their content wins.**
  Build `AGENTS.md` by **intelligently merging their `CLAUDE.md` + `PLANNING.md`** into the new
  AGENTS.md structure:
  - Map their CLAUDE.md sections (tech stack, commands, file organization, conventions, patterns,
    git rules) into the AGENTS.md "Coding Standards" sections.
  - Map their PLANNING.md sections (architecture, data model, flows, decisions) into the AGENTS.md
    "Architecture" section. Decisions/ADRs may instead be pointed to `knowledge-base/decisions/`.
  - **Preserve every non-placeholder thing the user wrote.** Do not drop their text. If something
    has no obvious home, keep it under a clearly-labeled "## Additional Notes (migrated)" section
    rather than discarding it.
  - Present the proposed `AGENTS.md` as a diff/preview and ask for confirmation before writing.
    Offer "edit before applying" / "keep my CLAUDE.md as-is and only add the importer" as escapes.

> This merge requires judgment, so the runner performs it (an LLM step), not a blind script.
> When uncertain, it errs toward **keeping more of the user's text** and asking.

### 3. Replace `CLAUDE.md` with the thin importer

After `AGENTS.md` is written and confirmed, replace `CLAUDE.md` with:

```markdown
# <PROJECT_NAME> — Claude Code Entry Point

Claude Code loads this file automatically. The full instructions live in
**[`AGENTS.md`](AGENTS.md)** (shared with other agent tools) and are imported below.

**Edit [`AGENTS.md`](AGENTS.md), not this file.**

@AGENTS.md
```

If `CLAUDE.md` was MODIFIED, its original is already in the backup (step 1) and its content has
already been folded into `AGENTS.md` (step 2) — so no user text is lost.

### 4. Remove `PLANNING.md` (after fold + backup)

Delete `PLANNING.md` only once its content is in `AGENTS.md` and a copy is in `.cortex-backup/`.

For **global-multi-project** also migrate the per-project templates:
- `shared/templates/PLANNING-template.md` → fold into `shared/templates/AGENTS-template.md`
  (install the official one if absent), then remove the PLANNING template.
- `shared/templates/CLAUDE-template.md` → replace with the thin-importer template.

### 5. Rewrite lingering `PLANNING.md` references

Scan the repo's **template-owned** docs for `PLANNING.md` references and update them to
`AGENTS.md`. **Do not** rewrite references inside USER-CONTENT or USER-ADDED files automatically —
instead, list them in the report so the user can decide (their prose may intentionally mention it).

---

## User-edit handling (summary)

| File | Outcome |
|------|---------|
| MODIFIED `CLAUDE.md` / `PLANNING.md` | Content folded into `AGENTS.md` (preview + confirm); originals backed up; nothing dropped. |
| PRISTINE `CLAUDE.md` / `PLANNING.md` | Replaced with the new model from the official template. |
| Existing `AGENTS.md` the user already wrote | **USER-CONTENT → never overwritten.** Only offer to add missing sections, with consent. |
| `PLANNING.md` references in user prose | Reported, not auto-edited. |

---

## Verify

- `AGENTS.md` exists at each location and contains the user's preserved content.
- `CLAUDE.md` is the thin importer (`@AGENTS.md`) at each location.
- No `PLANNING.md` remains (root, per-project, or template) — and a copy of each removed file is in `.cortex-backup/<ts>/`.
- Claude Code still loads the real instructions (via `CLAUDE.md` → `@AGENTS.md`).

---

## Rollback

Restore `CLAUDE.md` and `PLANNING.md` from `.cortex-backup/<ts>/<location>/` and delete the
generated `AGENTS.md`. A pre-run git commit (recommended by the runner) reverts everything with
`git restore`.
