# Cortex — Agent Instructions & Coding Standards

**Project:** {PROJECT_NAME}
**Framework:** {FRAMEWORK_AND_VERSION}
**Purpose:** This is the **single source of truth** for AI agents working on this project — navigation, architecture, and coding standards. Read it first when starting any task.

> Claude Code loads this file automatically through `CLAUDE.md` (which imports it). Other agent tools (Cursor, Codex, etc.) read `AGENTS.md` directly. **Edit this file, not `CLAUDE.md`.**

---

## Quick Start for AI Agents

### When Starting a New Task:

1. **Read this file** to understand the project structure, architecture, and coding standards
2. **Check [`knowledge-base/INDEX.md`](knowledge-base/INDEX.md)** for relevant domain knowledge
3. **Follow the feature development workflow** (see [Feature Development Workflow](#feature-development-workflow))

### Critical Rule:

**NEVER assume you know the codebase**. Always read this file before making changes.

---

## Project Structure

```
{project-name}/
├── AGENTS.md                           # This file — agent instructions + coding standards (source of truth)
├── CLAUDE.md                           # Thin Claude Code entry point (imports AGENTS.md)
├── CONFIG.md                           # Available commands reference
├── README.md                           # Project quick start guide
│
├── context-engineering/                # Feature management system
│   ├── _STATUS.md                      # Current project status (lightweight tracker)
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
├── knowledge-base/                     # Concept-centric knowledge base
│   ├── INDEX.md                        # Auto-generated TOC (agents read FIRST)
│   ├── _TEMPLATES/                     # Topic file templates
│   ├── concepts/                       # WHAT things are (definitions, schema, rules)
│   ├── flows/                          # HOW things work (processes, sequences)
│   ├── implementations/                # WHERE code lives (patterns, file organization)
│   ├── gotchas/                        # WARNINGS (pitfalls, edge cases)
│   └── decisions/                      # WHY we chose (Architecture Decision Records)
│
├── docs/                               # Documentation guides
│   ├── commands-and-skills.md          # Commands & skills reference
│   ├── knowledge-base.md              # Knowledge base guide
│   └── prp-workflow.md                # PRP workflow guide
│
├── .claude/                            # Claude skills (slash commands + domain skills)
│   └── skills/                         # Each skill is a folder with SKILL.md
│       ├── {command}/                  # Slash-command skills (/generate-prp, etc.)
│       └── ...                         # Domain skills (skill-creator, frontend-design)
│
├── src/                                # Source code
│   └── ...                             # {Describe your source structure}
│
└── ...                                 # Other project files
```

---

## Feature Development Workflow

### Overview

We use a **PRP-based (Project Requirement Plan)** development system:

```
Feature Idea → Requirements Doc → PRP Generation → Implementation → Archive
```

### Detailed Workflow

#### 1. Feature Initiation

**Option A: Start from template**
```bash
# Copy template
cp context-engineering/PRPs/templates/feature_input_template.md context-engineering/feature-inputs/pending/my-feature.md

# Edit the file with your requirements, then:
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

---

## Coding Standards

<!-- Fill this section after running /setup-project -->

### Tech Stack

*Run `/setup-project` to auto-populate this section.*

| Component | Technology |
|-----------|-----------|
| Framework | {framework} |
| Language | {language} |
| Package Manager | {package manager} |
| Testing | {testing framework} |
| Database | {database, if applicable} |

### Commands

```bash
# Build
{build command}

# Test
{test command}

# Lint
{lint command}

# Dev server
{dev server command}
```

### File Organization

*Document your key file organization patterns:*

```
src/
├── ...
```

### Coding Conventions

*Document your project-specific coding conventions:*

- **Naming**: {conventions}
- **Imports**: {conventions}
- **Error handling**: {conventions}
- **State management**: {conventions, if applicable}

### Important Patterns

*Document recurring patterns in your codebase:*

#### Pattern 1: {Name}
```
{Description and example}
```

---

## Architecture

<!-- Fill this section after running /setup-project, then keep it current. Keep it high-level — deep dives belong in knowledge-base/. -->

*Run `/setup-project` to auto-populate, then customize.*

**Architecture Style:** {monolith, microservices, serverless, etc.}

**Key Directories:**

```
src/
├── ...                    # {Describe your architecture}
```

### Data Model

*Key data models, schemas, or database structure (high-level only):*

| Entity | Purpose | Notes |
|--------|---------|-------|
| | | |

### Key Flows

*The most important data flows and processes:*

```
{Step 1} → {Step 2} → {Step 3} → {Result}
```

> **Design decisions (the "why")** live in [`knowledge-base/decisions/`](knowledge-base/INDEX.md) as ADRs, not here. This section stays a high-level map.

---

## Git Workflow

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

This file is loaded into **every** agent session, so it must stay high-signal. Most of what you learn during a feature does **not** belong here — it has a better home.

### What belongs in AGENTS.md (update ONLY for these)

Edit this file only when a change alters a **durable, every-session fact**:

- Project structure / file organization
- Tech stack, or a build / test / lint / dev command
- A new coding convention or an "always do X / never do Y" rule
- A high-level architecture or data-flow change (the map in [Architecture](#architecture))
- A cross-cutting gotcha that applies project-wide

Before editing, apply this litmus test: **"Would a fresh agent need this in *every* session, regardless of which task it's doing?"** If no, it does not go here.

### What must NEVER go in AGENTS.md

Do **not** add any of the following — they bloat the file and drown out the rules that matter:

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
| Where a pattern lives in code | `knowledge-base/implementations/` |
| Current status / progress | `context-engineering/_STATUS.md` |

`/update-knowledge-base` routes learnings to the knowledge base automatically. It should touch AGENTS.md **only** for the durable facts listed above.

### Where PRPs Live

**PRPs are historical records** and stay in `context-engineering/PRPs/` permanently. They document what was built, why decisions were made, what patterns were followed, and what problems were solved.

---

## Common Commands

### Feature Development

```bash
/generate-requirements context-engineering/feature-inputs/pending/feature-name.md
/generate-prp context-engineering/feature-inputs/pending/feature-name.md
/execute-prp context-engineering/PRPs/FEATURE-NAME
/continue-prp context-engineering/PRPs/FEATURE-NAME
/ensure-tracking context-engineering/PRPs/FEATURE-NAME
```

### Knowledge Base Management

```bash
/update-knowledge-base context-engineering/PRPs/FEATURE-NAME
/populate-knowledge-base
/rebuild-kb-index
```

### Project Setup & Updates

```bash
/setup-project
/update-template
/audit-context
```

---

## Finding Information

### "Where do I find...?"

| What You Need | Where to Look |
|---------------|---------------|
| Project structure, architecture & coding standards | This file (AGENTS.md) |
| **Current project status** | [`context-engineering/_STATUS.md`](context-engineering/_STATUS.md) |
| Historical feature implementations | `context-engineering/PRPs/` |
| Completed feature requirements | `context-engineering/archive/feature-inputs/` |
| Pending features | `context-engineering/feature-inputs/pending/` |
| Active feature work | `context-engineering/feature-inputs/in-progress/` |
| **Knowledge about past decisions** | [`knowledge-base/INDEX.md`](knowledge-base/INDEX.md) |
| Commands & skills reference | [`docs/commands-and-skills.md`](docs/commands-and-skills.md) |
| Knowledge base guide | [`docs/knowledge-base.md`](docs/knowledge-base.md) |
| PRP workflow guide | [`docs/prp-workflow.md`](docs/prp-workflow.md) |

### "How do I...?"

| Task | Answer |
|------|--------|
| Start a new feature | Follow [Feature Development Workflow](#feature-development-workflow) above |
| Set up the project for the first time | Run `/setup-project` |
| Find similar implementations | Check `knowledge-base/` sections first, then `context-engineering/PRPs/` |
| Learn coding conventions | See [Coding Standards](#coding-standards) above |
| Understand architecture | See [Architecture](#architecture) above, then `knowledge-base/` |
| Pull template updates | Run `/update-template` |

---

## Important Reminders

1. **Read this file first** — Understand the project before making changes
2. **Follow the PRP workflow** — Don't skip steps or create undocumented features
3. **Keep AGENTS.md high-signal** — Only durable, every-session facts here; route learnings to the knowledge base (see [Documentation Maintenance](#documentation-maintenance))
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
