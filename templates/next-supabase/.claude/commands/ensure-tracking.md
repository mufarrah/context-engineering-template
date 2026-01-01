# Ensure Tracking

## PRP Folder: $ARGUMENTS

Verify and complete all documentation for the current phase before closing context. Run this when you feel the agent hasn't properly documented everything.

**Purpose:** Ensure the next agent session has complete context to continue seamlessly.

---

## STEP 1: IDENTIFY CURRENT PHASE

Read `{$ARGUMENTS}/_STATUS.md` to find:
- Current phase number and name
- Current phase folder path

---

## STEP 2: AUDIT COMPLETED.md

Read `{current-phase}/COMPLETED.md` and verify it contains:

### Required Sections (Must Be Filled)

- [ ] **Date Started** - When work began
- [ ] **Date Completed** - When tasks finished (or "In Progress")
- [ ] **Summary** - What was accomplished (1-2 paragraphs)

### Changes Made (Must Be Complete)

- [ ] **Database Migrations** - All SQL files created with descriptions
- [ ] **Files Created** - Every new file with its purpose
- [ ] **Files Modified** - Every modified file with line numbers and what changed
- [ ] **Types/Interfaces Added** - Code snippets of new types

### Testing Instructions

- [ ] **How to Test** - Step-by-step instructions for manual testing

### If Any Section is Missing or Incomplete:
**Fill it in now** by reviewing:
1. Git diff or recent changes
2. The tasks from PLAN.md
3. Your memory of what was done

---

## STEP 3: AUDIT FIXES.md

Read `{current-phase}/FIXES.md` and verify:

### For Each Fix Reported:

- [ ] **Issue Title** - Clear description
- [ ] **User Feedback** - Exact quote of what user reported
- [ ] **Status** - Must be "Fixed" (not "Pending" or "In Progress")
- [ ] **Root Cause** - Why the issue happened
- [ ] **Solution** - What was done to fix it
- [ ] **Files Changed** - Table with file, lines, and description
- [ ] **Code Changes** - Before/after code snippets

### If Any Fix is Incomplete:
**Fill it in now** with the missing details.

### If Status is Still "Pending" or "In Progress":
**Either fix the issue or document why it wasn't fixed.**

---

## STEP 4: AUDIT HANDOFF.md

Read `{current-phase}/HANDOFF.md` and verify:

### Required Sections (Must Be Filled)

- [ ] **Phase Status** - Must say "Complete and Verified"
- [ ] **Handoff Date** - Today's date
- [ ] **What Was Built** - 1-2 paragraph summary
- [ ] **Key Implementation Details** - Important technical details
- [ ] **Decisions Made** - Table of decisions and reasoning
- [ ] **Files Summary** - Lists of added and modified files
- [ ] **Database State** - New tables, columns, functions
- [ ] **Known Issues / Tech Debt** - List or "None"
- [ ] **Fixes Applied** - Summary of fixes from FIXES.md
- [ ] **Verification Checklist** - All boxes checked
- [ ] **Next Phase** - Name and path to next phase
- [ ] **Context for Next Phase** - What the next agent needs to know

### If Any Section is Missing or Empty:
**Fill it in now.**

---

## STEP 5: AUDIT _STATUS.md

Read `{$ARGUMENTS}/_STATUS.md` and verify:

- [ ] **Current Phase** - Points to the NEXT phase (not the one just completed)
- [ ] **Status** - Should be "Not Started" for next phase
- [ ] **Quick Status** - Completed phase shows ✅, next phase shows ⏳
- [ ] **Last Updated** - Today's date with note about what changed

### If Not Updated:
**Update it now** to reflect phase completion.

---

## STEP 6: CROSS-CHECK CONSISTENCY

Verify consistency across all files:

1. **Files mentioned in COMPLETED.md** should match **files in HANDOFF.md**
2. **Fixes in FIXES.md** should be summarized in **HANDOFF.md**
3. **Phase status in _STATUS.md** should match **HANDOFF.md verification**
4. **Next phase in HANDOFF.md** should match **current phase in _STATUS.md**

### If Inconsistencies Found:
**Fix them now** to ensure single source of truth.

---

## STEP 7: GENERATE TRACKING REPORT

After completing the audit, output:

```
========================================
TRACKING AUDIT COMPLETE
========================================

Phase: {N} - {Phase Name}
PRP: {$ARGUMENTS}

COMPLETED.md:
  ✅ Summary filled
  ✅ Database migrations documented
  ✅ Files created listed
  ✅ Files modified listed
  ✅ Testing instructions provided

FIXES.md:
  ✅ {N} fixes documented
  ✅ All fixes resolved (no pending)
  ✅ Code changes included

HANDOFF.md:
  ✅ What was built summary
  ✅ Implementation details
  ✅ Decisions documented
  ✅ Files summary complete
  ✅ Next phase context provided

_STATUS.md:
  ✅ Points to Phase {N+1}
  ✅ Quick status updated
  ✅ Last updated set

Consistency:
  ✅ Files match across documents
  ✅ Fixes summarized in handoff
  ✅ Status aligned

========================================
READY TO CLOSE CONTEXT ✅

Next session: /continue-prp {$ARGUMENTS}
========================================
```

### If Issues Were Found and Fixed:
```
========================================
TRACKING AUDIT COMPLETE (WITH FIXES)
========================================

Issues Found and Fixed:
- COMPLETED.md: Added missing files modified section
- FIXES.md: Added code changes for Fix #2
- HANDOFF.md: Added context for next phase
- _STATUS.md: Updated to point to Phase 2

========================================
NOW READY TO CLOSE CONTEXT ✅

Next session: /continue-prp {$ARGUMENTS}
========================================
```

---

## QUICK CHECKLIST

Before closing context, all must be true:

### COMPLETED.md
- [ ] Has summary of what was done
- [ ] Lists all files created
- [ ] Lists all files modified with changes
- [ ] Has testing instructions

### FIXES.md
- [ ] All fixes have "Fixed" status
- [ ] Each fix has root cause and solution
- [ ] Code changes are documented

### HANDOFF.md
- [ ] Summary of phase accomplishments
- [ ] All decisions documented
- [ ] Files summary matches COMPLETED.md
- [ ] Context for next phase is clear
- [ ] Verification checklist complete

### _STATUS.md
- [ ] Points to next phase
- [ ] Completed phase marked ✅
- [ ] Last updated is today

---

## CRITICAL REMINDER

**The next agent will ONLY have access to these files.**

They will NOT have:
- Your memory of what happened
- The chat history
- Context about why decisions were made

Everything must be written down. If it's not documented, it didn't happen.
