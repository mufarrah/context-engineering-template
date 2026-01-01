# Complex/Phased PRP Template

## Purpose
Template for complex features requiring multiple implementation phases. Designed for seamless context handoff between agent sessions.

## When to Use
- Feature has multiple distinct phases/stages
- Implementation will take 3+ sessions
- Feature document is > 500 lines
- Multiple components depend on each other
- Risk is high and needs incremental testing

---

## FOLDER STRUCTURE TO CREATE

```
context-engineering/PRPs/{FEATURE-NAME}/
├── _STATUS.md                    # Agent reads FIRST - current phase pointer
├── OVERVIEW.md                   # Validated requirements summary
│
├── phase-0-{name}/
│   ├── PLAN.md                   # Detailed tasks with code patterns
│   ├── COMPLETED.md              # Agent fills during execution
│   ├── FIXES.md                  # Agent fills during user testing
│   └── HANDOFF.md                # Agent fills when phase complete
│
├── phase-1-{name}/
│   └── ... (same 4 files)
│
├── phase-2-{name}/
│   └── ... (same 4 files)
│
└── phase-N-{name}/
    └── ... (same 4 files)
```

---

## FILE TEMPLATES

### _STATUS.md

```markdown
# {FEATURE-NAME}: Current Status

**Feature:** {Feature Name}
**Source Document:** {path to original requirements file}
**Current Phase:** Phase 0 - {Phase Name}
**Status:** Not Started

## Quick Status
- Phase 0: ⏳ Not Started
- Phase 1: ⏳ Pending
- Phase 2: ⏳ Pending
- Phase N: ⏳ Pending

## For New Agent Session

Read these files in order:
1. `OVERVIEW.md` - Full feature context
2. Previous phase `HANDOFF.md` (if not Phase 0)
3. Current phase `PLAN.md` - Tasks to execute
4. Current phase `FIXES.md` - Pending fixes (if any)

## Last Updated
{Date} - Initial creation from requirements
```

---

### OVERVIEW.md

```markdown
# {FEATURE-NAME}: Overview

**Source Document:** {path to original requirements file}
**Generated:** {Date}
**Total Phases:** {N}

## Feature Summary
{2-3 paragraph summary of what this feature does, extracted from requirements}

## Implementation Phases

| Phase | Name | Risk | Description |
|-------|------|------|-------------|
| 0 | {name} | {Low/Med/High} | {brief description} |
| 1 | {name} | {Low/Med/High} | {brief description} |
| N | {name} | {Low/Med/High} | {brief description} |

## Key Decisions (From Requirements)
{List all major decisions that were made during requirements planning}

| Decision | Value | Reasoning |
|----------|-------|-----------|
| {decision} | {value} | {why} |

## Database Changes Summary
- **New Tables:** {list}
- **Modified Tables:** {list}
- **New Functions:** {list}

## Required Reading (All Phases)
These files should be read before starting ANY phase:
- `context-engineering/CLAUDE.md` - General rules
- `context-engineering/PLANNING.md` - Project overview
- {Other files from requirements}

## Overall Success Criteria
- [ ] {Criteria 1}
- [ ] {Criteria 2}
- [ ] All phases complete and verified
- [ ] No regressions in existing functionality

## Reference
For full details, see original requirements: `{path to requirements file}`
```

---

### phase-{N}-{name}/PLAN.md

```markdown
# Phase {N}: {Phase Name}

**Status:** Not Started
**Risk Level:** {Low/Medium/High}
**Estimated Sessions:** {1-2}
**Depends On:** {Phase N-1 or "None"}

## Overview
{What this phase accomplishes - 1-2 paragraphs}

## Pre-requisites
- [ ] {Previous phase complete, if applicable}
- [ ] {Other prerequisites}

## Required Reading
Before starting this phase, read:
- `../OVERVIEW.md` - Feature context
- `../phase-{N-1}-xxx/HANDOFF.md` - Previous phase summary (if not Phase 0)
- {Specific codebase files with line numbers}

## Tasks

### Task 1: {Task Name}

**Files to modify:**
- `src/path/to/file.ts`

**What to do:**
1. {Step 1}
2. {Step 2}
3. {Step 3}

**Code pattern to follow:**
```typescript
// Reference: src/similar/file.ts:42-60
// Copy this pattern:
{actual code snippet from codebase}
```

**Expected outcome:**
{What should be true when this task is done}

---

### Task 2: {Task Name}

**Files to modify:**
- `src/path/to/file.ts`

**What to do:**
1. {Step 1}
2. {Step 2}

**Code pattern to follow:**
```typescript
// Reference: {file path}
{code snippet}
```

---

### Task N: {Task Name}
...

## Validation Commands
```bash
# Run these to verify the phase works
npm run build          # Must pass
npm run lint           # Must pass
npm run test           # Must pass
{specific test commands}
```

## Acceptance Criteria
- [ ] All tasks complete
- [ ] Build passes
- [ ] No lint errors
- [ ] Existing functionality still works
- [ ] {Phase-specific criteria}

## Notes
{Any additional notes, gotchas, or warnings for this phase}
```

