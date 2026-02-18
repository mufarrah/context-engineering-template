# Update Knowledge Base

## Source: $ARGUMENTS

Update the knowledge base from a PRP or from the current conversation context.

**PURPOSE:** Extract key decisions, architectural patterns, gotchas, and changes into the knowledge base so future agents have instant access.

**TWO MODES:**
- **With PRP path:** Extract from that specific PRP file/folder
- **Without argument:** Extract from the current conversation context

**WHEN TO USE:**
- After completing a PRP (`/update-knowledge-base context-engineering/PRPs/FEATURE-NAME`)
- After making code changes without a PRP (`/update-knowledge-base`)
- After fixing bugs, refactoring, or any work worth documenting (`/update-knowledge-base`)
- When backfilling knowledge from historical PRPs

---

## KNOWLEDGE BASE STRUCTURE

The knowledge base uses a **concept-centric** architecture:

```
knowledge-base/
├── INDEX.md                    # Master navigation (regenerated)
├── concepts/                   # WHAT things are
│   └── _SUMMARY.md
├── flows/                      # HOW things work
│   └── _SUMMARY.md
├── implementations/            # WHERE code lives
│   ├── _SUMMARY.md
│   └── {project-name}/        # Per-project patterns
│       └── _SUMMARY.md
├── gotchas/                    # WARNINGS
│   └── _SUMMARY.md
└── decisions/                  # WHY we chose (ADRs)
    └── _SUMMARY.md
```

**Key principle:** Separate WHAT from HOW from WHERE from WHY.

---

## STEP 0: DETERMINE SOURCE MODE

Check if `$ARGUMENTS` is provided:

### MODE A: PRP Path Provided
If argument looks like a path (contains `/` or ends with `.md`):
- Source = The specified PRP
- Go to **STEP 1A: READ THE PRP**

### MODE B: No Argument (Context Mode)
If no argument or argument is empty:
- Source = Current conversation context
- Go to **STEP 1B: EXTRACT FROM CONTEXT**

---

## STEP 1A: READ THE PRP

**(Only for MODE A - PRP path provided)**

### For Simple PRPs (single file):
- Read the entire PRP file

### For Phased PRPs (folder):
- Read `OVERVIEW.md` for feature summary and key decisions
- Read `HANDOFF.md` from ALL completed phases (start from phase-0, work forward)
- Read `FIXES.md` from phases that had significant fixes
- Read `_STATUS.md` for current state

### Extract Raw Knowledge from the PRP:

Gather ALL significant knowledge without categorizing yet. A single feature often produces knowledge that spans multiple categories.

1. **What was built** - Feature summary and purpose
2. **What entities/schemas were created or changed** - New models, columns, relationships, business rules, valid states
3. **What processes were established or changed** - Multi-step workflows, data flow sequences, state transitions
4. **What files/patterns were created** - File organization, reusable components, code patterns, anti-patterns discovered
5. **What surprised you or broke** - Bugs encountered, edge cases, non-obvious behavior, things that didn't work as expected
6. **What choices were made and why** - Approach chosen over alternatives, trade-offs, architectural reasoning

**NOTE:** Do not skip items 2-6 just because item 5 has obvious entries. Every feature touches multiple areas.

→ Continue to **STEP 2**

---

## STEP 1B: EXTRACT FROM CONTEXT

**(Only for MODE B - no argument)**

Review the current conversation and extract ALL raw knowledge.

### 1B.1 What Changed?
- Files created or modified
- Data model changes (migrations, schemas)
- API routes added/changed
- UI components added/changed

### 1B.2 What Entities/Schemas Were Introduced or Changed?
- New models, columns, relationships
- New business rules or constraints
- New valid states, statuses, or types

### 1B.3 What Processes Were Established or Changed?
- New multi-step workflows
- New data flow paths between components
- State transitions or sequences

### 1B.4 What Patterns Were Used or Established?
- New code patterns or conventions
- File organization choices
- Reusable components or utilities created
- Anti-patterns discovered (things NOT to do)

### 1B.5 What Surprised You or Broke?
- Bugs encountered and their root causes
- Edge cases found
- Things that didn't work as expected
- Warnings for future developers

### 1B.6 What Choices Were Made?
- Why was this approach chosen?
- What alternatives were considered?
- Any trade-offs made?

### 1B.7 Verify Against Code
For each piece of information:
1. Confirm the file exists at the stated path
2. For data model claims: check migration/schema files
3. For API routes: verify the route exists

