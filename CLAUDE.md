# Cortex Template Repository

This is the **source repository** for Cortex templates. It contains two templates that users copy into their projects.

## Repository Structure

```
context-engineering-template/
├── README.md                          # User-facing documentation
├── CLAUDE.md                          # This file (repo-level AI context)
├── LICENSE                            # MIT license
├── setup-context-engineering.sh       # Setup script (copies templates)
└── templates/
    ├── generic/                       # Single-project template
    └── global-multi-project/          # Multi-project workspace template
```

## Rules for AI Agents Working on This Repo

### Never Modify User Projects
- This repo contains TEMPLATES, not active projects
- Never commit changes to any user's project directory
- The `nolan/` directory (if present at the parent level) is READ-ONLY reference material

### Template Conventions
- All templates use `{placeholder}` syntax for user-customizable values
- Commands reference `context-engineering/` paths (not root paths)
- Generic template uses `docs/` for documentation
- Global template uses `shared/docs/` for documentation
- Both templates expose 14 slash commands plus 2 built-in domain skills (`skill-creator`, `frontend-design`), all defined under `.claude/skills/<name>/SKILL.md`
- Slash commands are skills: each lives at `.claude/skills/<command>/SKILL.md` with `name`, `description`, and `disable-model-invocation: true` frontmatter. The directory name is the `/command` trigger; the body keeps `$ARGUMENTS` and other command syntax

### Template Differences

| Aspect | Generic | Global |
|--------|---------|--------|
| Target | Single project repo | Multi-project workspace |
| AGENTS.md | Combined navigation + architecture + coding standards | Workspace navigation hub |
| CLAUDE.md | Thin importer (`@AGENTS.md`) | Thin importer (`@AGENTS.md`) |
| Implementations KB | Flat (`implementations/*.md`) | Per-project (`implementations/{project}/*.md`) |
| Setup command | `/setup-project` | `/setup-workspace` |
| Docs location | `docs/` | `shared/docs/` |
| Project docs | Root `AGENTS.md` (+ thin `CLAUDE.md`) | Per-project `AGENTS.md` (+ thin `CLAUDE.md`) in `active-projects/{project}/` |

### When Editing Templates
- Changes to commands should be reflected in BOTH templates
- Generic commands reference root project; global commands reference `active-projects/{project}/`
- Keep `.template-version` in sync between templates
- Test that all cross-references between files are valid

### Versioning & Migrations (how downstream repos stay updatable)

Downstream repos are upgraded by the `update-template` **migration runner** (in each template's
`.claude/skills/`). It does NOT trust `.template-version` — it reconciles **observed on-disk state**
to the latest template and applies idempotent migrations, preserving user customizations. See
[`migrations/README.md`](migrations/README.md).

- **Bump `.template-version` in BOTH templates on every user-facing change** — MAJOR for breaking
  (structural) changes, MINOR for additive ones. (The runner uses content fingerprinting, not the
  number, but the version is the human-facing signal and is recorded in the repo's ledger.)
- **Additive change** (new file, or an updated skill/doc/template users don't hand-edit) → **no
  migration**. The runner's reconciliation installs/updates it automatically.
- **Structural change** (delete / rename / move / layout change, or rewriting content inside files
  users customize) → **add `migrations/NNN-<name>.md`** (idempotent guard + backup + consent;
  follow the format in `migrations/README.md`).
- **`/migration-check`** (maintainer skill at `.claude/skills/migration-check/`, repo-only, **auto-
  invoked**) classifies your pending `templates/` changes and scaffolds a migration when needed. A
  **Stop hook** (`.claude/hooks/migration-watch.sh`, wired in `.claude/settings.json`) also warns
  if `templates/` has structural changes with no migration staged.
- **First-hop upgrade** of an old repo uses the bootstrap (`tools/cortex-update.sh` / `.ps1`), which
  installs the latest runner into that repo so you can then run `/update-template` there.
- Repo-root `.claude/` (this maintainer tooling) is **never shipped** — setup copies only `templates/<kind>/`.
