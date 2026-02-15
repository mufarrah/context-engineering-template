# Cortex Knowledge Base

**Auto-generated:** {date} | **Total Topics:** 0 | **Sections:** 5

## Architecture

This knowledge base uses a **concept-centric** architecture with layered depth:

```
INDEX.md (you are here)
    |
    +-- concepts/      --> WHAT things are (definitions, schema, rules)
    |
    +-- flows/         --> HOW things work (processes, sequences)
    |
    +-- implementations/ --> WHERE code lives (project-specific patterns)
    |   +-- {project-a}/
    |   +-- {project-b}/
    |   +-- ...
    |
    +-- gotchas/       --> WARNINGS (pitfalls, edge cases)
    |
    +-- decisions/     --> WHY we chose (Architecture Decision Records)
```

## How to Use

### Three Reading Levels

Information is organized in three progressive levels of depth:

1. **INDEX (this file)** -- Top-level table of contents. Scan section tables to find relevant topics at a glance. Start here when exploring an unfamiliar area.
2. **_SUMMARY (per section)** -- Section overview with topic list and one-line summaries. Read this to understand what a section covers before diving into individual files.
3. **Topic file** -- Full detail on a single subject. Each topic file follows a standard template from `_TEMPLATES/` and contains definitions, code examples, related links, and change history.

### Reading Order

When learning about a new area, follow this order:

1. **Concept** -- Understand WHAT the thing is
2. **Flow** -- See HOW it works end-to-end
3. **Implementation** -- Get project-specific patterns
4. **Gotchas** -- Check for known pitfalls
5. **Decision** -- Understand WHY (if needed)

### Quick Navigation

| I need to understand...               | Start here                                      |
|----------------------------------------|-------------------------------------------------|
| What a domain entity or concept IS     | [concepts/](concepts/_SUMMARY.md)               |
| How a process works end-to-end         | [flows/](flows/_SUMMARY.md)                     |
| Code patterns for a specific project   | [implementations/](implementations/_SUMMARY.md) |
| Known pitfalls and warnings            | [gotchas/](gotchas/_SUMMARY.md)                 |
| Why a decision was made                | [decisions/](decisions/_SUMMARY.md)              |

---

## Concepts (0 topics)

Core business concepts -- WHAT things are.

| Topic | Summary | Projects |
|-------|---------|----------|
| *(none yet)* | | |

---

## Flows (0 topics)

Cross-cutting processes -- HOW things work.

| Topic | Summary | Projects |
|-------|---------|----------|
| *(none yet)* | | |

---

## Implementations (0 topics)

Project-specific patterns -- WHERE code lives.

| Topic | Summary |
|-------|---------|
| *(none yet)* | |

---

## Gotchas (0 topics)

Known pitfalls and warnings -- CHECK BEFORE CODING.

| Topic | Severity | Summary |
|-------|----------|---------|
| *(none yet)* | | |

---

## Decisions (0 topics)

Architecture Decision Records -- WHY we chose.

| ADR | Title | Status |
|-----|-------|--------|
| *(none yet)* | | |

---

## Maintenance

### Keeping the KB Updated

| After...                         | Run                                    |
|----------------------------------|----------------------------------------|
| Completing a PRP                 | `/update-knowledge-base {PRP-path}`    |
| Making code changes (no PRP)     | `/update-knowledge-base`               |
| Manual topic edits               | `/rebuild-kb-index`                    |
| Adding a new project             | `/populate-knowledge-base`             |

### How It Works

- `/update-knowledge-base` extracts knowledge from completed PRPs and upserts topic files into the appropriate sections.
- `/rebuild-kb-index` regenerates this INDEX.md and all `_SUMMARY.md` files from the current topic files on disk.
- `/populate-knowledge-base` scaffolds knowledge base entries for a new project by auditing its codebase.

Topic files follow the templates in `_TEMPLATES/`. When creating new topics manually, copy the relevant template and fill in the sections.
