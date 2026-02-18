# Generate PRP

## Requirements File: $ARGUMENTS

Generate a complete, implementation-ready PRP from a requirements document.

**CRITICAL ORDER:** You MUST complete all research and validation BEFORE creating any PRP files. The requirements document may contain discussions, decisions, and planning notes that need thorough analysis first.

---

## STEP 1: READ AND UNDERSTAND REQUIREMENTS

### 1.1 Read the Entire Document

- Read `$ARGUMENTS` completely from start to finish
- Do NOT skim - read every section carefully
- Understand the full scope of the feature

### 1.2 Move Feature Input to In-Progress

If the feature input is in `context-engineering/feature-inputs/pending/`, move it to `in-progress/`:
```bash
mv context-engineering/feature-inputs/pending/{FEATURE-NAME}.md context-engineering/feature-inputs/in-progress/
```

### 1.3 Extract Key Information

While reading, identify:

- What is the feature?
- What are the phases/stages (if defined)?
- What data model changes are needed?
- What files will be modified?
- What decisions have been made?
- What are the success criteria?
- What edge cases are documented?

---

## STEP 2: VALIDATE THE REQUIREMENTS

### 2.1 Check for Conflicts

- Are there contradicting decisions in different sections?
- Do all the pieces fit together logically?
- Are data model schemas consistent throughout?

### 2.2 Check for Completeness

- Are all edge cases covered?
- Are all user flows complete?
- Are there missing implementation details?

### 2.3 Check for Clarity

- Are the requirements clear enough to implement?
- Do you understand what each component should accomplish?
- Can you identify the file paths and code patterns needed?

### 2.4 If Issues Found

**STOP and ask the user for clarification before proceeding.**
Do NOT create the PRP with ambiguous or conflicting requirements.

---

## STEP 3: CODEBASE RESEARCH

### 3.1 Find Relevant Files

For each component mentioned in requirements:

- Search for the actual file paths in the codebase
- Read key files to understand current implementation
- Identify patterns to follow

### 3.2 Identify Code Patterns

- How are similar features implemented?
- What conventions exist in the codebase?
- What validation/error handling patterns are used?
- What test patterns exist?

### 3.2.5 Search Knowledge Base

Before diving deeper into raw codebase files, check the knowledge base for existing context:

1. Read `knowledge-base/INDEX.md` to find relevant topics for this feature
2. Read `_SUMMARY.md` for each relevant section (concepts, flows, implementations, gotchas, decisions)
3. Read specific topic files that relate to the feature being planned

**What you're looking for:**
- **Concepts** - What entities/schemas this feature uses
- **Flows** - What processes this feature participates in or depends on
- **Implementations** - What project-specific patterns to follow
- **Gotchas** - Known pitfalls to avoid in this area
- **Decisions** - Why certain approaches were chosen (follow existing patterns)

**CRITICAL: Fill the "Knowledge Base References" section in the PRP**

Both PRP templates now have a "Knowledge Base References" section. You MUST fill it with relevant topics:

```yaml
# Knowledge Base References
concepts:
  - [entity-name.md] # Feature creates/modifies this entity

flows:
  - [process-name.md] # Feature affects this process flow

implementations:
  - [patterns.md] # Feature follows these patterns

gotchas:
  - [known-issue.md] # Feature must avoid this pitfall

decisions:
  - [005-architecture-choice.md] # Feature follows this decision
```

**How to fill it:**
- **Only include topics directly relevant to implementation**
- **Prioritize gotchas** - if there's a known pitfall, always reference it
- **Add brief comments** explaining why each topic is relevant
- **Don't over-reference** - only include what the implementing agent needs to read

This ensures implementing agents have instant access to relevant historical context and don't repeat past mistakes.

### 3.3 Document Your Findings

Note down:

- Specific file paths with line numbers
- Code snippets showing patterns to follow
- Gotchas or pitfalls discovered
- Integration points

---

## STEP 4: EXTERNAL RESEARCH (If Needed)

### 4.1 Library Documentation

If requirements mention libraries or APIs:

