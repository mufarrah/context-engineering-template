# Populate Knowledge Base

Scan projects and documentation to populate the knowledge base with verified topic files.

**PURPOSE:** Comprehensive knowledge base population that discovers ALL relevant sources, checks what's already documented, and only adds NEW or MISSING information.

**WHEN TO USE:**
- Initial knowledge base population for a project
- After major refactoring or feature additions
- Periodic knowledge base refresh/audit
- When onboarding a new project to the workspace

---

## KNOWLEDGE BASE STRUCTURE

The knowledge base uses a **concept-centric** architecture:

```
knowledge-base/
├── INDEX.md                    # Master navigation
├── concepts/                   # WHAT things are (definitions, schema, rules)
├── flows/                      # HOW things work (processes, sequences)
├── implementations/            # WHERE code lives (project-specific patterns)
│   └── {project-name}/        # Per-project implementation patterns
├── gotchas/                    # WARNINGS (pitfalls, edge cases)
└── decisions/                  # WHY we chose (ADRs)
```

**Key principle:** Separate WHAT from HOW from WHERE from WHY.

---

## STEP 0: DISCOVER ALL KNOWLEDGE SOURCES

Before scanning any code, build a complete map of documentation sources.

### 0.1 Read Workspace Navigation Files

```
MUST READ FIRST:
├── CLAUDE.md                    # Master navigation hub
├── PLANNING.md                  # Development philosophy
├── CONFIG.md                    # Available commands
└── context-engineering/_STATUS.md  # Current workspace status
```

### 0.2 Inventory All Projects

List all projects in:
- `active-projects/` - Current development projects
- `experiments/` - Prototypes and POCs
- `archive/` - Completed/paused projects

For EACH project, note:
- Project path
- Tech stack (from CLAUDE.md or package manager files)
- Whether it has its own `CLAUDE.md` and `PLANNING.md`

### 0.3 Map ALL Documentation Sources

Build a complete inventory of knowledge sources:

```
DOCUMENTATION MAP:
├── Project-Specific Docs:
│   └── active-projects/{project}/
│       ├── CLAUDE.md              # Coding standards
│       ├── PLANNING.md            # Architecture decisions
│       └── README.md              # Project overview
│
├── Shared Documentation:
│   └── shared/docs/              # Workspace-level docs
│
├── Completed PRPs:
│   └── context-engineering/PRPs/
│       ├── {feature}.md           # Simple PRPs
│       └── {FEATURE}/             # Phased PRPs
│           ├── OVERVIEW.md
│           ├── phase-*/HANDOFF.md
│           └── _STATUS.md
│
├── Archived Feature Inputs:
│   └── context-engineering/archive/feature-inputs/
│
└── Existing Knowledge Base:
    └── knowledge-base/
```

### 0.4 Output Discovery Report

```
========================================
KNOWLEDGE SOURCES DISCOVERED
========================================

Projects found: {count}
{For each: - {path} ({tech stack})}

Documentation sources:
- Project CLAUDE.md files: {count}
- Project PLANNING.md files: {count}
- Shared docs folders: {count}
- Completed PRPs: {count}
- Archived feature inputs: {count}

Existing KB state:
- Concepts: {count}
- Flows: {count}
- Implementations: {count}
- Gotchas: {count}
- Decisions: {count}

========================================
```

---

## STEP 1: CHECK EXISTING KNOWLEDGE BASE

### 1.1 Read Current INDEX.md

Read `knowledge-base/INDEX.md` to understand current state.

### 1.2 Build "Already Documented" List

For each section, list existing topics:

**Concepts:** Read `knowledge-base/concepts/*.md`
**Flows:** Read `knowledge-base/flows/*.md`
**Implementations:** Read `knowledge-base/implementations/{project}/*.md`
**Gotchas:** Read `knowledge-base/gotchas/*.md`
**Decisions:** Read `knowledge-base/decisions/*.md`

For each topic file, note: topic name, category, projects it covers, source PRPs, last updated date.

### 1.3 Output Current State

```
========================================
EXISTING KNOWLEDGE BASE STATE
========================================

Concepts: {count}
{For each: - {name}: {first sentence}}

Flows: {count}
{For each: - {name}: {first sentence}}

Implementations:
{For each project: - {project-name}: {count} topics}

Gotchas: {count}
{For each: - {name} [{severity}]}

Decisions: {count}
{For each: - ADR-{number}: {title}}

========================================
```

---

## STEP 2: IDENTIFY GAPS

Compare discovered sources against existing KB.

### 2.1 Categorize Each Discovery

| Knowledge Type | Goes To | Example |
|----------------|---------|---------|
| What something IS (definition, schema, rules) | `concepts/` | "What is a user?" |
| HOW a process works (steps, sequence) | `flows/` | "How does authentication work?" |
| Project-specific patterns | `implementations/{project}/` | "How to write API routes" |
| Warnings and pitfalls | `gotchas/` | "Caching issue with X" |
| Why a decision was made | `decisions/` | "Why we chose X over Y" |

### 2.2 Check for Gaps

