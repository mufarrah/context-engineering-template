# Cortex PRP Workflow Guide

The complete PRP (Project Requirement Plan) lifecycle — from feature idea to completion.

---

## What is a PRP?

A **PRP (Project Requirement Plan)** is a structured implementation plan that captures:
- What needs to be built
- Why decisions were made
- How to implement it (with code patterns and references)
- How to test it (with test cases)
- What was learned (for future reference)

PRPs are **permanent historical records** — they stay in `context-engineering/PRPs/` forever.

---

## The Full Lifecycle

```
Feature Idea
    │
    ▼
/generate-requirements ──→ Requirements Doc (feature-inputs/pending/)
    │
    ▼
/generate-prp ──→ PRP Created (PRPs/) + move to in-progress/
    │
    ▼
/check-prp ──→ Validate structure
    │
    ▼
/execute-prp ──→ Implement (Phase 0 for phased)
    │                  │
    │          Runs agent-guided testing
    │
    ▼ (for phased PRPs, repeat for each phase)
/continue-prp ──→ Execute next phase
    │                  │
    │          Runs agent-guided testing
    │                  │
    │          /update-knowledge-base (EVERY phase)
    │
    ▼
/ensure-tracking ──→ Verify docs complete
    │
    ▼
Feature Complete ──→ Archive requirements, update project docs
```

---

## Simple vs Phased PRPs

### Simple PRPs (Single File)

**When to use:**
- Feature is straightforward
- Can be completed in 1-2 sessions
- Less than 10 tasks
- Low to medium risk

**Structure:** Single file `context-engineering/PRPs/{feature-name}.md`

**Contains:** Goal, context, tasks, validation commands, inline test cases

### Phased PRPs (Folder)

**When to use:**
- Feature has multiple distinct phases
- Will take 3+ sessions
- Feature document is > 500 lines
- Multiple components depend on each other
- High risk, needs incremental testing

**Structure:**
```
context-engineering/PRPs/{FEATURE-NAME}/
├── _STATUS.md                    # Current phase pointer (read FIRST)
├── OVERVIEW.md                   # Feature summary and decisions
│
├── phase-0-{name}/
│   ├── PLAN.md                   # Tasks with code patterns
│   ├── TEST-CASES.md             # Agent-guided test cases
│   ├── COMPLETED.md              # Work log (filled during execution)
│   ├── FIXES.md                  # Bug log (filled during testing)
│   └── HANDOFF.md                # Context transfer (filled on completion)
│
├── phase-1-{name}/
│   └── ... (same 5 files)
│
└── phase-N-{name}/
    └── ... (same 5 files)
```

---

## Phase Files Explained

### _STATUS.md
**Purpose:** Quick status for any agent to know where things stand.

Contains: Current phase, status of all phases, reading order for new sessions.

### OVERVIEW.md
**Purpose:** Feature context that stays relevant across all phases.

Contains: Feature summary, implementation phases table, key decisions, database changes, required reading.

### PLAN.md (per phase)
**Purpose:** Detailed tasks with code patterns and references.

Contains: Tasks with file paths, code patterns to follow, knowledge base references, validation commands, acceptance criteria.

### TEST-CASES.md (per phase)
**Purpose:** Agent-guided testing walkthrough after implementation.

Contains: Test cases grouped by feature area (happy path, edge cases, protection, regression), with validation queries and status tracking.

### COMPLETED.md (per phase)
**Purpose:** Record of what was actually done.

Contains: Files created/modified, database changes, implementation notes, how to test.

### FIXES.md (per phase)
**Purpose:** Bug tracking during user testing.

Contains: Each fix with: user feedback, investigation, root cause, solution, files changed, verification.

### HANDOFF.md (per phase)
**Purpose:** Context transfer to the next phase or session.

Contains: What was built, key implementation details, decisions made, known issues, verification checklist.

---

## Feature Input Lifecycle