### 1B.8 Summarize for Documentation
Prepare:
- **What was done** (1-2 sentence summary)
- **Files affected** (with paths)
- **Raw knowledge gathered** (from 1B.2 through 1B.6 — all categories)
- **Source reference** = "Conversation context: {brief description}"

→ Continue to **STEP 2**

---

## STEP 2: CATEGORIZE THE KNOWLEDGE

### 2.0 Mandatory 5-Question Gate (DO NOT SKIP)

Before categorizing, you MUST answer ALL 5 questions below. Answer each honestly — "None" is valid.

**Write out your answers before proceeding:**

> **Q1 — CONCEPT:** Did this work introduce or change any entity definitions, schemas, business rules, valid states, or entity relationships?
> → Answer: {yes/no + brief description, or "None"}
>
> **Q2 — FLOW:** Did this work create or modify any multi-step processes, data flow paths, state transitions, or sequences?
> → Answer: {yes/no + brief description, or "None"}
>
> **Q3 — IMPLEMENTATION:** Did this work establish project-specific code patterns, file organization conventions, reusable components, or anti-patterns to avoid?
> → Answer: {yes/no + brief description, or "None"}
>
> **Q4 — GOTCHA:** Did anything surprising happen? Bugs, edge cases, non-obvious behavior, things that broke unexpectedly?
> → Answer: {yes/no + brief description, or "None"}
>
> **Q5 — DECISION:** Were there significant choices between alternative approaches? Trade-offs made? Architectural reasoning worth preserving?
> → Answer: {yes/no + brief description, or "None"}

**If ALL 5 answers are "None":** This work does not warrant a knowledge base update. Skip Steps 3-4, proceed to Step 5 (project docs check), and report: "Knowledge base: No new knowledge to document."

**If ANY answer is "yes":** Create/update topic files for EVERY "yes" answer.

---

### 2.1 Category Reference Table

| Knowledge Type | Goes To | Example |
|----------------|---------|---------|
| What something IS (definition, schema, rules, constraints) | `concepts/` | "What is a user?" |
| HOW a process works (steps, sequence, data flow) | `flows/` | "How does checkout work?" |
| Project-specific patterns (code examples, file org) | `implementations/{project}/` | "How to write API routes in project-a" |
| Warnings and pitfalls (bugs, edge cases) | `gotchas/` | "Caching issue with X" |
| Why a decision was made (alternatives, trade-offs) | `decisions/` | "Why we chose X over Y" |

### 2.2 Categorization Rules:

1. **Concepts** define WHAT things are
2. **Flows** describe HOW things work
3. **Implementations** show WHERE code lives
4. **Gotchas** are WARNINGS
5. **Decisions** explain WHY

---

## STEP 3: FIND OR CREATE TOPIC FILES

For each piece of knowledge extracted:

### 3.1 Check for Existing Topic

Read the relevant section's `_SUMMARY.md` to see existing topics.

If a topic exists that covers the same area → UPDATE it (Step 3.2)
If no topic exists → CREATE one (Step 3.3)

### 3.2 Update Existing Topic (MERGE)

Read the existing topic file, then apply merge rules:

**All Topics:**
- UPDATE `**Last Updated:**` to today's date
- ADD source to `**Source PRPs:**` if applicable
- APPEND to `## Changes Log` with today's date, what changed, and source

**CRITICAL:** Do NOT remove existing content. The knowledge base is additive.

### 3.3 Create New Topic

Use the appropriate template from `knowledge-base/_TEMPLATES/`:
- `concept-template.md` for concepts
- `flow-template.md` for flows
- `implementation-template.md` for implementations
- `gotcha-template.md` for gotchas
- `decision-template.md` for decisions (ADRs)

**File Naming:**
- Use kebab-case: `{descriptive-name}.md`
- Name by CONCEPT, not by PRP name
- Good: `authentication.md`, `order-lifecycle.md`, `caching-issue.md`
- Bad: `GROUP-REGISTRATION.md`, `phase-5.md`, `fix.md`

**For Decisions (ADRs):**
- Use sequential numbering: `{NNN}-{title}.md`
- Check existing decisions to find next number

---

## STEP 4: REGENERATE SUMMARIES AND INDEX

After all topic files are created/updated:

### 4.1 Regenerate Affected _SUMMARY.md Files

For EACH section that was modified:

1. Read all `.md` files in the section folder (excluding `_SUMMARY.md`)
2. For each topic file, extract: topic name, first sentence of summary, last updated, projects, severity (gotchas), status (decisions)
3. Rebuild `_SUMMARY.md` with correct counts and topic tables

