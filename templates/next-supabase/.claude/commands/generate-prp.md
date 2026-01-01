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

### 1.2 Extract Key Information

While reading, identify:

- What is the feature?
- What are the phases/stages (if defined)?
- What database changes are needed?
- What files will be modified?
- What decisions have been made?
- What are the success criteria?
- What edge cases are documented?

---

## STEP 2: VALIDATE THE REQUIREMENTS

### 2.1 Check for Conflicts

- Are there contradicting decisions in different sections?
- Do all the pieces fit together logically?
- Are database schemas consistent throughout?

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
3. Include actual code snippets from codebase
4. Include context files to read:
   - `context-engineering/CLAUDE.md` - General rules
   - `context-engineering/PLANNING.md` - Project overview
5. Include validation commands (TypeScript: `npm run build`, `npm run lint`, etc.)
6. Save as: `context-engineering/PRPs/{feature-name}.md`

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
   │   ├── COMPLETED.md
   │   ├── FIXES.md
   │   └── HANDOFF.md
   ├── phase-1-{name}/
   │   └── ... (same 4 files)
   └── phase-N-{name}/
       └── ... (same 4 files)
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

---

## STEP 7: QUALITY VERIFICATION

Before finishing, verify:

- [ ] Requirements were fully read and understood
- [ ] No conflicts or ambiguities remain (or user was asked)
- [ ] Codebase research completed thoroughly
- [ ] All file paths are verified to exist in codebase
- [ ] Code patterns are from actual codebase (not invented)
- [ ] Each PLAN.md is detailed enough for implementation without original requirements
- [ ] Phase dependencies are clear (for phased PRPs)
- [ ] Validation commands will work
- [ ] Context files are referenced

---

## STEP 8: OUTPUT SUMMARY

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

## ⚠️ SAFETY RULES TO INCLUDE IN ALL PRPs

When generating PRPs, ALWAYS include these safety rules in the OVERVIEW.md (for phased PRPs) or in the main PRP file (for simple PRPs):

```markdown
## ⚠️ CRITICAL SAFETY RULES

### 1. LOCAL DATABASE ONLY
- **ALWAYS** use `--local` flag with ALL Supabase commands
- Examples:
  - ✅ `npx supabase migration up --local`
  - ✅ `npx supabase db reset --local`
  - ❌ `npx supabase migration up` (DANGEROUS - affects production!)

### 2. NO GIT COMMITS
- **NEVER** commit code to GitHub during implementation
- The user will handle all git operations manually

### 3. NO PRODUCTION DEPLOYMENTS
- Do NOT run any deployment commands
```