```
feature-inputs/pending/        ← Feature ideas and requirements
        │
        │  /generate-prp moves it
        ▼
feature-inputs/in-progress/    ← Currently being implemented
        │
        │  On completion, move it
        ▼
archive/feature-inputs/        ← Historical reference
```

**Key:** Feature inputs move through the pipeline. PRPs stay in `PRPs/` forever.

---

## Agent-Guided Testing

After implementation and validation commands pass:

```
Implementation Complete
    │
    ▼
Agent reads TEST-CASES.md
    │
    ▼
For each test case:
    │
    ├──→ Agent presents test steps to user
    │
    ├──→ User performs the action (UI, CLI, etc.)
    │
    ├──→ Agent validates results (queries, file checks, etc.)
    │
    ├──→ Agent marks pass or fail in tracker
    │
    ▼
All tests pass?
    │
    ├──→ YES: Proceed to phase completion
    │
    └──→ NO: Log failures in FIXES.md → Fix → Retest failed cases
```

**Test case categories:**
- **Happy path** — Core functionality works as expected
- **Edge cases** — Boundary conditions, empty states, max limits
- **Protection** — Blocked actions, validation errors, access control
- **Regression** — Existing functionality still works after changes

**Scale by risk level:**
- Low-risk phases: 5-10 test cases
- Medium-risk phases: 10-20 test cases
- High-risk phases: 15-30 test cases

---

## Documentation Update Flow

After completing **each phase** (not just final):

```
Phase Complete
    │
    ▼
/update-knowledge-base {PRP-path}
    │
    ├──→ Updates knowledge-base/ topics
    │
    ├──→ Updates project CLAUDE.md (patterns, modules)
    │
    ├──→ Updates project PLANNING.md (architecture)
    │
    ▼
/ensure-tracking {PRP-path}
    │
    ▼
Context can be closed safely
```

---

## Common Scenarios

### Starting a New Feature from Scratch
```bash
# 1. Copy the template
cp context-engineering/PRPs/templates/feature_input_template.md \
   context-engineering/feature-inputs/pending/my-feature.md

# 2. Edit the file with your ideas, then:
/generate-requirements context-engineering/feature-inputs/pending/my-feature.md

# 3. Generate the PRP
/generate-prp context-engineering/feature-inputs/pending/my-feature.md

# 4. Validate
/check-prp context-engineering/PRPs/my-feature.md

# 5. Execute
/execute-prp context-engineering/PRPs/my-feature.md
```

### Starting a Complex Phased Feature
```bash
/generate-prp context-engineering/feature-inputs/pending/big-feature.md
/check-prp context-engineering/PRPs/BIG-FEATURE/
/execute-prp context-engineering/PRPs/BIG-FEATURE/

# After Phase 0 approval, for each subsequent phase:
/continue-prp context-engineering/PRPs/BIG-FEATURE/
```

### Returning After a Break
```bash
# First, check workspace health
/audit-context

# Then continue where you left off
/continue-prp context-engineering/PRPs/BIG-FEATURE/
```

### Before Closing Context
```bash
/ensure-tracking context-engineering/PRPs/BIG-FEATURE/
```

---

## PRP Templates

Located in `context-engineering/PRPs/templates/`:

| Template | Purpose |
|----------|---------|
| `feature_input_template.md` | Starting point for feature ideas |
| `prp_base.md` | Simple single-file PRP template |
| `prp_complex.md` | Multi-phase PRP folder template |
| `test_cases_template.md` | Test case format and guidelines |

---

## Critical Reminders

1. **Always validate before executing** — Run `/check-prp` after `/generate-prp`
2. **Document as you go** — Update COMPLETED.md during implementation
3. **Log all fixes** — Every issue goes in FIXES.md
4. **Write handoffs** — Next session depends on HANDOFF.md
5. **Run guided testing** — Walk through TEST-CASES.md after implementation
6. **Ensure tracking before closing** — Run `/ensure-tracking` before ending session
7. **Update KB on EVERY phase** — Not just the final phase
8. **Periodic audits** — Run `/audit-context` regularly for workspace health
