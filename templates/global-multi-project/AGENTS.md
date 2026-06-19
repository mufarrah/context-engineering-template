# Cortex Workspace — AI Agent Navigation Hub

**Purpose:** This is the **master navigation guide** for AI agents working in this workspace. It explains the repository structure, development workflow, and how to find project-specific documentation.

> Claude Code loads this file automatically through `CLAUDE.md` (which imports it). Other agent tools (Cursor, Codex, etc.) read `AGENTS.md` directly. **Edit this file, not `CLAUDE.md`.**

---

## Quick Start for AI Agents

### When Starting a New Task:

1. **Read this file** to understand the workspace structure and workflow
2. **Check [`knowledge-base/INDEX.md`](knowledge-base/INDEX.md)** for relevant domain knowledge about past decisions and gotchas
3. **Navigate to project-specific docs** for the project you're working on — read `active-projects/{project}/AGENTS.md` (see [Project Navigation](#project-navigation))
4. **Follow the feature development workflow** (see [Feature Development Workflow](#feature-development-workflow))

### Critical Rule:

**NEVER assume you know the codebase**. Always read the project-specific `active-projects/{project}/AGENTS.md` before making changes.

---

## Repository Structure

```
{workspace-name}/                       # Root workspace (NOT git-tracked)
├── AGENTS.md                           # This file — master navigation hub (source of truth)
├── CLAUDE.md                           # Thin Claude Code entry point (imports AGENTS.md)
├── CONFIG.md                           # Available commands reference
├── README.md                           # Workspace quick start guide
│
├── context-engineering/                # Feature management system
│   ├── _STATUS.md                      # Current workspace status (lightweight tracker)
│   │
│   ├── feature-inputs/                 # Feature requirement documents
│   │   ├── pending/                    # Features awaiting PRP generation
│   │   └── in-progress/               # Features currently being implemented
│   │
│   ├── PRPs/                           # Project Requirement Plans (implementation plans)
│   │   ├── templates/                  # PRP templates
│   │   ├── {feature-name}.md           # Simple PRPs (single file)
│   │   └── {FEATURE-NAME}/            # Complex PRPs (folder with phases)
│   │
│   └── archive/                        # Completed/deprecated documents
│       ├── feature-inputs/             # Completed feature requirements
│       └── deprecated-docs/            # Old documentation versions
│
├── active-projects/                    # Current development projects (each has own git repo)
│   └── {project-name}/
│       ├── AGENTS.md                   # Project-specific coding standards + architecture
│       └── CLAUDE.md                   # Thin entry point (imports the project AGENTS.md)
│
├── experiments/                        # Prototypes and proof-of-concepts
│
├── knowledge-base/                     # Concept-centric knowledge base
│   ├── INDEX.md                        # Auto-generated TOC (agents read FIRST)
│   ├── _TEMPLATES/                     # Topic file templates
│   ├── concepts/                       # WHAT things are (definitions, schema, rules)
│   ├── flows/                          # HOW things work (processes, sequences)
│   ├── implementations/                # WHERE code lives (project-specific patterns)
│   │   └── {project-name}/             # Per-project implementation docs
│   ├── gotchas/                        # WARNINGS (pitfalls, edge cases)
│   └── decisions/                      # WHY we chose (Architecture Decision Records)
│
├── archive/                            # Completed or paused projects
│
├── shared/                             # Shared resources across projects
│   ├── docs/                           # Documentation guides
│   │   ├── commands-and-skills.md      # Commands & skills reference
│   │   ├── knowledge-base.md           # Knowledge base guide
│   │   └── prp-workflow.md             # PRP workflow guide
│   ├── scripts/                        # Utility scripts
│   ├── templates/                      # Project templates
│   │   ├── AGENTS-template.md          # Per-project AGENTS.md template
│   │   └── CLAUDE-template.md          # Per-project CLAUDE.md template (thin importer)
│   └── assets/                         # Shared assets
│
├── .claude/                            # Workspace-level Claude skills (slash commands + domain skills)
│   └── skills/                         # Each skill is a folder with SKILL.md
│       ├── {command}/                  # Slash-command skills (/generate-prp, etc.)
│       └── ...                         # Domain skills (skill-creator, frontend-design)
│
└── tools/                              # Development tools and configurations
    └── configs/                        # Per-project config files
```

---

## Feature Development Workflow

### Overview

We use a **PRP-based (Project Requirement Plan)** development system. Features go through these stages:

```
Feature Idea → Requirements Doc → PRP Generation → Implementation → Archive
```

### Detailed Workflow

#### 1. Feature Initiation

**Option A: Start from template**
```bash
# Copy template
cp context-engineering/PRPs/templates/feature_input_template.md context-engineering/feature-inputs/pending/my-feature.md

# Edit the file with your requirements
# Then use /generate-requirements command
/generate-requirements context-engineering/feature-inputs/pending/my-feature.md
```

**Option B: Write requirements manually**
```bash
# Create requirements document directly in pending/
# Then generate PRP
/generate-prp context-engineering/feature-inputs/pending/my-feature.md
```

#### 2. PRP Generation

The `/generate-prp` command will:
- Read your requirements document
- Research the codebase for patterns
- Create implementation-ready PRP in `context-engineering/PRPs/`
- **Move** your requirements from `pending/` → `in-progress/`

**Output:**
- **Simple features**: Single file `context-engineering/PRPs/feature-name.md`
- **Complex features**: Folder `context-engineering/PRPs/FEATURE-NAME/` with phases

#### 3. Implementation

```bash
# Execute the PRP (starts with Phase 0 for complex PRPs)
/execute-prp context-engineering/PRPs/FEATURE-NAME

# For complex multi-phase PRPs, continue to next phase
/continue-prp context-engineering/PRPs/FEATURE-NAME

# Verify all documentation is updated
/ensure-tracking context-engineering/PRPs/FEATURE-NAME
```

#### 4. Completion

After implementation is complete and tested:

```bash
# Update knowledge base with learnings
/update-knowledge-base context-engineering/PRPs/FEATURE-NAME

# Move requirements document to archive
mv context-engineering/feature-inputs/in-progress/my-feature.md context-engineering/archive/feature-inputs/

# PRP stays in context-engineering/PRPs/ for historical reference
```

Update the project's `active-projects/{project}/AGENTS.md` **only** for durable, every-session facts (see [Documentation Maintenance](#documentation-maintenance)). Route fix logs, decisions, and learnings to the knowledge base instead.

---

## Project Navigation

### Active Projects

<!-- Fill this table after running /setup-workspace -->

| Project | Tech Stack | Docs Location | Purpose |
|---------|------------|---------------|---------|
| *Run `/setup-workspace` to populate this table* | | | |

### Experiments

| Project | Tech Stack | Purpose |
|---------|------------|---------|
| *Add experiments as you create them* | | |

---

## Git Workflow

### Repository Structure

- **Root directory**: NOT git-tracked (this is a workspace container)
- **Individual projects**: Each has its own git repository in `active-projects/`

### Git Safety Rules

**NEVER:**
- Update git config without explicit user permission
- Run destructive git commands (`push --force`, `reset --hard`, `clean -f`) unless explicitly requested
- Skip hooks (`--no-verify`, `--no-gpg-sign`)
- Force push to main/master branches
- **Commit code to GitHub** unless the user explicitly requests it

**ALWAYS:**
- Create NEW commits rather than amending (unless user explicitly requests amend)
- Stage specific files by name (avoid `git add -A` or `git add .`)

---

## Documentation Maintenance

A project's `AGENTS.md` is loaded into **every** agent session for that project, so it must stay high-signal. Most of what you learn during a feature does **not** belong there — it has a better home.

### What belongs in a project's AGENTS.md (update ONLY for these)

Edit `active-projects/{project}/AGENTS.md` only when a change alters a **durable, every-session fact**:

- Project structure / file organization
- Tech stack, or a build / test / lint / dev command
- A new coding convention or an "always do X / never do Y" rule
- A high-level architecture or data-flow change
- A cross-cutting gotcha that applies project-wide

Litmus test before editing: **"Would a fresh agent need this in *every* session for this project, regardless of the task?"** If no, it does not go there.

### What must NEVER go in AGENTS.md

- ❌ Fix logs, bug-fix notes, or "what changed in this phase" entries
- ❌ Changelogs or release notes
- ❌ Per-feature narratives or implementation walkthroughs
- ❌ Transient status (current phase, TODOs, in-progress notes)

### Where that content goes instead

| Content | Correct home |
|---------|--------------|
| Fix logs, phase outcomes, what changed | The PRP's own `FIXES.md` / `COMPLETED.md` |
| A pitfall worth remembering | `knowledge-base/gotchas/` |
| Why an approach was chosen (ADR) | `knowledge-base/decisions/` |
| How a process/flow works in detail | `knowledge-base/flows/` |
| Where a pattern lives in code | `knowledge-base/implementations/{project}/` |
| Current status / progress | `context-engineering/_STATUS.md` |

`/update-knowledge-base` routes learnings to the knowledge base automatically. It should touch a project's AGENTS.md **only** for the durable facts listed above.

### Where PRPs Live

**PRPs are historical records** and stay in `context-engineering/PRPs/` permanently. They document what was built, why decisions were made, what patterns were followed, and what problems were solved. Refer to PRPs when implementing similar features in the future.

---

## Common Commands

### Workspace Management

```bash
# Create new feature from template
cp context-engineering/PRPs/templates/feature_input_template.md context-engineering/feature-inputs/pending/feature-name.md

# Generate requirements document
/generate-requirements context-engineering/feature-inputs/pending/feature-name.md

# Generate PRP from requirements
/generate-prp context-engineering/feature-inputs/pending/feature-name.md

# Execute PRP
/execute-prp context-engineering/PRPs/FEATURE-NAME

# Continue phased PRP
/continue-prp context-engineering/PRPs/FEATURE-NAME

# Verify documentation
/ensure-tracking context-engineering/PRPs/FEATURE-NAME
```

### Knowledge Base Management

```bash
# Extract knowledge from a completed PRP into the knowledge base
/update-knowledge-base context-engineering/PRPs/FEATURE-NAME

# Populate knowledge base from all projects (initial setup)
/populate-knowledge-base

# Regenerate INDEX.md and all _SUMMARY.md files
/rebuild-kb-index
```

### Workspace Setup & Updates

```bash
# Initial workspace setup (run after copying template)
/setup-workspace

# Pull latest template updates without overwriting your content
/update-template

# Comprehensive workspace health check
/audit-context
```

---

## Finding Information

### "Where do I find...?"

| What You Need | Where to Look |
|---------------|---------------|
| Overall repository structure & workflow | This file (AGENTS.md) |
| **Current workspace status** | [`context-engineering/_STATUS.md`](context-engineering/_STATUS.md) |
| Project-specific coding rules & architecture | `active-projects/{project}/AGENTS.md` |
| Historical feature implementations | `context-engineering/PRPs/` |
| Completed feature requirements | `context-engineering/archive/feature-inputs/` |
| Pending features | `context-engineering/feature-inputs/pending/` |
| Active feature work | `context-engineering/feature-inputs/in-progress/` |
| **Knowledge about past decisions** | [`knowledge-base/INDEX.md`](knowledge-base/INDEX.md) → section `_SUMMARY.md` → topic files |
| Commands & skills reference | [`shared/docs/commands-and-skills.md`](shared/docs/commands-and-skills.md) |
| Knowledge base guide | [`shared/docs/knowledge-base.md`](shared/docs/knowledge-base.md) |
| PRP workflow guide | [`shared/docs/prp-workflow.md`](shared/docs/prp-workflow.md) |

### "How do I...?"

| Task | Answer |
|------|--------|
| Start a new feature | Follow [Feature Development Workflow](#feature-development-workflow) above |
| Set up the workspace for the first time | Run `/setup-workspace` |
| Understand a specific project | Read `active-projects/{project}/AGENTS.md` |
| Find similar implementations | Check `knowledge-base/` sections first, then `context-engineering/PRPs/` for details |
| Learn coding conventions | Read the project-specific `AGENTS.md` |
| Understand architecture | Read the project-specific `AGENTS.md`, then `knowledge-base/` |
| Pull template updates | Run `/update-template` |

---

## Important Reminders

1. **Read project-specific docs first** — Each project's `AGENTS.md` has unique patterns and conventions
2. **Follow the PRP workflow** — Don't skip steps or create undocumented features
3. **Keep AGENTS.md high-signal** — Only durable, every-session facts; route learnings to the knowledge base (see [Documentation Maintenance](#documentation-maintenance))
4. **Archive completed features** — Move requirements from `in-progress/` to `archive/feature-inputs/`
5. **Update the knowledge base** — Run `/update-knowledge-base` after completing PRPs

---

## Template Locations

| Template | Location |
|----------|----------|
| Feature input template | `context-engineering/PRPs/templates/feature_input_template.md` |
| Simple PRP template | `context-engineering/PRPs/templates/prp_base.md` |
| Complex PRP template | `context-engineering/PRPs/templates/prp_complex.md` |
| Test cases template | `context-engineering/PRPs/templates/test_cases_template.md` |
| Project AGENTS.md template | `shared/templates/AGENTS-template.md` |
| Project CLAUDE.md template | `shared/templates/CLAUDE-template.md` |