- Find official documentation URLs
- Identify relevant sections
- Note version considerations

### 4.2 Best Practices

- Search for implementation examples
- Note common pitfalls
- Find relevant tutorials or guides

The agent has Websearch capabilities - include URLs to documentation and examples.

---

## STEP 5: ULTRATHINK - PLAN YOUR APPROACH

Before creating any files, think deeply:

1. **What type of PRP is needed?**

   **Simple Feature** → Use `context-engineering/PRPs/templates/prp_base.md`

   - Can be done in 1-2 sessions
   - Less than 10 distinct tasks
   - Low risk, straightforward implementation
   - **Output:** Single file `context-engineering/PRPs/{feature-name}.md`

   **Complex/Phased Feature** → Use `context-engineering/PRPs/templates/prp_complex.md`

   - Has multiple distinct phases (look for "Phase" sections in requirements)
   - Will take 3+ sessions
   - Multiple components depend on each other
   - **Output:** Folder structure `context-engineering/PRPs/{FEATURE-NAME}/`

2. **What context does the implementing agent need?**
   - Which files must they read?
   - What decisions were made and why?
   - What patterns must they follow?

---

## STEP 6: CREATE THE PRP

### For Simple Features

1. Read template: `context-engineering/PRPs/templates/prp_base.md`
2. Fill in all sections with your research findings
3. **Add a status header block** at the very top of the PRP file (before the title):
   ```markdown
   **Status:** Not Started
   **Feature Input:** context-engineering/feature-inputs/in-progress/{feature-name}.md
   **Last Updated:** {today's date}

   ---

   # PRP: {Feature Title}
   ...
   ```
   This status header enables `/audit-context` to track simple PRPs alongside phased PRPs.
4. Include actual code snippets from codebase
5. Include context files to read:
   - `CLAUDE.md` (root) - Project navigation, workflow, and coding standards
   - `PLANNING.md` (root) - Architecture and development philosophy
   - `context-engineering/_STATUS.md` - Current project status and in-progress work
6. Include validation commands from project CLAUDE.md (build, lint, test commands)
7. **Add inline test cases section** to the PRP file:
   a. Read the project's CLAUDE.md for the validation method
   b. Follow the "Test Cases" format from `prp_base.md` template
   c. Generate concrete test cases with validation steps
   d. Same coverage rules as phased PRPs: happy path, edge cases, protection, regression
8. Save as: `context-engineering/PRPs/{feature-name}.md`

### For Complex/Phased Features

1. Read template: `context-engineering/PRPs/templates/prp_complex.md`
2. Follow the folder structure defined in template
3. Create ALL folders and files upfront:
   ```
   context-engineering/PRPs/{FEATURE-NAME}/
   ├── _STATUS.md
   ├── OVERVIEW.md
   ├── phase-0-{name}/
   │   ├── PLAN.md
   │   ├── TEST-CASES.md
   │   ├── COMPLETED.md
   │   ├── FIXES.md
   │   └── HANDOFF.md
   ├── phase-1-{name}/
   │   └── ... (same 5 files)
   └── phase-N-{name}/
       └── ... (same 5 files)
   ```
4. Fill `_STATUS.md` - pointing to Phase 0
5. Fill `OVERVIEW.md` - complete feature summary from requirements
6. Fill EACH phase `PLAN.md` with:
   - Detailed tasks extracted from requirements
   - Actual file paths from your codebase research
   - Code patterns you found (with snippets)
   - Validation commands
   - Acceptance criteria
