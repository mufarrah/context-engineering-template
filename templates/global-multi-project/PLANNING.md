# Cortex Workspace - Development Philosophy & Architecture Navigation

**Purpose:** This document explains the overall development philosophy, repository organization, and provides navigation to project-specific architecture documentation.

---

## Quick Reference

| What You Need | Where to Find It |
|---------------|------------------|
| Workspace navigation and workflow | [`CLAUDE.md`](CLAUDE.md) |
| **Development philosophy** (this file) | This document |
| Current workspace status | [`context-engineering/_STATUS.md`](context-engineering/_STATUS.md) |
| Project-specific architecture | See [Project Architecture Guides](#project-architecture-guides) below |
| Historical feature implementations | `context-engineering/PRPs/` folder |
| Completed feature requirements | `context-engineering/archive/feature-inputs/` |

---

## Development Philosophy

### Feature-Driven Development

We follow a **PRP-based (Project Requirement Plan)** approach:

1. **Plan Before Code**: Every feature starts with a requirements document
2. **Document Decisions**: PRPs capture the "why" behind architectural choices
3. **Learn from History**: Past PRPs inform future implementations
4. **Keep Docs Current**: Project-specific docs are updated after each feature

### Context Engineering Principles

**The Goal:** Enable AI agents to work efficiently without repeated explanations.

**How We Achieve This:**
- **Modular Documentation**: Each project has its own CLAUDE.md and PLANNING.md
- **Clear Navigation**: Root docs route agents to project-specific information
- **Historical Reference**: PRPs document past decisions and patterns
- **Organized Feature Tracking**: Clear separation of pending, in-progress, and completed features
- **Knowledge Base**: Concept-centric knowledge extracted from completed PRPs

### Knowledge Base System

The knowledge base (`knowledge-base/`) is a **concept-centric** system that captures institutional knowledge from all completed work:

- **Concept-centric architecture**: Knowledge organized by type (WHAT/HOW/WHERE/WHY), not by domain or time
  - `concepts/` - WHAT things are (definitions, schema, rules)
  - `flows/` - HOW things work (processes, sequences, data flow)
  - `implementations/` - WHERE code lives (project-specific patterns)
  - `gotchas/` - WARNINGS (pitfalls, edge cases)
  - `decisions/` - WHY we chose (Architecture Decision Records)
- **Three reading levels**: `INDEX.md` → section `_SUMMARY.md` → individual topic files (progressive disclosure)
- **Merge-based**: Changes update existing topic files rather than creating new files per change
- **Auto-indexed**: `INDEX.md` and `_SUMMARY.md` files are regenerated from topic content, not hand-maintained
- **Integrated into PRP workflow**: Commands automatically update the knowledge base on feature completion

**How it differs from PRPs:** PRPs are chronological implementation records. The knowledge base reorganizes that knowledge by concept type so agents can find "the booking concept definition" separately from "how booking flow works" and "where booking code lives."

### Why We Separate Feature Inputs from PRPs

| Document Type | Location | Purpose | Lifecycle |
|---------------|----------|---------|-----------|
| **Feature Input** | `context-engineering/feature-inputs/` | User requirements, ideas, constraints | Moves through pending → in-progress → archive |
| **PRP** | `context-engineering/PRPs/` | Implementation plan, patterns, architecture decisions | Stays forever as historical reference |

**Benefit:** PRPs become a **knowledge base** of implementation patterns and decisions.

---

## Repository Overview

### Workspace Structure

This is a **multi-project workspace** where:
- **Root directory** is NOT git-tracked (it's a container)
- **Each project** has its own git repository
- **Shared resources** are in `shared/` folder
- **Context engineering** is centralized for cross-project intelligence

### How Features Are Tracked

```
┌─────────────────────────────────────────────────────────────┐
│ Feature Lifecycle                                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. PENDING                                                 │
│     └─ context-engineering/feature-inputs/pending/          │
│        • Feature ideas                                      │
│        • User requirements                                  │
│        • Not yet started                                    │
│                                                             │
│  2. IN PROGRESS                                             │
│     └─ context-engineering/feature-inputs/in-progress/      │
│        • Currently being worked on                          │
│        • Has PRP generated                                  │
│                                                             │
│  3. ARCHIVED                                                │
│     └─ context-engineering/archive/feature-inputs/          │
│        • Completed features                                 │
│        • Historical reference                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### PRP Organization

```
context-engineering/PRPs/
├── templates/                    # Templates for new PRPs
│   ├── feature_input_template.md
│   ├── prp_base.md              # Simple feature template
│   ├── prp_complex.md           # Complex multi-phase template
│   └── test_cases_template.md   # Test case format
│
├── feature-name.md               # Simple PRP (single file)
│
└── COMPLEX-FEATURE/              # Complex PRP (phased folder)
    ├── _STATUS.md                # Current phase tracker
    ├── OVERVIEW.md               # Feature summary
    ├── phase-0-planning/
    │   ├── PLAN.md
    │   ├── TEST-CASES.md
    │   ├── COMPLETED.md
    │   ├── FIXES.md
    │   └── HANDOFF.md
    ├── phase-1-implementation/
    │   └── ... (same structure)
    └── phase-N-final/
        └── ... (same structure)
```

---

## Project Architecture Guides

<!-- Fill this section after running /setup-workspace -->

### Your Projects

*Run `/setup-workspace` to auto-discover your projects and fill this section.*

| Project | Tech Stack | Purpose | Status |
|---------|------------|---------|--------|
| | | | |

### Your Architecture Patterns

*Document your common patterns here after setup:*

#### Pattern 1: {Name}
```
{Describe common architectural patterns across your projects}
```

---

## Development Workflow

### Standard Feature Workflow

1. **Ideation**
   - Create feature input in `context-engineering/feature-inputs/pending/`
   - Can use template or write from scratch

2. **Requirements Generation** (Optional)
   - Use `/generate-requirements` to transform ideas into structured requirements

3. **PRP Generation**
   - Use `/generate-prp` to create implementation plan
   - Automatically moves feature input from `pending/` → `in-progress/`
   - Creates PRP in `context-engineering/PRPs/`

4. **Implementation**
   - Use `/execute-prp` to start implementation
   - For complex PRPs, use `/continue-prp` for subsequent phases
   - Follow project-specific patterns (read CLAUDE.md and PLANNING.md)

5. **Completion**
   - Use `/ensure-tracking` to verify docs are updated
   - Use `/update-knowledge-base` to capture learnings
   - Move feature input from `in-progress/` → `archive/feature-inputs/`
   - Update project-specific CLAUDE.md and PLANNING.md with learnings
   - PRP stays in PRPs/ as historical reference

### When to Update Documentation

**After Each Feature:**

Update `active-projects/{project}/CLAUDE.md` with:
- New coding patterns
- File organization changes
- New commands or utilities
- Important conventions

Update `active-projects/{project}/PLANNING.md` with:
- Architectural decisions
- Data flow changes
- Performance insights
- Integration patterns

---

## Learning from PRPs

### How to Use Historical PRPs

**When Starting Similar Work:**

1. **Search PRPs** for related features:
   ```bash
   grep -r "keyword" context-engineering/PRPs/
   ```

2. **Read Relevant PRPs** to understand:
   - What approach was taken
   - Why specific decisions were made
   - What problems were encountered
   - What patterns were established

3. **Follow Established Patterns** or document why you're diverging

---

## Critical Information for AI Agents

### Before Starting Any Work:

1. Read [`CLAUDE.md`](CLAUDE.md) for workflow navigation
2. Read this file (PLANNING.md) for development philosophy
3. Read project-specific `CLAUDE.md` for coding standards
4. Read project-specific `PLANNING.md` for architecture
5. Search PRPs for similar implementations
6. Check knowledge base for relevant domain knowledge

### Common Mistakes to Avoid:

- **Assuming patterns without reading docs** → Always read project-specific CLAUDE.md first
- **Not documenting architectural decisions** → Update PLANNING.md after significant changes
- **Ignoring existing PRPs** → Search PRPs before implementing similar features
- **Creating undocumented features** → Always follow the PRP workflow
- **Not archiving completed features** → Move feature inputs to archive/ when done
- **Skipping knowledge base updates** → Run `/update-knowledge-base` after completing PRPs

---

## Summary

This workspace is designed for **efficient AI-assisted development** through:

1. **Clear Organization** - Every project has its own documentation
2. **Historical Knowledge** - PRPs capture past decisions and patterns
3. **Institutional Memory** - Knowledge base preserves learnings across sessions
4. **Consistent Workflows** - Feature development follows the PRP process
5. **Modular Architecture** - Each project is independent but shares resources

**Key Principle:** AI agents should NEVER need to ask "where do I find coding standards?" or "how was this feature implemented before?" - the answer should always be in the docs.
