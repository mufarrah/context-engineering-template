# Cortex Commands & Skills Reference

Quick reference for all available commands and skills in your Cortex workspace.

---

## Command Overview

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/generate-requirements` | Transform raw feature ideas into structured requirements | Starting a new feature from scratch |
| `/generate-prp` | Create implementation-ready PRP from requirements | After requirements are complete |
| `/check-prp` | Validate PRP structure and alignment | After `/generate-prp`, before execution |
| `/execute-prp` | Start executing a PRP (Phase 0 for phased) | Ready to implement a feature |
| `/continue-prp` | Resume work on a phased or simple PRP | Continuing a PRP — after a phase, mid-phase, or from a `/checkpoint` |
| `/checkpoint` | Capture a durable resume checkpoint of the current PRP | Context window filling up mid-PRP; pausing to continue in a fresh window |
| `/check-progress` | Full progress validation against requirements | Mid-development confidence check |
| `/ensure-tracking` | Verify documentation completeness | Before closing a context/session |
| `/audit-context` | Comprehensive workspace health check | Periodic audit, after breaks |
| `/update-knowledge-base` | Update KB + project docs from PRP or conversation | After completing a PRP or any code changes |
| `/populate-knowledge-base` | Full KB discovery and population | Initial setup, new project added |
| `/rebuild-kb-index` | Regenerate INDEX.md and _SUMMARY.md files | After manual topic edits |
| `/setup-workspace` | Initial workspace setup | After copying the Cortex template |
| `/update-template` | Pull latest Cortex template updates | When template repo has new version |

---

## Quick Decision Tree

**What do you need to do?**

- **Have a feature idea?** → `/generate-requirements`
- **Have a requirements document?** → `/generate-prp`
- **Just generated a PRP?** → `/check-prp` (validate before executing)
- **Ready to start coding?** → `/execute-prp`
- **Continuing a feature (phased or simple)?** → `/continue-prp`
- **Context window filling up mid-PRP?** → `/checkpoint {PRP-path}` (then `/continue-prp` in a fresh window)
- **Uncertain if all requirements are covered?** → `/check-progress`
- **About to close your context?** → `/ensure-tracking`
- **Coming back after a break?** → `/audit-context`
- **Suspect documentation is out of sync?** → `/audit-context`
- **Just completed a PRP?** → `/update-knowledge-base {PRP-path}`
- **Fixed a bug without a PRP?** → `/update-knowledge-base` (no argument)
- **Added a new project?** → `/populate-knowledge-base`
- **Topic counts wrong?** → `/rebuild-kb-index`
- **Just copied the template?** → `/setup-workspace`
- **Template repo has updates?** → `/update-template`

---

## PRP Workflow Commands (Detailed)

### /generate-requirements

**Purpose:** Transform a user's raw feature ideas into a complete, structured requirements document.

**Input:** User's feature input file (from `feature_input_template.md`)
**Output:** Structured requirements document ready for `/generate-prp`

**What it does:**
1. Reads the user's feature input file
2. Fetches and analyzes all referenced documentation
3. Searches codebase for related patterns
4. Designs database changes, user flows, architecture
5. Plans test scenarios (happy path, edge cases, protection, regression)
6. Outputs structured requirements document

```bash
/generate-requirements context-engineering/feature-inputs/pending/my-feature.md
```

### /generate-prp

**Purpose:** Generate a complete, implementation-ready PRP from a requirements document.

**Output:** PRP file (simple) or PRP folder (phased) with TEST-CASES.md

**What it does:**
1. Reads requirements and validates for completeness
2. Moves feature input from `pending/` to `in-progress/`
3. Researches codebase for patterns and checks knowledge base
4. Creates PRP with tasks, code patterns, validation commands
5. Generates TEST-CASES.md for each phase
6. Updates workspace `_STATUS.md`

```bash
/generate-prp context-engineering/feature-inputs/pending/my-feature.md
```

### /check-prp

**Purpose:** Validate a generated PRP's structure and alignment with requirements.

**What it checks:**
- Structural completeness (all required files exist)
- Content completeness (all sections filled)
- Requirements alignment (gaps, coverage)
- File paths exist in codebase
- Overall quality score

```bash
/check-prp context-engineering/PRPs/FEATURE-NAME/
```

### /execute-prp

**Purpose:** Execute a PRP. For simple PRPs, completes the entire feature. For phased PRPs, executes Phase 0.

**What it does:**
1. Implements all tasks (Phase 0 for phased)
2. Runs validation commands
3. Runs agent-guided testing walkthrough
4. Updates knowledge base and project docs
5. Archives feature input (simple PRPs)

```bash
/execute-prp context-engineering/PRPs/FEATURE-NAME/
```

### /continue-prp

**Purpose:** Continue work on a phased PRP (Phase 1 and beyond).

**Handles all states:** Not Started → In Progress → Awaiting Testing → Fixes Required → Complete

**Key behavior:** Updates KB and project docs on EVERY phase, not just final.

**Detects the PRP type from the path:** a folder → phased PRP (the full phase flow, including
advancing to the next phase after one completes); a single `.md` file → simple PRP, resumed from
the `🔁 CHECKPOINT — RESUME STATE` section that `/checkpoint` writes.

```bash
/continue-prp context-engineering/PRPs/FEATURE-NAME/        # phased (folder)
/continue-prp context-engineering/PRPs/my-feature.md        # simple (file)
```

### /checkpoint

**Purpose:** Capture a complete, durable checkpoint of the CURRENT PRP so a brand-new context window
can resume with zero loss. Use it the moment your context window starts filling up mid-PRP — instead
of re-typing "save everything so the next agent doesn't forget."

**What it does:**
1. Detects PRP type (folder → phased, file → simple).
2. Assembles the live state from the conversation: what's done & verified, the single **NEXT ACTION**,
   fixes applied (root cause → solution → files), user decisions (so they're never re-litigated),
   environment/gotchas/IDs, and validation status.
3. Writes it to the durable docs — for phased: the current phase `COMPLETED.md`/`FIXES.md`/
   `TEST-CASES.md` (`🔁 RESUME STATE`) + the PRP `_STATUS.md` + the workspace `_STATUS.md`; for simple:
   a status header + a `🔁 CHECKPOINT — RESUME STATE` section in the PRP file.
4. Never advances the phase, completes the PRP, commits, or pastes secrets — it's a pause, not a finish.

**Resume with `/continue-prp {same-path}` in the new window.**

```bash
/checkpoint context-engineering/PRPs/FEATURE-NAME/    # phased (folder)
/checkpoint context-engineering/PRPs/my-feature.md    # simple (file)
```

### /check-progress

**Purpose:** Comprehensive progress validation against the original requirements.

**Output:** Full traceability matrix showing which requirements are covered by which phases.

```bash
/check-progress context-engineering/PRPs/FEATURE-NAME/
```

### /ensure-tracking

**Purpose:** Verify all documentation is complete before closing context.

**Checks:** COMPLETED.md, FIXES.md, HANDOFF.md, _STATUS.md, knowledge base updated, project docs updated.

```bash
/ensure-tracking context-engineering/PRPs/FEATURE-NAME/
```

### /audit-context

**Purpose:** Comprehensive workspace-level health check.

**Detects:** Status mismatches, feature inputs in wrong location, missing KB entries, stale project docs, cross-PRP conflicts.

```bash
/audit-context
```

---

## Knowledge Base Commands (Detailed)

### /update-knowledge-base

**Two modes:**
- **With PRP path:** Extracts knowledge from a specific PRP
- **Without argument:** Extracts from current conversation context

**Updates both** the knowledge base AND project-specific `AGENTS.md`.

```bash
/update-knowledge-base context-engineering/PRPs/FEATURE-NAME  # From PRP
/update-knowledge-base                                         # From conversation
```

### /populate-knowledge-base

**Purpose:** Full discovery and population. Scans ALL projects, PRPs, and docs.

```bash
/populate-knowledge-base
```

### /rebuild-kb-index

**Purpose:** Regenerate INDEX.md and all _SUMMARY.md files. Does NOT modify topic content.

```bash
/rebuild-kb-index
```

---

## Workspace Management Commands (Detailed)

### /setup-workspace

**Purpose:** Initialize a freshly copied Cortex workspace. Discovers projects, creates per-project docs, populates knowledge base.

```bash
/setup-workspace
```

### /update-template

**Purpose:** Pull latest Cortex template updates from GitHub without overwriting your customizations.

```bash
/update-template
```

---

## Skills Reference

### skill-creator

**Purpose:** Framework for creating new custom domain skills for your workspace.

**When to use:** When you want to add specialized expertise (e.g., a skill for your specific tech stack, testing patterns, or domain knowledge).

**Location:** `.claude/skills/skill-creator/`

### frontend-design

**Purpose:** Production-grade UI design that avoids generic "AI slop" aesthetics.

**When to use:** When building distinctive, intentional frontend interfaces. Covers typography, color/theme, motion, spatial composition, and backgrounds.

**Location:** `.claude/skills/frontend-design/`

### Creating New Skills

Use the `skill-creator` skill to create new domain-specific skills. It provides a complete framework including:
- SKILL.md structure
- Reference materials organization
- Script templates
- Validation and packaging

---

## Command Comparison Matrix

| Scenario | Command | Scope | Modifies Files? |
|----------|---------|-------|-----------------|
| Raw ideas → requirements | `/generate-requirements` | Single feature | Yes (creates doc) |
| Requirements → PRP | `/generate-prp` | Single feature | Yes (creates PRP) |
| Validate PRP structure | `/check-prp` | Single PRP | No (read-only) |
| Start implementation | `/execute-prp` | Single PRP | Yes (code + docs) |
| Continue phased PRP | `/continue-prp` | Single PRP | Yes (code + docs) |
| Pause mid-PRP for a fresh window | `/checkpoint` | Single PRP | Yes (writes resume state) |
| Check requirements coverage | `/check-progress` | Single PRP | No (read-only) |
| Pre-close doc check | `/ensure-tracking` | Single PRP | Yes (fills gaps) |
| Workspace health check | `/audit-context` | All PRPs | Optional |
| Update KB from PRP | `/update-knowledge-base` | KB + project docs | Yes |
| Full KB population | `/populate-knowledge-base` | All projects | Yes |
| Regenerate indexes | `/rebuild-kb-index` | KB indexes only | Yes |
| Initial setup | `/setup-workspace` | Entire workspace | Yes |
| Pull template updates | `/update-template` | Template files | Yes (with approval) |

---

## Safety Rules (All Commands)

1. **No git commits** — User handles all git operations
2. **No production deployments** — Never run deploy commands
3. **Follow project safety rules** — Read project AGENTS.md for project-specific safety rules
4. **Never overwrite user content** — Only create or append, never replace user customizations
