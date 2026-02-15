# Check PRP

## PRP Path: $ARGUMENTS

Validate a generated PRP structure against its source requirements document. Run this after `/generate-prp` completes to ensure the PRP is complete and aligned with requirements.

**PURPOSE:** Catch gaps, missing sections, and misalignments BEFORE execution begins.

---

## STEP 1: DETERMINE PRP TYPE

### 1.1 Locate the PRP

Check if `$ARGUMENTS` is:
- A **file** (simple PRP): `context-engineering/PRPs/{feature-name}.md`
- A **folder** (phased PRP): `context-engineering/PRPs/{FEATURE-NAME}/`

### 1.2 Identify Requirements Document

For phased PRPs:
- Read `_STATUS.md` or `OVERVIEW.md` to find the `Source Document` field
- The requirements document should be at: `context-engineering/{FEATURE-NAME}.md`

For simple PRPs:
- Look for a `Source Document` or `Requirements` field in the PRP file header
- Or match the PRP name to a requirements doc: `context-engineering/{feature-name}.md`

### 1.3 Read Requirements Document

Read the ENTIRE requirements document to understand:
- Total scope of the feature
- All phases/stages defined
- Data model changes required
- Success criteria
- Edge cases documented

---

## STEP 2: STRUCTURAL VALIDATION (Phased PRPs)

### 2.1 Required Root Files

Check that these files exist in the PRP folder:

| File | Status | Notes |
|------|--------|-------|
| `_STATUS.md` | -- | Must point to current phase |
| `OVERVIEW.md` | -- | Must summarize feature |

### 2.2 Phase Folder Structure

For EACH phase folder (`phase-{N}-{name}/`), verify these files exist:

| File | Purpose | Must Have |
|------|---------|-----------|
| `PLAN.md` | Implementation tasks | Tasks, file paths, code patterns |
| `COMPLETED.md` | Work log | Can be empty template |
| `FIXES.md` | Bug tracking | Can be empty template |
| `HANDOFF.md` | Context transfer | Can be empty template |

### 2.3 Report Missing Files

```
========================================
STRUCTURAL VALIDATION
========================================

Root Files:
- _STATUS.md exists
- OVERVIEW.md exists

Phase Folders Found: {N}

Phase 0 - {name}:
- PLAN.md
- COMPLETED.md
- FIXES.md
- HANDOFF.md

Phase 1 - {name}:
- PLAN.md
- COMPLETED.md (MISSING)
...

Issues Found: {count}
```

---

## STEP 3: CONTENT VALIDATION

### 3.1 _STATUS.md Checks

Verify:
- [ ] `Current Phase` field is set
- [ ] `Source Document` points to valid file
- [ ] Quick Status list includes ALL phases
- [ ] "For New Agent Session" section has reading order

### 3.2 OVERVIEW.md Checks

Verify these sections exist and are filled:
- [ ] Safety Rules section
- [ ] Feature Summary (not placeholder text)
- [ ] Implementation Phases table
- [ ] Key Decisions table
- [ ] Data Model Changes Summary
- [ ] Required Reading list
- [ ] Overall Success Criteria

### 3.3 PLAN.md Checks (for each phase)

Verify each PLAN.md has:
- [ ] Status field (Not Started/In Progress/Complete)
- [ ] Risk Level (Low/Medium/High)
- [ ] Estimated Sessions
- [ ] Depends On field
- [ ] Overview section
- [ ] Pre-requisites checklist
- [ ] Required Reading section
- [ ] At least ONE task defined
- [ ] Each task has:
  - [ ] Files to modify
  - [ ] What to do steps
  - [ ] Code pattern/reference (preferred)
  - [ ] Expected outcome
- [ ] Validation Commands section
- [ ] Acceptance Criteria checklist

---

## STEP 4: REQUIREMENTS ALIGNMENT

### 4.1 Extract Requirements Sections

From the requirements document, extract:
1. All defined phases/stages
2. All data model changes mentioned
3. All files that should be modified
4. All success criteria
5. All edge cases
6. All key decisions

### 4.2 Cross-Reference with PRP

For EACH item from requirements, check if it's covered in the PRP:

```
========================================
REQUIREMENTS ALIGNMENT CHECK
========================================

PHASES COVERAGE:
Requirements defines {N} phases:
- Phase 0: Foundation - Covered in phase-0-foundation/
- Phase 1: UI Updates - Covered in phase-1-ui/
- Phase 2: Testing - NOT FOUND IN PRP

DATA MODEL CHANGES:
Requirements mentions these changes:
- Add column `status` - Phase 0, Task 1
- Create table `participants` - Phase 0, Task 2
- Add index on `foreign_key` - NOT FOUND IN ANY PLAN

FILE MODIFICATIONS:
Requirements references these files:
- src/components/forms/main-form.tsx - Phase 3, Task 2
- src/lib/utils.ts - NOT FOUND IN ANY PLAN

SUCCESS CRITERIA:
- "Users can create records" - Phase 1 Acceptance
- "Dashboard shows analytics" - NOT FOUND IN ANY PHASE

KEY DECISIONS:
- "Use approach A over B" - Documented in OVERVIEW.md
```

