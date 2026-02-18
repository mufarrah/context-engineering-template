# Cortex — Architecture & Planning

**Project:** {PROJECT_NAME} — {PROJECT_DESCRIPTION}
**Tech Stack:** {FRAMEWORK}, {LANGUAGE}, {DATABASE}
**Purpose:** This document explains the development philosophy, project architecture, and design decisions.

---

## Quick Reference

| What You Need | Where to Find It |
|---------------|------------------|
| Project navigation and coding standards | [`CLAUDE.md`](CLAUDE.md) |
| **Architecture & philosophy** (this file) | This document |
| Current project status | [`context-engineering/_STATUS.md`](context-engineering/_STATUS.md) |
| Historical feature implementations | `context-engineering/PRPs/` folder |
| Knowledge about past decisions | [`knowledge-base/INDEX.md`](knowledge-base/INDEX.md) |

---

## Development Philosophy

### Feature-Driven Development

We follow a **PRP-based (Project Requirement Plan)** approach:

1. **Plan Before Code**: Every feature starts with a requirements document
2. **Document Decisions**: PRPs capture the "why" behind architectural choices
3. **Learn from History**: Past PRPs inform future implementations
4. **Keep Docs Current**: CLAUDE.md and PLANNING.md are updated after each feature

### Context Engineering Principles

**The Goal:** Enable AI agents to work efficiently without repeated explanations.

**How We Achieve This:**
- **Clear Navigation**: CLAUDE.md routes agents to project-specific information
- **Historical Reference**: PRPs document past decisions and patterns
- **Organized Feature Tracking**: Clear separation of pending, in-progress, and completed features
- **Knowledge Base**: Concept-centric knowledge extracted from completed PRPs

### Knowledge Base System

The knowledge base (`knowledge-base/`) is a **concept-centric** system that captures institutional knowledge:

- **Concept-centric architecture**: Knowledge organized by type (WHAT/HOW/WHERE/WHY), not by domain or time
  - `concepts/` - WHAT things are (definitions, schema, rules)
  - `flows/` - HOW things work (processes, sequences, data flow)
  - `implementations/` - WHERE code lives (project-specific patterns)
  - `gotchas/` - WARNINGS (pitfalls, edge cases)
  - `decisions/` - WHY we chose (Architecture Decision Records)
- **Three reading levels**: `INDEX.md` → section `_SUMMARY.md` → individual topic files (progressive disclosure)
- **Merge-based**: Changes update existing topic files rather than creating new files per change
- **Auto-indexed**: `INDEX.md` and `_SUMMARY.md` files are regenerated from topic content
- **Integrated into PRP workflow**: Commands automatically update the knowledge base on feature completion

**How it differs from PRPs:** PRPs are chronological implementation records. The knowledge base reorganizes that knowledge by concept type so agents can find definitions separately from flows and implementations.

---

## Project Architecture

<!-- Fill this section after running /setup-project -->

### Overview

*Run `/setup-project` to auto-populate this section, then customize.*

**Architecture Style:** {monolith, microservices, serverless, etc.}
**Key Directories:**

```
src/
├── ...                    # {Describe your architecture}
```

### Data Model

*Document your key data models, schemas, or database structure:*

#### {Entity Name}
```
{Schema or model description}
```

### Key Flows

*Document the most important data flows and processes:*

#### Flow 1: {Name}
```
{Step 1} → {Step 2} → {Step 3} → {Result}
```

### API Structure

*Document your API organization (if applicable):*

| Endpoint Group | Base Path | Purpose |
|---------------|-----------|---------|
| | | |

---

## How Features Are Tracked

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

## Design Decisions

*Document significant architectural decisions here, or use the knowledge base `decisions/` section for formal ADRs.*

### Decision 1: {Title}
- **Context:** {Why this came up}
- **Decision:** {What was chosen}
- **Rationale:** {Why}

---

## Performance Considerations

*Document performance patterns, constraints, or optimizations:*

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

1. Read [`CLAUDE.md`](CLAUDE.md) for project structure and coding standards
2. Read this file (PLANNING.md) for architecture and philosophy
3. Search PRPs for similar implementations
4. Check knowledge base for relevant domain knowledge

### Common Mistakes to Avoid:

- **Assuming patterns without reading docs** → Always read CLAUDE.md first
- **Not documenting architectural decisions** → Update PLANNING.md after significant changes
- **Ignoring existing PRPs** → Search PRPs before implementing similar features
- **Creating undocumented features** → Always follow the PRP workflow
- **Not archiving completed features** → Move feature inputs to archive/ when done
- **Skipping knowledge base updates** → Run `/update-knowledge-base` after completing PRPs

---

## Summary

This project uses **Cortex** for efficient AI-assisted development through:

1. **Clear Organization** — CLAUDE.md for standards, PLANNING.md for architecture
2. **Historical Knowledge** — PRPs capture past decisions and patterns
3. **Institutional Memory** — Knowledge base preserves learnings across sessions
4. **Consistent Workflows** — Feature development follows the PRP process

**Key Principle:** AI agents should NEVER need to ask "where do I find coding standards?" or "how was this feature implemented before?" — the answer should always be in the docs.