---

### phase-{N}-{name}/COMPLETED.md

```markdown
# Phase {N}: Completed Work

**Date Started:** {To be filled}
**Date Completed:** {To be filled}
**Sessions Used:** {To be filled}

## Summary
{To be filled by agent - brief description of what was accomplished}

## Changes Made

### Database Migrations
| Migration File | Description |
|----------------|-------------|
| {To be filled} | {To be filled} |

### Files Created
| File | Purpose |
|------|---------|
| {To be filled} | {To be filled} |

### Files Modified
| File | Line(s) | Changes |
|------|---------|---------|
| {To be filled} | {To be filled} | {To be filled} |

### Types/Interfaces Added
```typescript
// To be filled by agent
```

## Implementation Notes
{To be filled - any important notes about how things were implemented}

## How to Test This Phase
{To be filled - step by step testing instructions}

1. {Step 1}
2. {Step 2}
3. Expected result: {what should happen}
```

---

### phase-{N}-{name}/FIXES.md

```markdown
# Phase {N}: Fixes Log

## How This File Works
1. User tests the phase functionality
2. User reports issues in chat
3. Agent documents issue here with "Pending" status
4. Agent fixes the issue
5. Agent updates status to "Fixed" with solution details
6. Repeat until user approves

---

## Fixes

{No fixes yet - populated during user testing}

---

## Fix Template (Copy for each fix)

### Fix #{N}: {Issue Title}

**Reported:** {Date}
**Status:** Pending | In Progress | Fixed | Won't Fix

**User Feedback:**
> {Exact quote from user describing the issue}

**Investigation:**
{What the agent found when investigating}

**Root Cause:**
{Why this happened}

**Solution:**
{What was changed to fix it}

**Files Changed:**
| File | Line(s) | Change |
|------|---------|--------|
| `src/xxx.ts` | 42-45 | {description} |

**Code Changes:**
```typescript
// BEFORE
{old code}

// AFTER
{new code}
```

**Verification:**
{How to verify the fix works}

---
```

---

### phase-{N}-{name}/HANDOFF.md

```markdown
# Phase {N}: Handoff to Phase {N+1}

**Phase Status:** {Not Complete - fill when done}
**Handoff Date:** {To be filled}

## What Was Built
{To be filled - 1-2 paragraph summary of this phase's accomplishments}

## Key Implementation Details
{To be filled - important details the next phase needs to know}

## Decisions Made During Implementation
| Decision | Reasoning |
|----------|-----------|
| {To be filled} | {To be filled} |

## Files Summary
- **Added:** {To be filled}
- **Modified:** {To be filled}

## Database State After This Phase
- **New tables:** {To be filled or "None"}
- **New columns:** {To be filled or "None"}
- **New functions:** {To be filled or "None"}

## Known Issues / Tech Debt
{To be filled or "None"}

## Fixes Applied
{N} fixes were applied during testing:
- Fix #1: {brief}
- Fix #2: {brief}

## Verification Checklist
- [ ] All tasks from PLAN.md complete
- [ ] User tested and approved
- [ ] All fixes from FIXES.md resolved
- [ ] Build passes
- [ ] No regressions

---

## Next Phase

**Phase {N+1}:** {Phase Name}
**Location:** `../phase-{N+1}-{name}/PLAN.md`

### Context for Next Phase
{To be filled - anything the next phase specifically needs to know}

### Ready to Start
- [ ] This phase verified complete
- [ ] User approved handoff
```

---

## WORKFLOW SUMMARY

### Generation (by /generate-prp)
1. Read requirements document
2. Validate and research
3. Create folder structure
4. Fill OVERVIEW.md from requirements
5. Fill PLAN.md for each phase with detailed tasks
6. Create empty templates for COMPLETED, FIXES, HANDOFF

### Execution (by /execute-prp)
1. Read _STATUS.md to find current phase
2. Read OVERVIEW.md for context
3. Read previous HANDOFF.md (if not Phase 0)
4. Read current PLAN.md
5. Check FIXES.md for pending issues
6. Execute tasks, update COMPLETED.md
7. When done: update _STATUS.md to "Awaiting Testing"

### Testing (by User)
1. User tests functionality
2. Reports issues → Agent adds to FIXES.md
3. Agent fixes → Updates FIXES.md
4. Repeat until approved

### Handoff (by Agent)
1. Write HANDOFF.md
2. Update _STATUS.md to next phase
3. Close context
4. New session starts fresh with next phase