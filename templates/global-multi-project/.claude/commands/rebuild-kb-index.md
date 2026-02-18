# Rebuild Knowledge Base Index

Regenerate `INDEX.md` and all `_SUMMARY.md` files from the current state of topic files. Does NOT modify any topic content.

**PURPOSE:** Fix stale indexes, recalculate topic counts, and ensure the knowledge base navigation is accurate.

**WHEN TO USE:**
- When you suspect INDEX.md or _SUMMARY.md is out of sync with actual topic files
- After manually adding/removing/renaming topic files
- As a periodic health check
- After bulk knowledge base operations

---

## KNOWLEDGE BASE STRUCTURE

```
knowledge-base/
├── INDEX.md                    # Master navigation (regenerated)
├── concepts/                   # WHAT things are
│   └── _SUMMARY.md             # Regenerated
├── flows/                      # HOW things work
│   └── _SUMMARY.md             # Regenerated
├── implementations/            # WHERE code lives
│   ├── _SUMMARY.md             # Regenerated
│   └── {project-name}/         # Per-project patterns
│       └── _SUMMARY.md         # Regenerated
├── gotchas/                    # WARNINGS
│   └── _SUMMARY.md             # Regenerated
└── decisions/                  # WHY we chose
    └── _SUMMARY.md             # Regenerated
```

---

## STEP 1: SCAN ALL SECTIONS

### 1.1 Scan Concepts

Read all `.md` files in `knowledge-base/concepts/` (excluding `_SUMMARY.md`):

For each topic file, extract:
- `# {Topic Name}` - The topic title
- `**Category:**` - Should be "Concept"
- `**Projects:**` - Which projects this touches
- `**Last Updated:**` - When last modified
- First sentence of `## What` section (for summary)

### 1.2 Scan Flows

Read all `.md` files in `knowledge-base/flows/` (excluding `_SUMMARY.md`):

For each topic file, extract:
- `# {Topic Name}` - The topic title
- `**Category:**` - Should be "Flow"
- `**Projects:**` - Which projects this touches
- `**Last Updated:**` - When last modified
- First sentence of `## Overview` section (for summary)

### 1.3 Scan Implementations

For each project folder in `knowledge-base/implementations/`:

Read all `.md` files (excluding `_SUMMARY.md`):

For each topic file, extract:
- `# {Topic Name}` - The topic title
- `**Category:**` - Should be "Implementation"
- `**Project:**` - Which project this is for
- `**Last Updated:**` - When last modified
- First sentence of `## Overview` section (for summary)

### 1.4 Scan Gotchas

Read all `.md` files in `knowledge-base/gotchas/` (excluding `_SUMMARY.md`):

For each topic file, extract:
- `# {Topic Name}` - The topic title
- `**Category:**` - Should be "Gotcha"
- `**Severity:**` - High/Medium/Low
- `**Projects:**` - Which projects this affects
- `**Last Updated:**` - When last modified
- First sentence of `## The Problem` section (for summary)

### 1.5 Scan Decisions

Read all `.md` files in `knowledge-base/decisions/` (excluding `_SUMMARY.md`):

For each topic file, extract:
- `# ADR-{number}: {Title}` - The decision title
- `**Category:**` - Should be "Decision (ADR)"
- `**Status:**` - Accepted/Superseded/Deprecated
- `**Date:**` - When decided
- `**Projects:**` - Which projects this affects
- First sentence of `## Context` section (for summary)

### 1.6 Build Inventory

```
INVENTORY:
├── concepts: [{filename, title, projects, lastUpdated, summary}]
├── flows: [{filename, title, projects, lastUpdated, summary}]
├── implementations:
│   └── {project-name}: [{filename, title, lastUpdated, summary}]
├── gotchas: [{filename, title, severity, projects, lastUpdated, summary}]
└── decisions: [{filename, title, status, date, projects, summary}]
```

---

## STEP 2: REGENERATE _SUMMARY.md FILES

### 2.1 Concepts _SUMMARY.md

```markdown
# Concepts

**Topics:** {count} | **Last Updated:** {most recent date}

## Overview

Core business concepts that define WHAT things are in the system. These are the foundational definitions, schemas, and rules that all other documentation references.

## Reading Order

When learning about a new area, start with the relevant concept file to understand the fundamentals before diving into flows or implementations.

## Topics

| Topic | Summary | Projects |
|-------|---------|----------|
| [{title}]({filename}) | {summary} | {projects} |
```