7. Create empty templates for `COMPLETED.md`, `FIXES.md`, `HANDOFF.md` (as shown in prp_complex.md)
8. **Generate TEST-CASES.md for each phase:**
   a. Read the phase's PLAN.md tasks and acceptance criteria
   b. Read the requirements document's "Test Scenarios" section (if available from `/generate-requirements`)
   c. Read the project's CLAUDE.md for the validation method:
      - Find the "Testing & Debugging" or "Validation" section
      - Note any project-specific testing tools or commands
   d. Generate test cases following `context-engineering/PRPs/templates/test_cases_template.md`:
      - Fill the "Testing Approach" section with the project's specific validation tools
      - Group test cases into logical sections (A, B, C...) by feature area
      - Each test case must have: Steps, Expected, Validation, Status
      - Include pre-requisites (what must be true before testing)
      - Include Test Execution Tracker table at the bottom
   e. Test cases should cover:
      - **Happy path** — Each task's expected outcome verified
      - **Edge cases** — Boundary conditions, empty states, max limits, null values
      - **Protection/validation** — Blocked actions, error messages, access control
      - **Regression** — Existing functionality that must still work after changes
   f. Aim for 5-30 test cases per phase depending on risk level:
      - Low-risk phases: 5-10 cases
      - Medium-risk phases: 10-20 cases
      - High-risk phases: 15-30 cases

---

## STEP 7: QUALITY VERIFICATION

Before finishing, verify:

- [ ] Requirements were fully read and understood
- [ ] No conflicts or ambiguities remain (or user was asked)
- [ ] Codebase research completed thoroughly
- [ ] All file paths are verified to exist in codebase
- [ ] Code patterns are from actual codebase (not invented)
- [ ] **Knowledge Base References section is filled with relevant topics**
- [ ] Each PLAN.md is detailed enough for implementation without original requirements
- [ ] Phase dependencies are clear (for phased PRPs)
- [ ] Validation commands will work
- [ ] Context files are referenced
- [ ] **TEST-CASES.md generated for each phase** (phased) or inline test section (simple)
- [ ] **Each test case has concrete validation steps** (not placeholder)
- [ ] **Testing Approach section filled** with project-specific validation method from CLAUDE.md

---

## STEP 8: UPDATE PROJECT STATUS

After creating the PRP, update `context-engineering/_STATUS.md`:

1. Read the current `_STATUS.md`
2. Add this feature to the "In Progress" section with link to the PRP
3. Update the "Pending Features" section if needed

Example update:
```markdown
## In Progress

### {Feature Name}
**PRP:** `context-engineering/PRPs/{feature-name}.md` (or folder path)
- PRP created, ready for implementation
```

---

## STEP 9: OUTPUT SUMMARY

After completion, provide:

```
========================================
PRP GENERATED SUCCESSFULLY
========================================

Source: {requirements file path}
Type: {Simple | Complex/Phased}
Output: {output path}

{For phased PRPs:}
Total Phases: {N}
Phase Overview:
- Phase 0: {name} - {risk level}
- Phase 1: {name} - {risk level}
...

Research Summary:
- Files analyzed: {count}
- Patterns identified: {count}
- External docs referenced: {count}
- Test cases generated: {total across all phases}

Confidence Score: {1-10}/10
(confidence for one-pass implementation success)

========================================
To execute: /execute-prp {output path}
========================================
```

---

## CRITICAL REMINDERS

1. **READ FIRST** - Complete requirements reading before any PRP creation
2. **VALIDATE** - Catch issues early, ask user if anything is unclear
3. **RESEARCH** - Implementation fails without proper codebase context
4. **REAL CODE** - Include actual snippets from codebase, not invented examples
5. **VERIFY PATHS** - All file paths referenced must exist
6. **ULTRATHINK** - Plan your approach thoroughly before writing

**The Goal:** An agent with ONLY the generated PRP can implement the feature successfully, without access to the original requirements document.

---

## SAFETY RULES TO INCLUDE IN ALL PRPs

When generating PRPs, ALWAYS include these safety rules in the OVERVIEW.md (for phased PRPs) or in the main PRP file (for simple PRPs):

```markdown
## CRITICAL SAFETY RULES

### 1. Follow Project Safety Rules
- Read the project's `CLAUDE.md` for safety rules and coding standards
- Follow all environment-specific constraints (local vs production, etc.)

### 2. NO GIT COMMITS
- **NEVER** commit code to GitHub during implementation
- The user will handle all git operations manually

### 3. NO PRODUCTION DEPLOYMENTS
- Do NOT run any deployment commands
```
