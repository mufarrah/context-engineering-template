# 001 — Commands → Skills

- **id:** 001-commands-to-skills
- **applies-to:** both
- **breaking:** yes (changes `.claude/` layout)

Converts the deprecated `.claude/commands/<name>.md` flat files into the Skills layout
`.claude/skills/<name>/SKILL.md`, then removes the old `commands/` directory — **without
losing any command the user edited or any skill the user added.**

---

## Guard (skip if false)

Run only if `.claude/commands/` exists and contains at least one `*.md` file.
If `.claude/commands/` is absent → this migration is already done → **no-op**.

---

## Steps

### 1. Classify every file in `.claude/commands/*.md`

For each old command file, compute its class (see `README.md` → "The modification check"):

- **PRISTINE** (hash matches some historical version of `templates/<kind>/.claude/commands/<name>.md`)
  → it's an unmodified official command. The repo already has — or will get — the official
  skill equivalent at `.claude/skills/<name>/SKILL.md`. **Action:** ensure the official skill is
  installed (the runner's "MISSING file" pass adds it), then mark the old command file for removal.

- **MODIFIED** (hash matches no historical version) → **the user edited this command.** Do NOT
  discard their work. Present a choice:
  1. **Convert my edited version to a skill** (default) — create `.claude/skills/<name>/SKILL.md`
     from the user's edited body, adding the frontmatter:
     ```yaml
     ---
     name: <name>
     description: "<one line — reuse the official description if names match, else summarize the body>"
     disable-model-invocation: true
     ---
     ```
     Then remove the old command file. Their edits are preserved verbatim in the new skill.
  2. **Take the official new skill instead** — install the official `<name>` skill; move their
     edited command to `.cortex-backup/<ts>/commands/<name>.md` so it's recoverable.
  3. **Keep both / show diff** — show their version vs the official skill body; let them merge by hand.
  4. **Skip** — leave the command file in place (no conversion); re-runnable later.

- **USER-ADDED** (a command whose name the template never shipped, e.g. one the user wrote)
  → **the user authored this command.** Convert it to a skill so it keeps working under the
  new model, preserving its body verbatim:
  `.claude/skills/<name>/SKILL.md` with `name`/`description`/`disable-model-invocation: true`
  frontmatter derived from the file. Back up the original to `.cortex-backup/<ts>/commands/`.
  Never silently drop it.

- **DEPRECATED** (PRISTINE or MODIFIED, but **no official skill of that name exists in template
  HEAD** — the template shipped this command once and later removed/renamed it, e.g. old
  `analyze-project` / `create-new-project`, or a generic-template command inside a global
  workspace) → the user may still rely on it. **Never silently delete.** Ask:
  1. **Convert to a skill anyway** (default) — keeps the command working; body preserved verbatim
     (their edits included, if MODIFIED).
  2. **Retire it** — move to `.cortex-backup/<ts>/commands/` and do not create a skill.
  3. **Skip** — leave in `commands/` for now (blocks removal of the directory).
  If the command was **renamed** in the template (an obvious successor skill exists, e.g.
  `setup-project` → `setup-workspace` in a global workspace), point that out and recommend
  retiring the old one in favor of the successor.

### 2. Add any official skills the repo is missing

This is handled by the runner's MISSING pass: every official `.claude/skills/<name>/SKILL.md`
not present in the repo is offered for install. (Existing skills the user already has — including
ones they added — are classified and handled per their own class; **USER-ADDED skills are never
touched**.)

### 3. Remove the old `commands/` directory — only after everything above

Once every file in `.claude/commands/` has been either converted (PRISTINE/MODIFIED-convert/
USER-ADDED) or backed up (MODIFIED-take-official), and the directory contains no file the user
chose to keep:

1. Confirm `.cortex-backup/<ts>/commands/` contains a copy of **every** original command file.
2. `rm -rf .claude/commands` (the whole dir).

If the user chose **Skip** for any file, leave `commands/` in place and report it as pending.

---

## User-edit handling (summary)

| Class | Outcome |
|-------|---------|
| PRISTINE command (official skill exists) | Official skill installed; old file removed (copy in backup). |
| MODIFIED command (official skill exists) | User chooses: convert-my-version (default) / take-official / merge / skip. Backup always taken. |
| DEPRECATED command (no skill in HEAD) | User chooses: convert-to-skill (default) / retire to backup / skip. Never silently deleted. |
| USER-ADDED command | Converted to a skill, body preserved; original backed up. |
| USER-ADDED skill (already under `skills/`) | **Untouched.** |

No command file is deleted unless a copy exists in `.cortex-backup/<ts>/`.

---

## Verify

- Every `/command` the user had still resolves (now as a skill).
- `.claude/skills/<name>/SKILL.md` exists for each converted command, with valid frontmatter
  (`name`, `description`, `disable-model-invocation: true`).
- `.claude/commands/` is gone **only if** no file was skipped.
- `.cortex-backup/<ts>/commands/` holds every original file.

---

## Rollback

Restore `.claude/commands/` from `.cortex-backup/<ts>/commands/` and delete the skills created by
this migration (listed in the run report). Because the user's commit was recommended before the
run, `git restore` / `git checkout` also fully reverts.
