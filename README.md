# Cortex - The Thinking Layer Around Your Codebase

**Cortex** is a structured context engineering system that gives AI agents deep, persistent knowledge about your projects. It combines a **PRP workflow** (Project Requirement Plans) for feature development, a **concept-centric knowledge base** for institutional memory, and **AI-powered commands** that automate the entire lifecycle.

---

## Quick Start

```bash
# Clone this repository
git clone https://github.com/mufarrah/context-engineering-template.git
cd context-engineering-template

# Run the setup script
./setup-context-engineering.sh /path/to/your/project

# Choose a template:
#   1. Single Project (generic) — for individual repositories
#   2. Multi-Project Workspace (global) — for managing multiple projects
```

After setup, open your project in Claude Code and run:
```
/setup-project      # (generic template)
/setup-workspace    # (global template)
```

This analyzes your codebase, populates documentation, and initializes the knowledge base.

---

## Two Templates

### 1. Single Project (`generic`)

For individual repositories. Adds context engineering directly to your project.

```
my-project/
├── CLAUDE.md              # Navigation + coding standards
├── PLANNING.md            # Architecture + philosophy
├── CONFIG.md              # Commands reference
├── context-engineering/   # Feature management (PRPs, feature inputs)
├── knowledge-base/        # Concept-centric knowledge base
├── docs/                  # Documentation guides
├── .claude/commands/      # 13 slash commands
├── .claude/skills/        # 2 built-in skills
└── src/                   # Your source code
```

### 2. Multi-Project Workspace (`global-multi-project`)

For workspaces managing multiple projects with shared resources.

```
my-workspace/
├── CLAUDE.md              # Master navigation hub
├── PLANNING.md            # Development philosophy
├── CONFIG.md              # Commands reference
├── active-projects/       # Your project repositories
│   └── {project}/
│       ├── CLAUDE.md      # Project-specific coding standards
│       └── PLANNING.md    # Project-specific architecture
├── context-engineering/   # Feature management
├── knowledge-base/        # Cross-project knowledge base
├── shared/                # Shared docs, templates, scripts
├── .claude/commands/      # 13 slash commands
└── .claude/skills/        # 2 built-in skills
```

---

## What You Get

### 13 AI Commands

| Command | Purpose |
|---------|---------|
| `/generate-requirements` | Transform feature ideas into structured requirements |
| `/generate-prp` | Generate implementation-ready PRP from requirements |
| `/check-prp` | Validate PRP structure and requirements alignment |
| `/execute-prp` | Execute PRP (Phase 0 for phased PRPs) |
| `/continue-prp` | Continue phased PRP (Phase 1+) |
| `/check-progress` | Mid-development progress audit |
| `/ensure-tracking` | Verify documentation completeness before closing context |
| `/update-knowledge-base` | Extract knowledge from PRP into KB |
| `/populate-knowledge-base` | Full KB discovery and population |
| `/rebuild-kb-index` | Regenerate INDEX.md and _SUMMARY.md files |
| `/audit-context` | Comprehensive project/workspace health check |
| `/setup-project` or `/setup-workspace` | Initial setup after copying template |
| `/update-template` | Pull latest Cortex template updates |

### 2 Built-in Skills

| Skill | Purpose |
|-------|---------|
| **skill-creator** | Framework for creating custom domain-specific skills |
| **frontend-design** | Production-grade UI design (anti-AI-slop aesthetics) |

### PRP Workflow

Every feature follows a structured lifecycle:

```
Feature Idea → /generate-requirements → /generate-prp → /check-prp
    → /execute-prp → /continue-prp → /ensure-tracking → Complete
```

- **Simple features**: Single PRP file
- **Complex features**: Phased folder with PLAN.md, TEST-CASES.md, COMPLETED.md, FIXES.md, HANDOFF.md per phase
- **Agent-guided testing**: After implementation, agent walks through test cases with you

### Concept-Centric Knowledge Base

Knowledge organized into 5 categories:

| Category | Question | Example |
|----------|----------|---------|
| **Concepts** | "What IS this?" | Entity definitions, schemas, rules |
| **Flows** | "HOW does it work?" | Processes, sequences, data flows |
| **Implementations** | "WHERE is the code?" | Project-specific patterns |
| **Gotchas** | "What to WATCH OUT for?" | Pitfalls, edge cases |
| **Decisions** | "WHY was this chosen?" | Architecture Decision Records |

Three reading levels: `INDEX.md` (overview) -> `_SUMMARY.md` (section) -> topic files (detail).

---

## Feature Development Workflow

```bash
# 1. Create feature input from template
cp context-engineering/PRPs/templates/feature_input_template.md \
   context-engineering/feature-inputs/pending/my-feature.md

# 2. Fill in your ideas, then generate requirements
/generate-requirements context-engineering/feature-inputs/pending/my-feature.md

# 3. Generate implementation plan (PRP)
/generate-prp context-engineering/feature-inputs/pending/my-feature.md

# 4. Validate the plan
/check-prp context-engineering/PRPs/MY-FEATURE/

# 5. Execute
/execute-prp context-engineering/PRPs/MY-FEATURE/

# 6. For phased PRPs, continue each phase
/continue-prp context-engineering/PRPs/MY-FEATURE/

# 7. Update knowledge base (after EVERY phase)
/update-knowledge-base context-engineering/PRPs/MY-FEATURE/

# 8. Verify docs before closing context
/ensure-tracking context-engineering/PRPs/MY-FEATURE/
```

---

## Updating Cortex

When this repo gets new commands, skills, or improvements:

```
/update-template
```

This command reads your `.template-version`, fetches the latest release, classifies files (infrastructure vs user content vs review candidates), shows diffs, and applies approved updates.

---

## Documentation

Each template includes 3 reference docs:

| Document | Covers |
|----------|--------|
| `commands-and-skills.md` | All 13 commands, 2 skills, decision tree, comparison matrix |
| `knowledge-base.md` | KB architecture, 5 categories, PRP integration, templates |
| `prp-workflow.md` | Full PRP lifecycle, simple vs phased, phase files, testing |

Located in `docs/` (generic) or `shared/docs/` (global).

---

## Repository Structure

```
context-engineering-template/
├── README.md                          # This file
├── CLAUDE.md                          # Repo-level AI context
├── LICENSE                            # MIT
├── setup-context-engineering.sh       # Setup script
└── templates/
    ├── generic/                       # Single-project template
    │   ├── CLAUDE.md, PLANNING.md, CONFIG.md, README.md
    │   ├── .claude/commands/          # 13 commands (single-project paths)
    │   ├── .claude/skills/            # 2 skills
    │   ├── context-engineering/       # CE skeleton
    │   ├── knowledge-base/            # KB skeleton (flat implementations)
    │   └── docs/                      # 3 reference docs
    │
    └── global-multi-project/          # Multi-project workspace template
        ├── CLAUDE.md, PLANNING.md, CONFIG.md, README.md
        ├── .claude/commands/          # 13 commands (multi-project paths)
        ├── .claude/skills/            # 2 skills
        ├── context-engineering/       # CE skeleton
        ├── knowledge-base/            # KB skeleton (per-project implementations)
        └── shared/                    # Shared docs, templates, scripts
```

---

## License

MIT
