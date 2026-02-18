# Cortex - The Thinking Layer Around Your Codebase

**Cortex** is a structured context engineering system that gives AI agents deep, persistent knowledge about your projects. It combines a **PRP workflow** (Project Requirement Plans) for feature development, a **concept-centric knowledge base** for institutional memory, and **AI-powered commands** that automate the entire lifecycle.

---

## Quick Start

### 1. Copy this template into your workspace

```bash
# After running the setup script, your workspace looks like:
my-workspace/
├── CLAUDE.md              # Master navigation hub
├── PLANNING.md            # Development philosophy
├── CONFIG.md              # Commands reference
├── active-projects/       # Your project repos go here
├── context-engineering/   # Feature management system
├── knowledge-base/        # Persistent knowledge
└── ...
```

### 2. Add your projects

Place your project repositories in `active-projects/`:

```bash
# Clone or symlink your projects
git clone https://github.com/you/project-a active-projects/project-a
git clone https://github.com/you/project-b active-projects/project-b
```

### 3. Run workspace setup

```
/setup-workspace
```

This command will:
- Scan all projects and detect tech stacks
- Generate `CLAUDE.md` and `PLANNING.md` for each project
- Update root navigation docs
- Initialize the knowledge base
- Report what was discovered

### 4. Start building features

```
/generate-requirements context-engineering/feature-inputs/pending/my-feature.md
```

---

## How It Works

Cortex has three pillars:

### 1. PRP Workflow (Feature Development)

Every feature follows a structured lifecycle:

```
Feature Idea
    │
    ▼
/generate-requirements ──→ Requirements Doc (pending/)
    │
    ▼
/generate-prp ──→ PRP Created (PRPs/) + move to in-progress/
    │
    ▼
/check-prp ──→ Validate structure
    │
    ▼
/execute-prp ──→ Implement Phase 0
    │
    ▼ (for phased PRPs)
/continue-prp ──→ Each subsequent phase
    │               │
    │               ▼
    │         /update-knowledge-base (EVERY phase)
    │
    ▼
/ensure-tracking ──→ Verify docs complete
    │
    ▼
Feature Complete ──→ Archive requirements, update project docs
```

**Simple features** get a single PRP file. **Complex features** get a folder with phases, each containing PLAN.md, TEST-CASES.md, COMPLETED.md, FIXES.md, and HANDOFF.md.

### 2. Knowledge Base (Institutional Memory)

A concept-centric knowledge base organized into 5 categories:

| Category | What It Contains | Question It Answers |
|----------|-----------------|-------------------|
| **Concepts** | Entity definitions, schemas, business rules | "What IS this thing?" |
| **Flows** | Processes, sequences, data flows | "HOW does this work?" |
| **Implementations** | Project-specific patterns, file organization | "WHERE is the code?" |
| **Gotchas** | Pitfalls, edge cases, bugs encountered | "What should I WATCH OUT for?" |
| **Decisions** | Architecture Decision Records (ADRs) | "WHY was this chosen?" |

**Three reading levels:**
1. `INDEX.md` — Quick overview of all topics (read first)
2. `_SUMMARY.md` — Section-level summaries with topic tables
3. Individual topic files — Full details

The KB is updated automatically after every PRP phase via `/update-knowledge-base`.

### 3. AI Commands (Automation)

13 commands that automate the entire workflow:

| Command | Purpose |
|---------|---------|
| `/generate-requirements` | Transform feature ideas into structured requirements |
| `/generate-prp` | Generate implementation-ready PRP from requirements |
| `/check-prp` | Validate PRP structure and requirements alignment |
| `/execute-prp` | Execute PRP (Phase 0 for phased PRPs) |
| `/continue-prp` | Continue phased PRP (Phase 1+) |
| `/check-progress` | Mid-development progress audit against requirements |
| `/ensure-tracking` | Verify documentation completeness before closing context |
| `/update-knowledge-base` | Extract knowledge from PRP into KB + update project docs |
| `/populate-knowledge-base` | Full KB discovery and population from all projects |
| `/rebuild-kb-index` | Regenerate INDEX.md and all _SUMMARY.md files |
| `/audit-context` | Comprehensive workspace health check |
| `/setup-workspace` | Initial workspace setup (run after copying template) |
| `/update-template` | Pull latest Cortex template updates safely |

---

## Directory Structure

```
{workspace-name}/
├── CLAUDE.md                           # Master navigation hub for AI agents
├── PLANNING.md                         # Development philosophy and principles
├── CONFIG.md                           # Commands and skills reference
├── README.md                           # This file
├── .template-version                   # Template version for updates
│
├── active-projects/                    # Your project repositories
│   └── {project-name}/
│       ├── CLAUDE.md                   # Project-specific coding standards
│       └── PLANNING.md                 # Project-specific architecture
│
├── experiments/                        # Prototypes and proof-of-concepts
│
├── context-engineering/                # Feature management system
│   ├── _STATUS.md                      # Current workspace status
│   ├── feature-inputs/
│   │   ├── pending/                    # Features awaiting PRP generation
│   │   └── in-progress/               # Features currently being implemented
│   ├── PRPs/                           # Project Requirement Plans
│   │   ├── templates/                  # PRP templates
│   │   ├── {feature-name}.md           # Simple PRPs (single file)
│   │   └── {FEATURE-NAME}/            # Complex PRPs (folder with phases)
│   └── archive/                        # Completed/deprecated documents
│
├── knowledge-base/                     # Concept-centric knowledge base
│   ├── INDEX.md                        # Master navigation (read first)
│   ├── _TEMPLATES/                     # Topic file templates
│   ├── concepts/                       # WHAT things are
│   ├── flows/                          # HOW things work
│   ├── implementations/               # WHERE code lives (per-project)
│   ├── gotchas/                        # WARNINGS and pitfalls
│   └── decisions/                      # WHY we chose (ADRs)
│
├── shared/                             # Shared resources
│   ├── docs/                           # Documentation guides
│   │   ├── commands-and-skills.md      # All commands & skills reference
│   │   ├── knowledge-base.md           # KB structure & integration guide
│   │   └── prp-workflow.md             # PRP lifecycle guide
│   ├── templates/                      # Per-project doc templates
│   │   ├── CLAUDE-template.md
│   │   └── PLANNING-template.md
│   ├── scripts/                        # Utility scripts
│   └── assets/                         # Shared assets
│
├── archive/                            # Completed/paused projects
│
├── .claude/                            # AI agent configuration
│   ├── commands/                       # Slash commands (13 total)
│   └── skills/                         # Domain expertise
│       ├── skill-creator/              # Framework for creating new skills
│       └── frontend-design/            # Production UI design
│
└── tools/                              # Development tools and configs
```

