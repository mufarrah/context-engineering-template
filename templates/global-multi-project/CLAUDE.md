# Cortex Workspace - AI Agent Navigation Hub

**Purpose:** This document is the **master navigation guide** for AI agents working in this workspace. It explains the repository structure, development workflow, and how to find project-specific documentation.

---

## Quick Start for AI Agents

### When Starting a New Task:

1. **Read this file** to understand the workspace structure
2. **Read [`PLANNING.md`](PLANNING.md)** for development philosophy and project overview
3. **Check [`knowledge-base/INDEX.md`](knowledge-base/INDEX.md)** for relevant domain knowledge about past decisions and gotchas
4. **Navigate to project-specific docs** for the project you're working on (see [Project Navigation](#project-navigation) below)
5. **Follow the feature development workflow** (see [Feature Development Workflow](#feature-development-workflow))

### Critical Rule:

**NEVER assume you know the codebase**. Always read project-specific `CLAUDE.md` and `PLANNING.md` before making changes.

---

## Repository Structure

```
{workspace-name}/                       # Root workspace (NOT git-tracked)
├── CLAUDE.md                           # This file - Master navigation hub
├── PLANNING.md                         # Development philosophy and project overview
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
│       ├── CLAUDE.md                   # Project-specific coding standards
│       └── PLANNING.md                 # Project-specific architecture
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
│   │   ├── CLAUDE-template.md          # Per-project CLAUDE.md template
│   │   └── PLANNING-template.md        # Per-project PLANNING.md template
│   └── assets/                         # Shared assets
│
├── .claude/                            # Workspace-level Claude commands & skills
│   ├── commands/                       # Slash commands (/generate-prp, etc.)
│   └── skills/                         # Domain expertise (skill-creator, frontend-design)
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

# Update project-specific CLAUDE.md and PLANNING.md with:
# - New patterns learned
# - Architectural decisions made
# - Important implementation notes
```

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

### When to Update Project-Specific Docs

After implementing a feature, update the relevant project's `CLAUDE.md` and `PLANNING.md` with:

**CLAUDE.md updates:**
- New coding patterns established
- File organization changes
- New commands or scripts
- Important conventions learned

**PLANNING.md updates:**
- Architectural decisions made
- New data flow patterns
- Performance optimizations
- Integration points established

### Where PRPs Live

**PRPs are historical records** and stay in `context-engineering/PRPs/` permanently. They document:
- What was built
- Why decisions were made
- What patterns were followed
- What problems were solved

Refer to PRPs when implementing similar features in the future.

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
| Overall repository structure | This file (CLAUDE.md) |
| Development philosophy | [`PLANNING.md`](PLANNING.md) |
| **Current workspace status** | [`context-engineering/_STATUS.md`](context-engineering/_STATUS.md) |
| Project-specific coding rules | `active-projects/{project}/CLAUDE.md` |
| Project architecture details | `active-projects/{project}/PLANNING.md` |
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
| Understand a specific project | Read `active-projects/{project}/CLAUDE.md` and `PLANNING.md` |
| Find similar implementations | Check `knowledge-base/` sections first, then `context-engineering/PRPs/` for details |
| Learn coding conventions | Read project-specific `CLAUDE.md` file |
| Understand data architecture | Read project-specific `PLANNING.md` file |
| Pull template updates | Run `/update-template` |

---

## Important Reminders

1. **Read project-specific docs first** - Each project has unique patterns and conventions
2. **Follow the PRP workflow** - Don't skip steps or create undocumented features
3. **Update docs after implementation** - Keep CLAUDE.md and PLANNING.md current
4. **Archive completed features** - Move requirements from `in-progress/` to `archive/feature-inputs/`
5. **Update the knowledge base** - Run `/update-knowledge-base` after completing PRPs

---

## Template Locations

| Template | Location |
|----------|----------|
| Feature input template | `context-engineering/PRPs/templates/feature_input_template.md` |
| Simple PRP template | `context-engineering/PRPs/templates/prp_base.md` |
| Complex PRP template | `context-engineering/PRPs/templates/prp_complex.md` |
| Test cases template | `context-engineering/PRPs/templates/test_cases_template.md` |
| Project CLAUDE.md template | `shared/templates/CLAUDE-template.md` |
| Project PLANNING.md template | `shared/templates/PLANNING-template.md` |
