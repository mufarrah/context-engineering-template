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
- Both templates have exactly 13 commands and 2 skills

### Template Differences

| Aspect | Generic | Global |
|--------|---------|--------|
| Target | Single project repo | Multi-project workspace |
| CLAUDE.md | Combined navigation + coding standards | Master navigation hub |
| PLANNING.md | Combined architecture + philosophy | Development philosophy only |
| Implementations KB | Flat (`implementations/*.md`) | Per-project (`implementations/{project}/*.md`) |
| Setup command | `/setup-project` | `/setup-workspace` |
| Docs location | `docs/` | `shared/docs/` |
| Project docs | Root CLAUDE.md and PLANNING.md | Per-project in `active-projects/{project}/` |

### When Editing Templates
- Changes to commands should be reflected in BOTH templates
- Generic commands reference root project; global commands reference `active-projects/{project}/`
- Keep `.template-version` in sync between templates
- Test that all cross-references between files are valid