---

## Skills

Cortex includes 2 built-in skills:

### skill-creator

A framework for creating custom domain-specific skills. Use it when you want to add specialized expertise to your workspace.

```
/skill-creator
```

It provides:
- Skill structure templates (SKILL.md, scripts/, references/, assets/)
- Validation tools to check skill format
- Packaging tools for distribution
- Guidance on 4 skill structure patterns (workflow, task, reference, capabilities)

### frontend-design

Production-grade UI design that avoids generic "AI slop" aesthetics. Use it when building web interfaces.

```
/frontend-design
```

It provides:
- Bold aesthetic direction guidance
- Typography, color, motion, and spatial composition principles
- Anti-patterns to avoid (generic fonts, cliched colors, predictable layouts)
- Context-specific creative choices

---

## PRP Workflow Details

### Simple vs Phased PRPs

**Simple PRPs** (single file) are for features that:
- Can be done in 1-2 sessions
- Have less than 10 tasks
- Are low risk and straightforward

**Phased PRPs** (folder) are for features that:
- Require 3+ sessions
- Have multiple components that depend on each other
- Need careful phase-by-phase testing

### Phase Files

Each phase in a phased PRP contains:

| File | Purpose |
|------|---------|
| `PLAN.md` | Tasks, file paths, code patterns, acceptance criteria |
| `TEST-CASES.md` | Concrete test cases with validation queries |
| `COMPLETED.md` | Work log (filled during implementation) |
| `FIXES.md` | Bug tracking (issues reported and fixed) |
| `HANDOFF.md` | Context transfer for next session/phase |

### Agent-Guided Testing

After implementation, the agent walks you through test cases:
1. Presents each test case with steps
2. You perform the action
3. Agent validates the result using your project's validation method
4. Marks pass/fail in the tracker
5. If failed: logs to FIXES.md, fixes, retests

---

## Knowledge Base Integration

The knowledge base isn't standalone — it's deeply integrated into the PRP workflow:

### During Feature Input (`/generate-requirements`)
- User lists relevant KB topics in the "Knowledge Base Context" section
- Agent searches KB for additional relevant topics
- Gotchas are prioritized to prevent known issues

### During PRP Generation (`/generate-prp`)
- Agent reads KB before creating implementation plans
- KB references are included in every PRP
- Implementation patterns from KB guide code generation

### During Execution (`/execute-prp`, `/continue-prp`)
- Agent reads referenced KB topics before coding
- Gotchas inform defensive coding decisions

### After Each Phase
- `/update-knowledge-base` extracts new knowledge
- New patterns, gotchas, and decisions are documented
- Project CLAUDE.md and PLANNING.md are updated
- Index and summaries are regenerated

### Before Closing Context (`/ensure-tracking`)
- Verifies KB was updated for this phase
- Flags missing knowledge base entries
- Ensures nothing is lost between sessions

---

## Updating Cortex

When the Cortex template gets new commands, skills, or improvements:

```
/update-template
```

This command:
1. Reads your current `.template-version`
2. Fetches the latest release from the Cortex GitHub repo
3. Classifies files as:
   - **Infrastructure** (safe to update): commands, skills, KB templates, PRP templates
   - **User content** (never touched): CLAUDE.md, PLANNING.md, KB entries, PRPs, your projects
   - **Review candidates** (shows diff): CONFIG.md, .gitignore, README.md
4. Shows diffs and asks for approval before applying
5. Bumps `.template-version`

---

## Documentation Reference

| Document | What It Covers |
|----------|---------------|
| [CLAUDE.md](CLAUDE.md) | Master navigation, workspace structure, workflows |
| [PLANNING.md](PLANNING.md) | Development philosophy, context engineering principles |
| [CONFIG.md](CONFIG.md) | All commands and skills with syntax |
| [shared/docs/commands-and-skills.md](shared/docs/commands-and-skills.md) | Detailed command & skills reference |
| [shared/docs/knowledge-base.md](shared/docs/knowledge-base.md) | KB architecture and integration guide |
| [shared/docs/prp-workflow.md](shared/docs/prp-workflow.md) | Full PRP lifecycle guide |

---

## Getting Help

- Run `/audit-context` for a comprehensive workspace health check
- Check `context-engineering/_STATUS.md` for current workspace state
- Read project-specific `CLAUDE.md` files for coding conventions
- Search `knowledge-base/INDEX.md` for past decisions and patterns

---

## License

MIT