For each categorized item:
1. Does a topic already exist that covers this?
2. If yes, is the existing topic up-to-date?
3. If no, mark as "needs new topic"

### 2.3 Output Gap Analysis

```
========================================
GAP ANALYSIS
========================================

NEW CONCEPTS NEEDED: {count}
NEW FLOWS NEEDED: {count}
NEW IMPLEMENTATIONS NEEDED: {count}
NEW GOTCHAS NEEDED: {count}
NEW DECISIONS NEEDED: {count}
UPDATES NEEDED: {count}

========================================
```

---

## STEP 3: PLAN DOCUMENTATION WORK

### 3.1 Group by Section

Organize gaps by target section.

### 3.2 Prioritize

Order by:
1. Core concepts with no documentation (HIGH)
2. Important flows (HIGH)
3. High-severity gotchas (HIGH)
4. Implementation patterns (MEDIUM)
5. Minor updates (LOW)

### 3.3 Confirm Before Proceeding

Output the plan and proceed unless it seems wrong.

---

## STEP 4: GATHER AND VERIFY INFORMATION

For EACH topic to create/update:

### 4.1 Collect ALL Sources

Gather from multiple sources:
- PRP files (OVERVIEW.md, HANDOFF.md, FIXES.md)
- Project CLAUDE.md and PLANNING.md
- Shared docs
- Actual code (migrations, types, implementations)

### 4.2 VERIFY Against Code

**CRITICAL: Every claim must be verified against actual code.**

For each piece of information:
1. Find the source file in the codebase
2. Read the relevant code
3. For data model claims: check migration/schema files AND type definitions
4. For file paths: verify the file exists
5. For API routes: verify the route file exists

### 4.3 Resolve Conflicts

If documentation says X but code says Y:
- **Code wins** - Use what the code actually does
- Note the discrepancy in gotchas if significant

### 4.4 Cross-Reference Related Topics

For each topic:
- Identify related topics across ALL sections
- Add cross-references in `## Related` section

---

## STEP 5: WRITE TOPIC FILES

### 5.1 Use Correct Template

| Section | Template |
|---------|----------|
| concepts/ | `_TEMPLATES/concept-template.md` |
| flows/ | `_TEMPLATES/flow-template.md` |
| implementations/ | `_TEMPLATES/implementation-template.md` |
| gotchas/ | `_TEMPLATES/gotcha-template.md` |
| decisions/ | `_TEMPLATES/decision-template.md` |

### 5.2 Writing Guidelines

**Concepts (WHAT):** Focus on definitions, schema, rules, constraints.
**Flows (HOW):** Focus on process sequence. Include ASCII flow diagrams.
**Implementations (WHERE):** Focus on project-specific patterns. Include actual file paths.
**Gotchas (WARNINGS):** Be specific. Document root cause. Rate severity.
**Decisions (WHY):** Follow ADR format. Document alternatives. Explain consequences.

### 5.3 File Naming

- Use kebab-case: `feature-name.md`
- Name by CONCEPT, not by PRP name
- Good: `authentication.md`, `order-lifecycle.md`
- Bad: `GROUP-REGISTRATION-FEATURE.md`, `phase-3-work.md`

---

## STEP 6: REGENERATE INDEXES

### 6.1 Regenerate _SUMMARY.md Files

For each section: count topic files, find most recent date, rebuild topic table.

### 6.2 Regenerate INDEX.md

Count all topics across all sections. Rebuild the main index.

### 6.3 Verify Counts

Confirm:
- Total topics count matches actual files
- Each section count matches actual files
- No orphaned or phantom topics

---

## STEP 7: FINAL REPORT

```
========================================
KNOWLEDGE BASE POPULATION COMPLETE
========================================

Sources scanned:
- Projects: {count}
- PRPs: {count}
- Shared docs: {count}
- Code files verified: {count}

Topics created:
- Concepts: {count}
- Flows: {count}
- Implementations: {count}
- Gotchas: {count}
- Decisions: {count}

Topics updated: {count}
Topics unchanged: {count}

Final KB state:
- Total topics: {count}

Indexes regenerated: Yes

========================================
VERIFICATION SUMMARY
========================================

All claims verified against:
- Schema/migration files: {count} checked
- Type definitions: {count} checked
- Source files: {count} checked
- API routes: {count} checked

Discrepancies found: {count}

========================================
```

---

## CRITICAL RULES

1. **NEVER write unverified information** - Every claim must be checked against actual code
2. **NEVER duplicate content across sections** - Concepts define WHAT, flows describe HOW, implementations show WHERE
3. **NEVER remove existing KB content** - Only append or update
4. **ALWAYS verify file paths exist** - Don't list files that don't exist
5. **ALWAYS cite sources** - Include PRP names, file paths
6. **ALWAYS add cross-references** - Link related topics across sections
7. **ALWAYS run index rebuild** - Keep INDEX.md and _SUMMARY.md in sync

---

## SAFETY RULES

- **NEVER** delete existing topic files
- **NEVER** delete content from existing topics
- **NEVER** modify source documents (PRPs, PLANNING.md, etc.)
- **NEVER** write information you cannot verify in code
- **ALWAYS** backup mental model of what exists before making changes