### 4.2 Regenerate INDEX.md

1. Walk ALL section folders
2. For each section: count `.md` files (excluding `_SUMMARY.md`), build topic table
3. Rebuild `knowledge-base/INDEX.md` with updated counts and listings

---

## STEP 5: UPDATE PROJECT DOCUMENTATION

After updating the knowledge base, also update the relevant **project-specific** `CLAUDE.md` and `PLANNING.md` files.

### 5.1 Identify Affected Project(s)

From the PRP or conversation context, determine which project(s) in `active-projects/` were modified.

### 5.2 Extract Project Doc Updates

| Knowledge Type | Goes To | Examples |
|----------------|---------|----------|
| New code patterns established | Project `CLAUDE.md` | "Always use helper_function() for X" |
| File organization changes | Project `CLAUDE.md` | "Delete modals go in components/modals/" |
| New commands or utilities | Project `CLAUDE.md` | "New script: npm run sync-types" |
| Anti-patterns discovered | Project `CLAUDE.md` | "Never call X without Y" |
| Architectural decisions | Project `PLANNING.md` | "Events now sync via webhook pattern" |
| New data flows | Project `PLANNING.md` | "Record creation now triggers notification" |
| Integration points added | Project `PLANNING.md` | "New API endpoint /api/sync/report" |
| Data model changes | Project `PLANNING.md` | "Added participants table" |

### 5.3 Update Project CLAUDE.md

Read the project's `CLAUDE.md` file, then **APPEND** or **UPDATE** appropriate sections.

**Rules:**
- **APPEND** new items to existing lists/tables
- **UPDATE** existing entries if responsibilities changed
- For significant additions, add a comment: `<!-- Added from PRP: {PRP-NAME}, {date} -->`
- Keep formatting consistent with existing content

### 5.4 Update Project PLANNING.md

Read the project's `PLANNING.md` file, then **UPDATE** appropriate sections.

**Rules:**
- **UPDATE** diagrams if architecture changed
- **ADD** new entries to tables
- **APPEND** to lists (don't remove existing items)
- For significant changes, add a comment: `<!-- Updated from PRP: {PRP-NAME}, {date} -->`

### 5.5 Skip If No Significant Changes

Not every PRP requires project doc updates. Skip if:
- Changes were minor bug fixes with no new patterns
- No architectural decisions were made
- No new conventions were established

Document in the report: "Project docs: No significant changes to document"

---

## STEP 6: REPORT

```
========================================
KNOWLEDGE BASE & PROJECT DOCS UPDATED
========================================

Source: {PRP name OR "Conversation context: {description}"}

KNOWLEDGE BASE:
  Sections touched: {list of section names}
  Topics created: {count}
  {For each: - {section}/{topic-name}.md}
  Topics updated: {count}
  {For each: - {section}/{topic-name}.md (added: {what was added})}
  Index regenerated: Yes
  Summaries regenerated: {list of sections}

PROJECT DOCUMENTATION:
  Projects affected: {list}
  {For each project:}
  - {project}/CLAUDE.md: {Updated sections or "No changes needed"}
  - {project}/PLANNING.md: {Updated sections or "No changes needed"}

========================================
```

---

## CRITICAL REMINDERS

1. **CATEGORIZE CORRECTLY** - WHAT goes to concepts, HOW to flows, WHERE to implementations
2. **VERIFY AGAINST CODE** - Especially in context mode, verify files exist and claims are accurate
3. **MERGE, DON'T REPLACE** - Existing knowledge is sacred. Only append or update.
4. **NAME TOPICS BY CONCEPT** - Not by PRP name or phase number
5. **REGENERATE INDEXES** - Always regenerate _SUMMARY.md and INDEX.md after changes
6. **ONE TOPIC PER CONCEPT** - Don't create a new topic for every change. Merge related knowledge.
7. **LINK RELATED TOPICS** - Add cross-references in `## Related` sections

---

## SAFETY RULES

- **NEVER** delete existing topic files
- **NEVER** remove content from existing topics (only append/update)
- **NEVER** modify PRP files (this command writes to knowledge-base/ and project docs only)
- **NEVER** write unverified information (especially in context mode)
- **NEVER** remove existing content from project CLAUDE.md or PLANNING.md
- **ALWAYS** regenerate indexes after knowledge base changes
- **ALWAYS** use the correct template for each section type
- **ALWAYS** read project docs before updating them