### 2.2 Flows _SUMMARY.md

```markdown
# Flows

**Topics:** {count} | **Last Updated:** {most recent date}

## Overview

Cross-cutting processes that document HOW things work end-to-end. These show the sequence of steps, decision points, and data flow across multiple components and services.

## Reading Order

After understanding a concept, read the relevant flow to see how it operates in practice. Flows connect concepts to implementations.

## Topics

| Topic | Summary | Projects |
|-------|---------|----------|
| [{title}]({filename}) | {summary} | {projects} |
```

### 2.3 Implementations _SUMMARY.md (Main)

```markdown
# Implementations

**Topics:** {total count} | **Last Updated:** {most recent date}

## Overview

Project-specific implementation patterns that document WHERE and HOW code is organized. Each project has its own sub-section with patterns specific to that codebase and technology stack.

## Projects

| Project | Topics |
|---------|--------|
| [{project-name}]({project-name}/_SUMMARY.md) | {count} topics |

## Reading Order

After understanding concepts and flows, read the implementation for your target project to get project-specific patterns and code examples.
```

### 2.4 Implementations/{project}/_SUMMARY.md

```markdown
# {Project Name} Implementation Patterns

**Topics:** {count} | **Last Updated:** {most recent date}

## Overview

{Brief project description}.

## Topics

| Topic | Summary |
|-------|---------|
| [{title}]({filename}) | {summary} |
```

### 2.5 Gotchas _SUMMARY.md

```markdown
# Gotchas

**Topics:** {count} | **Last Updated:** {most recent date}

## Overview

Known pitfalls, edge cases, and lessons learned. These are warnings that can save significant debugging time. Always check this section before working in an unfamiliar area.

## Severity Levels

- **High**: Can cause data loss, security issues, or major bugs
- **Medium**: Can cause confusing behavior or subtle bugs
- **Low**: Good to know but unlikely to cause major issues

## Topics

| Topic | Severity | Summary |
|-------|----------|---------|
| [{title}]({filename}) | {severity} | {summary} |
```

### 2.6 Decisions _SUMMARY.md

```markdown
# Decisions (ADRs)

**Topics:** {count} | **Last Updated:** {most recent date}

## Overview

Architecture Decision Records documenting WHY key technical decisions were made. These provide historical context and rationale for significant choices.

## ADR Format

Each decision follows the standard ADR format:
- **Context**: What prompted the decision
- **Options Considered**: Alternatives evaluated
- **Decision**: What was chosen
- **Consequences**: Trade-offs and impacts

## Topics

| ADR | Title | Status |
|-----|-------|--------|
| [{number}]({filename}) | {title} | {status} |
```

---

## STEP 3: REGENERATE INDEX.md

Build the full index:

1. Update the header with today's date and total topic count
2. Keep the Architecture diagram and How to Use sections
3. Regenerate each section listing with topic tables
4. Keep the Maintenance section

---

## STEP 4: REPORT

```
========================================
KNOWLEDGE BASE INDEX REBUILT
========================================

Sections scanned: 5
Total topics found: {count}

Per-section breakdown:
- concepts: {N} topics
- flows: {N} topics
- implementations:
  {For each project: - {project-name}: {N} topics}
- gotchas: {N} topics
- decisions: {N} topics

Files regenerated:
- knowledge-base/INDEX.md
- knowledge-base/concepts/_SUMMARY.md
- knowledge-base/flows/_SUMMARY.md
- knowledge-base/implementations/_SUMMARY.md
{For each project: - knowledge-base/implementations/{project-name}/_SUMMARY.md}
- knowledge-base/gotchas/_SUMMARY.md
- knowledge-base/decisions/_SUMMARY.md

========================================
```

---

## CRITICAL REMINDERS

1. **READ-ONLY for topic files** - This command NEVER modifies topic content
2. **Preserve Overview text** - Only regenerate the Topics table in _SUMMARY.md (keep ## Overview)
3. **Handle empty sections** - Sections with 0 topics still get a _SUMMARY.md with an empty table
4. **Sort topics alphabetically** - List topics alphabetically in both _SUMMARY.md and INDEX.md
5. **Handle missing metadata** - If a topic file lacks proper headers, extract what you can and note in report