### 4.3 Check for Orphaned PRP Content

Also check if PRP includes things NOT in requirements:
- Are there tasks that don't map back to requirements?
- Are there phases that weren't defined in requirements?
- Flag these as potential scope creep

---

## STEP 5: QUALITY CHECKS

### 5.1 File Path Verification

For each file path mentioned in PLAN.md tasks:
- Check if the file actually exists in the codebase
- Report any invalid paths

```
FILE PATH VALIDATION:
- src/components/forms/main-form.tsx - EXISTS
- src/components/forms/new-component.tsx - DOES NOT EXIST (will be created)
- src/lib/missing-util.ts - DOES NOT EXIST (not marked as CREATE)
```

### 5.2 Code Pattern Quality

Check if code patterns in PLAN.md:
- Reference actual existing files (not invented)
- Include line numbers where possible
- Are realistic and match codebase style

### 5.3 Validation Commands Check

Verify validation commands are:
- Appropriate for the project
- Include build check
- Include lint check
- Include any project-specific tests

---

## STEP 6: GENERATE REPORT

### 6.1 Summary Report

```
========================================
PRP VALIDATION REPORT
========================================

PRP: {path}
Type: {Simple | Phased}
Source: {requirements file}
Generated: {date from OVERVIEW.md}

========================================
STRUCTURAL VALIDATION
========================================
Status: PASS | FAIL

Root Files: {X}/{Y} present
Phase Folders: {N}
Files per Phase: {checked}/{expected}

Issues:
- {list any missing files}

========================================
CONTENT VALIDATION
========================================
Status: PASS | FAIL

_STATUS.md: {complete/incomplete}
OVERVIEW.md: {X}/{Y} sections filled
PLAN.md files: {X}/{Y} have required sections

Issues:
- {list any missing sections}

========================================
REQUIREMENTS ALIGNMENT
========================================
Status: ALIGNED | GAPS FOUND | MAJOR GAPS

Phases: {X}/{Y} covered
Data Model Changes: {X}/{Y} covered
File Modifications: {X}/{Y} covered
Success Criteria: {X}/{Y} covered
Key Decisions: {X}/{Y} documented

Gaps Found:
- {list uncovered requirements}

Potential Scope Creep:
- {list PRP items not in requirements}

========================================
QUALITY CHECKS
========================================
Status: PASS | WARNINGS | FAIL

File Paths: {X}/{Y} verified
Code Patterns: {quality assessment}
Validation Commands: {present/missing}

Issues:
- {list any problems}

========================================
OVERALL ASSESSMENT
========================================

Score: {1-10}/10

Recommendation:
- READY FOR EXECUTION - PRP is complete and aligned
- MINOR FIXES NEEDED - Fix issues before executing
- REGENERATE PRP - Major gaps require re-running /generate-prp

{If issues found:}
Action Items:
1. {specific fix needed}
2. {specific fix needed}
...

========================================
Next Step: /execute-prp {path}
========================================
```

---

## STEP 7: AUTOMATED FIXES (Optional)

### 7.1 If Minor Issues Found

Offer to fix minor issues automatically:
- Missing empty template files (COMPLETED.md, FIXES.md, HANDOFF.md)
- Missing sections in _STATUS.md
- Missing validation commands

Ask user: "I found {N} minor issues. Would you like me to fix them automatically?"

### 7.2 If Major Issues Found

Do NOT auto-fix. Instead:
1. List all gaps clearly
2. Recommend re-running `/generate-prp` with more thorough research
3. Or recommend manual updates to specific PLAN.md files

---

## CRITICAL REMINDERS

1. **READ REQUIREMENTS FIRST** - Can't validate alignment without understanding requirements
2. **CHECK EVERY PHASE** - Don't skip phases, even if they seem similar
3. **VERIFY FILE PATHS** - Invalid paths cause execution failures
4. **REPORT HONESTLY** - Don't inflate scores, be truthful about gaps
5. **ACTIONABLE OUTPUT** - Every issue should have a clear fix recommendation

---

## QUICK CHECKLIST (For Agent Reference)

```
[] Located PRP and determined type (simple/phased)
[] Found and read source requirements document
[] Verified all required files exist
[] Checked _STATUS.md content
[] Checked OVERVIEW.md content
[] Checked each PLAN.md has required sections
[] Extracted all requirements items
[] Cross-referenced each requirement with PRP
[] Verified file paths exist in codebase
[] Assessed code pattern quality
[] Generated comprehensive report
[] Provided actionable recommendations
```
