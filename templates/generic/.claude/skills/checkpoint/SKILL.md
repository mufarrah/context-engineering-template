---
name: checkpoint
description: "Capture a complete, durable checkpoint of the current PRP work so a fresh context window can resume with zero loss via /continue-prp."
argument-hint: "<prp-path>"
disable-model-invocation: true
---

# Checkpoint PRP State

## PRP Path: $ARGUMENTS

Capture a **complete, durable checkpoint** of the CURRENT work on this PRP so a brand-new
context window — one with NONE of this conversation — can resume with zero loss by running:

```
/continue-prp $ARGUMENTS
```

**You (the agent) have the full conversation context right now. That context is about to be
lost.** Your one job in this command: write everything that matters into the PRP's durable
tracking docs + the project status, so the next agent picks up exactly where we are — same
next action, same decisions, same gotchas — without re-deriving anything.

> If `$ARGUMENTS` is empty, infer the active PRP from this conversation (the PRP folder/file
> you've been working in) and use that path. State which path you chose.

---

## CORE PRINCIPLE

A checkpoint is a **handoff to a stranger.** After writing it, ask yourself: *"If I forgot this
entire conversation and only had these files, could I continue flawlessly?"* If not, the
checkpoint is incomplete — add what's missing. Be specific and concrete over tidy.

**Do NOT** end the work, write a final summary, or change git state. This is a pause, not a
completion. **Do NOT** paste secrets (tokens/DSNs/keys) — reference where they live
(`.env.local`, CI/host env) instead.

---

## STEP 1: DETECT PRP TYPE

Look at `$ARGUMENTS`:
- Ends in `.md` / is a single file → **Simple PRP** (built from `context-engineering/PRPs/templates/prp_base.md`) → go to STEP 3B.
- Is a directory → **Complex / Phased PRP** (built from `context-engineering/PRPs/templates/prp_complex.md`) → go to STEP 3A.

---

## STEP 2: ASSEMBLE THE CURRENT STATE (from THIS conversation — do this first, for both types)

Before touching any file, mentally gather the following. Pull from the live conversation, not
just what's already written down — the whole point is to durably capture what's only in your head:

1. **DONE & VERIFIED since the last checkpoint** — be specific and evidence-based. Which tasks/
   test cases passed, *how* they were verified (query, DB check, build, manual), and the concrete
   result (IDs, values, counts). Not "tested login" → "TC-2 PASS: record created with status=active,
   verified via SQL".
2. **THE NEXT ACTION (single most important field)** — the very next thing to do, written so a
   stranger could execute it verbatim: the exact command, file, UI step, or query, plus what result
   confirms success. If a fix was just applied and needs re-testing, say so and give the retest steps.
3. **FIXES applied but maybe not yet logged** — for each: symptom → root cause → solution → files
   changed → how to verify. (Goes into FIXES.md for complex; into the checkpoint section for simple.)
4. **DECISIONS the user made** — so they are never re-litigated (e.g. "user chose X over Y on
   <date>; intentional, not a bug"). Convert "today/yesterday" to absolute dates.
5. **ENVIRONMENT / GOTCHAS discovered** — IDs, account/project numbers, test users, tool quirks,
   where secrets live, commands that work/fail on this setup, etc. Anything you learned the hard way.
6. **VALIDATION STATUS** — typecheck/lint/build/test results, and any known-failing or skipped item.
7. **REMAINING WORK** — the ordered list of what's left after the NEXT ACTION, through close-out.

Keep a running todo (TodoWrite) if helpful, but remember: **the todo list does NOT survive the
window — only the files do.** Everything above must land in files.

---

## STEP 3A: CHECKPOINT A COMPLEX (FOLDER) PRP

### 3A.1 — Find the current phase
- Read `$ARGUMENTS/_STATUS.md` → current phase number/name + status.
- Locate the current phase folder (e.g. `$ARGUMENTS/phase-N-<slug>/`). Its `TEST-CASES.md`,
  `COMPLETED.md`, `FIXES.md` are where most of the checkpoint goes.

### 3A.2 — Update the phase docs (only what changed this session)
- **`COMPLETED.md`** — append any newly completed tasks/sub-work + the full set of files
  created/modified this session (so the eventual HANDOFF/diff misses nothing).
- **`FIXES.md`** — log every fix from STEP 2 #3 not already present (symptom → root cause →
  solution → files table → verification). Use the existing fix-numbering.
- **`TEST-CASES.md`** — update the Test Execution Tracker rows (pass/fail/in-progress + concrete
  notes), then **write/replace a `## 🔁 RESUME STATE` block at the end** containing:
  - a dated header (`— <absolute date>, checkpoint N`),
  - **passed this session** (with evidence),
  - **fixes applied & verified** (and which are awaiting retest),
  - **THE OPEN ITEM / NEXT ACTION** — front and center, self-contained,
  - **Remaining work** (ordered),
  - **How to verify** (current tooling/queries — fix any out-of-date notes),
  - **IDs / test accounts / env facts** to reuse, and **gotchas**,
  - the resume line: *Run `/continue-prp $ARGUMENTS`*.
  - **Preserve history:** if a prior RESUME STATE exists, demote it (keep a short "prior checkpoint"
    note) rather than silently deleting context.

### 3A.3 — Update the PRP `_STATUS.md`
- `Current Phase`, `Status` (keep it the in-progress phase — do NOT advance; a checkpoint is
  mid-phase), `Last Updated` (absolute date + "checkpoint N"), and the Quick Status list. Point the
  status text at the phase `TEST-CASES.md` → `🔁 RESUME STATE`.

### 3A.4 — Update the project status
- Edit `context-engineering/_STATUS.md`: refresh this feature's **In Progress** entry
  (Phase/Status/Last Updated + a one-paragraph current-state summary) and the **top-of-file
  "Last Updated"** line (prepend the new summary; demote the previous one to `**Prior:**`).

→ go to STEP 4.

---

## STEP 3B: CHECKPOINT A SIMPLE (FILE) PRP

A simple PRP is one `.md` file. The checkpoint lives **inside that file**.

### 3B.1 — Status header (top of the file)
Ensure a status header exists just under the title; create it if missing:
```markdown
**Status:** In Progress — checkpoint <N> (<absolute date>)
**Feature Input:** {keep existing if present}
**Last Updated:** <absolute date>
**Resume:** see "🔁 CHECKPOINT — RESUME STATE" at the bottom of this file, then `/continue-prp <this file path>`
```

### 3B.2 — Update the Test Execution Tracker (if the PRP has one)
Mark each row pass/fail/in-progress with concrete notes (same rigor as STEP 2 #1).

### 3B.3 — Write/replace the checkpoint section (at the END of the file)
Insert or replace a single section titled exactly `## 🔁 CHECKPOINT — RESUME STATE`, containing
everything from STEP 2:
```markdown
## 🔁 CHECKPOINT — RESUME STATE (<absolute date>, checkpoint <N>)

### Done & verified this session
- ...(specific, with evidence)...

### Fixes applied this session
- <symptom> → <root cause> → <solution> → files: `...`; verify by: ...

### Decisions (do not re-litigate)
- <user decision> (<date>) — intentional.

### NEXT ACTION (do this first)
- <the single, self-contained next step + the result that confirms success>

### Remaining work (ordered)
1. ...

### Environment / gotchas / IDs to reuse
- ...(tool quirks, account/test IDs, where secrets live, validation status: typecheck/lint/build/tests)...

### To continue
Run `/continue-prp <this file path>`.
```
**Preserve history:** if a prior checkpoint section exists, keep its essential not-yet-superseded
facts (demote to a short "prior checkpoint" note) — don't blow away still-relevant context.

### 3B.4 — Update the project status (if tracked)
If this simple PRP appears in `context-engineering/_STATUS.md` (In Progress or Pending), refresh
its line + the top "Last Updated". If it's not tracked there, skip (don't invent an entry unless
the work is clearly multi-session — then add a brief In-Progress entry).

→ go to STEP 4.

---

## STEP 4: VERIFY & REPORT

1. **Re-read what you wrote.** Confirm the NEXT ACTION is unambiguous and self-contained, no
   secrets were pasted, dates are absolute, and nothing important from STEP 2 is missing.
2. If any code was edited this session, make sure its validation status (typecheck/lint/build) is
   recorded — run the project's check if unsure and note the result. Do NOT start new work.
3. Tell the user exactly this (fill in the braces):
```
========================================
CHECKPOINT SAVED — {complex|simple} PRP
========================================
Path: $ARGUMENTS
Wrote/updated:
- {list the files you touched}

Next action captured: {one-line summary of the NEXT ACTION}

You can close this window now. To resume in a fresh window:
    /continue-prp $ARGUMENTS
========================================
```

---

## RULES
- **Never advance the phase / mark the PRP complete** — a checkpoint is a mid-work pause.
- **Never commit, push, or change git state.** Never run deployment/production commands.
- **Never paste secrets** — reference `.env.local` / host env instead.
- **Absolute dates**, not "today/yesterday".
- **Files are the only durable memory** — if it's only in the conversation, it must be written down.
- Match the existing doc style; edit in place; preserve prior checkpoint history rather than deleting it.
