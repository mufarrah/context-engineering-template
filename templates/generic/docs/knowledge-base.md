# Cortex Knowledge Base Guide

How the concept-centric knowledge base works, its 5 categories, and how it integrates with the PRP workflow.

---

## Architecture Overview

The knowledge base uses a **concept-centric** architecture — knowledge organized by type (WHAT/HOW/WHERE/WARNINGS/WHY), not by domain or time.

```
knowledge-base/
├── INDEX.md                    # Master navigation (read FIRST)
├── _TEMPLATES/                 # Templates for creating new topics
├── concepts/                   # WHAT things are (definitions, schema, rules)
├── flows/                      # HOW things work (processes, sequences)
├── implementations/            # WHERE code lives (patterns, file organization)
├── gotchas/                    # WARNINGS (pitfalls, edge cases)
└── decisions/                  # WHY we chose (Architecture Decision Records)
```

**Key principle:** Separate WHAT from HOW from WHERE from WHY.

---

## The 5 Categories

### 1. Concepts — WHAT things are
**Location:** `knowledge-base/concepts/`
**Contains:** Definitions, schemas, rules, entity descriptions

**Example topics:**
- `bookings.md` — What a booking is, its lifecycle, data model
- `authentication.md` — How auth works, user roles, permissions
- `invoices.md` — Invoice structure, statuses, calculations

**When to create:** When you define a new entity, concept, or domain term.

### 2. Flows — HOW things work
**Location:** `knowledge-base/flows/`
**Contains:** Processes, sequences, data flows, user journeys

**Example topics:**
- `booking-lifecycle.md` — Create → Confirm → Complete → Archive
- `client-creation-flow.md` — Sources, validation, deduplication
- `payment-flow.md` — Initiate → Process → Confirm → Record

**When to create:** When you implement a process that spans multiple components.

### 3. Implementations — WHERE code lives
**Location:** `knowledge-base/implementations/`
**Contains:** Project-specific patterns, file locations, code conventions

**Example topics:**
- `forms-and-components.md` — Form patterns, component structure
- `route-patterns.md` — How API routes are organized
- `state-management.md` — State management approach

**When to create:** When a pattern is established that should be followed.

### 4. Gotchas — WARNINGS
**Location:** `knowledge-base/gotchas/`
**Contains:** Pitfalls, edge cases, known issues, things that break

**Example topics:**
- `timezone-handling.md` — Common timezone bugs and solutions
- `caching-issues.md` — When caching causes stale data
- `race-conditions.md` — Known race conditions and mitigations

**When to create:** When you discover a bug, edge case, or non-obvious behavior.

### 5. Decisions — WHY we chose
**Location:** `knowledge-base/decisions/`
**Contains:** Architecture Decision Records (ADRs) — numbered, permanent

**Example topics:**
- `001-concept-centric-kb.md` — Why we organized KB by concept type
- `002-storage-model.md` — Why we use this specific schema
- `003-testing-strategy.md` — Why we test this way

**When to create:** When a significant architectural decision is made.

---

## Three Reading Levels

The knowledge base supports progressive disclosure:

### Level 1: INDEX.md (Overview)
- Quick navigation matrix
- Topic counts per section
- Architecture summary

### Level 2: _SUMMARY.md (Section Overview)
- List of all topics in the section
- Brief description of each topic
- Last updated dates

### Level 3: Individual Topic Files (Deep Dive)
- Full content with examples
- Code references with file paths
- Related topics links

**Reading order for a new area:**
1. **Concept** → Understand WHAT the thing is
2. **Flow** → See HOW it works end-to-end
3. **Implementation** → Get project-specific patterns
4. **Gotchas** → Check for known pitfalls
5. **Decision** → Understand WHY (if needed)

---

## Integration with PRP Workflow

The knowledge base is deeply integrated into the PRP workflow:

### During Feature Input
Feature inputs include a "Knowledge Base Context" section where you list relevant topics from each category. This ensures both you and the agent start with the right context.

### During PRP Generation (`/generate-prp`)
The command checks the knowledge base for:
- Relevant concepts the feature uses
- Existing flows the feature interacts with
- Implementation patterns to follow
- Known gotchas to avoid
- Previous decisions that affect the approach

### During Execution (`/execute-prp`, `/continue-prp`)
PRPs include `Knowledge Base References` in each phase's PLAN.md. The agent reads these before starting work.

### After Each Phase
`/update-knowledge-base` is called to:
- Create/update concept definitions
- Document new or modified flows
- Record implementation patterns
- Log discovered gotchas
- Record architectural decisions
- **Update CLAUDE.md** with new patterns
- **Update PLANNING.md** with architecture changes

### Before Closing Context
`/ensure-tracking` verifies that:
- Knowledge base was updated (every phase!)
- Project docs were updated
- No knowledge was lost

---

## Knowledge Base Commands

| Command | Purpose |
|---------|---------|
| `/update-knowledge-base {PRP}` | Extract knowledge from a specific PRP |
| `/update-knowledge-base` | Extract knowledge from current conversation |
| `/populate-knowledge-base` | Full scan of project and docs |
| `/rebuild-kb-index` | Regenerate INDEX.md and _SUMMARY.md |

### When to use which:

| I just... | Run this |
|-----------|----------|
| Completed a PRP or phase | `/update-knowledge-base {PRP-path}` |
| Fixed a bug (no PRP) | `/update-knowledge-base` |
| Refactored code (no PRP) | `/update-knowledge-base` |
| Made major project changes | `/populate-knowledge-base` |
| Manually edited topics | `/rebuild-kb-index` |
| See wrong topic counts | `/rebuild-kb-index` |

---

## Topic File Templates

When creating new topics, use the appropriate template from `knowledge-base/_TEMPLATES/`:

| Section | Template |
|---------|----------|
| Concepts | `concept-template.md` |
| Flows | `flow-template.md` |
| Implementations | `implementation-template.md` |
| Gotchas | `gotcha-template.md` |
| Decisions (ADRs) | `decision-template.md` |

---

## How Knowledge Differs from PRPs

| Aspect | PRPs | Knowledge Base |
|--------|------|----------------|
| Organization | Chronological (by feature) | By concept type |
| Purpose | Implementation record | Reusable knowledge |
| Lifecycle | Created once, stays forever | Continuously updated |
| Scope | Single feature | Cross-feature |
| Audience | Agent implementing the feature | Any agent working in any area |

**PRPs answer:** "How did we implement feature X?"
**Knowledge base answers:** "What is concept Y?", "How does flow Z work?", "What gotchas exist in area W?"

---

## Safety Rules

- NEVER delete existing topic files
- NEVER remove content from existing topics (only append/update)
- ALWAYS verify claims against actual code before documenting
- ALWAYS run `/rebuild-kb-index` after manual topic edits
- ALWAYS read project docs before updating them
