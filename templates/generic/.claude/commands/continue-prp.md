# Continue Phased PRP

## PRP Folder: $ARGUMENTS

Continue working on a phased PRP. This command is for resuming work on a complex feature after closing a previous context.

**This command assumes the PRP folder already exists** (created by `/generate-prp`).

---

## STEP 1: READ PROJECT STATUS

Read `context-engineering/_STATUS.md` to understand:
- What else is in-progress in the project
- Current project context
- Related work that might affect this feature

---

## STEP 2: READ PRP STATUS

Read `{$ARGUMENTS}/_STATUS.md` to find:
- Current phase number and name
- Current status: Not Started | In Progress | Awaiting Testing | Fixes Required | Complete

---

## STEP 3: LOAD CONTEXT

Read files in this order:

1. **`{$ARGUMENTS}/OVERVIEW.md`** - Full feature context
2. **Previous phase `HANDOFF.md`** (if not Phase 0) - What was done before
3. **Current phase `PLAN.md`** - Tasks to execute
4. **Current phase `TEST-CASES.md`** - Test cases for guided testing after implementation
5. **Current phase `FIXES.md`** - Check for pending fixes
6. **Current phase `COMPLETED.md`** - Check what's already done (if In Progress)

---

## STEP 4: DETERMINE ACTION

Based on the status in `_STATUS.md`:

### If Status = "Not Started"
- This is a fresh phase
- Execute all tasks from `PLAN.md`
- Update `COMPLETED.md` as you work
- Use TodoWrite to track progress

### If Status = "In Progress"
- Phase was partially completed
- Read `COMPLETED.md` to see what's done
- Continue with remaining tasks from `PLAN.md`
- Update `COMPLETED.md` as you work

### If Status = "Awaiting Testing"
- Phase tasks are complete
- Read `TEST-CASES.md` for this phase
- Run the **Guided Testing Walkthrough** (see Step 6.5) — walk user through each test case, validating results
- If user reports issues → go to "Fixes Required" flow

### If Status = "Fixes Required"
- Read `FIXES.md` for pending issues
- Fix each issue marked as "Pending"
- Update `FIXES.md` with solutions (root cause, code changes)
- When all fixed → update status to "Awaiting Testing"

### If Status = "Complete"
- This phase is done
- Check if there's a next phase
- If yes → update `_STATUS.md` to next phase and continue
- If no → feature is complete!

---

## STEP 5: EXECUTE PHASE TASKS

For each task in `PLAN.md`:

1. Read the required files mentioned
2. Follow the code patterns provided
3. Implement the changes
4. Document what you did in `COMPLETED.md`:
   - Files created/modified
   - Key implementation details
   - Any decisions made

Use TodoWrite tool to track your progress through tasks.

---

## STEP 6: VALIDATE

After completing tasks:

1. Run validation commands from `PLAN.md`
2. Fix any failures
3. Verify acceptance criteria are met

---

## STEP 6.5: GUIDED TESTING WALKTHROUGH

After validation commands pass, run the guided testing walkthrough:

1. Read current phase's `TEST-CASES.md`
2. Tell the user:
   ```
   ========================================
   READY FOR GUIDED TESTING
   ========================================

   I'll walk you through {N} test cases for Phase {X}.
   For each test, I'll:
   - Tell you what to do
   - Validate the result after your action
   - Mark pass/fail

   Let's start with TC-A1: {title}
   ========================================
   ```
3. For each test case:
   a. Present the test case ID, title, and steps to the user
   b. Wait for user confirmation they performed the action
   c. Run validation using the project's validation method (from project CLAUDE.md)
   d. Compare results against expected outcomes
   e. Mark passed or failed with detailed notes in the tracker
   f. If failed → ask user if they want to fix now or continue to next test
4. After all tests complete:
   - Update TEST-CASES.md Test Execution Tracker with all results
   - If all pass → proceed to "Update Status" step
   - If any fail → log failures to FIXES.md, fix, retest failed cases only

---

## STEP 7: UPDATE STATUS

When phase tasks are complete:

1. Update `_STATUS.md`:
   ```markdown
   **Status:** Awaiting Testing
   ```

2. Update the phase emoji in Quick Status:
   ```markdown
   - Phase {N}: Awaiting Testing
   ```

3. Tell user:
   ```
   ========================================
   PHASE {N} TASKS COMPLETE
   ========================================

   Status: Awaiting Testing

   Please test the functionality and let me know:
   - If it works → say "approved" and I'll complete the handoff
   - If issues → describe the problem and I'll fix it
   ========================================
   ```

---

## STEP 8: HANDLE USER FEEDBACK

When user reports issues:

### 8.1 Log the Issue
Add to `FIXES.md`:
```markdown
## Fix #{N}: {Issue Title}

**Reported:** {Date}
**Status:** Pending

**User Feedback:**
> {Exact quote from user}

**Investigation:**
{What you found when investigating}
```

### 8.2 Fix the Issue
- Implement the fix
- Update `FIXES.md` with:
  ```markdown
  **Root Cause:**
  {Why this happened}

  **Solution:**
  {What was changed}

  **Files Changed:**
  | File | Line(s) | Change |
  |------|---------|--------|
  | `src/xxx.ts` | 42-45 | {description} |

  **Code Changes:**
  ```
  // BEFORE
  {old code}

  // AFTER
  {new code}
  ```

  **Status:** Fixed
  ```

### 8.3 Continue
- Ask user to test again
- Repeat until user approves

---

## STEP 9: PHASE COMPLETION

When user approves (says "approved", "looks good", "works", etc.):

### 9.1 Write Handoff
Fill in `HANDOFF.md` with:
- Summary of what was built
- Key implementation details
- Decisions made during implementation
- Files added/modified
- Fixes that were applied
- Context the next phase needs

### 9.1.5 Update Knowledge Base & Project Docs

**REQUIRED for EVERY phase** (not just final phase):

Knowledge can be lost between sessions. Update documentation after EVERY phase completion to preserve context.

**Run the full `/update-knowledge-base` process**, which will:

1. **Update Knowledge Base:**
   - Extract key decisions, gotchas, patterns, and architecture changes from this phase
   - Create or update topic files in appropriate sections (concepts, flows, implementations, gotchas, decisions)
   - Regenerate affected `_SUMMARY.md` files and `knowledge-base/INDEX.md`

2. **Update Project Documentation:**
   - Update `CLAUDE.md` with new patterns, conventions, module responsibilities
   - Update `PLANNING.md` with architecture changes, data flows, integrations

**Why every phase matters:**
- Context may be lost between sessions
- Different agents may continue the work
- Patterns established in Phase 2 shouldn't wait until Phase 7 to be documented
- Gotchas discovered early should be captured immediately
- Project docs should always reflect current state

**Skip documentation updates only if:**
- Phase was purely bug fixes with no new patterns
- No architectural changes or decisions were made
- No gotchas were discovered

For detailed instructions, see `/update-knowledge-base`.

### 9.2 Update PRP Status
Update `{$ARGUMENTS}/_STATUS.md`:
```markdown
**Current Phase:** Phase {N+1} - {Next Phase Name}
**Status:** Not Started

## Quick Status
- Phase {N}: Complete
- Phase {N+1}: Not Started
```

### 9.3 Update Project Status (if final phase)
If this was the FINAL phase of the feature:
1. Read `context-engineering/_STATUS.md`
2. Move the feature from "In Progress" to "Recently Completed"
3. Add completion date

### 9.4 Close Context
Tell user:
```
========================================
PHASE {N} COMPLETE
========================================

Completed: {Phase Name}
Handoff: {path to HANDOFF.md}

Next: Phase {N+1} - {Next Phase Name}

You can close this context now.
To continue later: /continue-prp {$ARGUMENTS}
========================================
```

---

## WORKFLOW DIAGRAM

```
┌─────────────────────────────────────────┐
│  Read _STATUS.md → Find current phase   │
│  Read OVERVIEW.md → Feature context     │
│  Read previous HANDOFF.md → What's done │
│  Read current PLAN.md → What to do      │
│  Read current TEST-CASES.md → Tests     │
│  Read FIXES.md → Pending issues         │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  Execute tasks from PLAN.md             │
│  Update COMPLETED.md as you go          │
│  Run validation commands                │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  Guided Testing Walkthrough             │
│  Read TEST-CASES.md                     │
│  Walk user through each test case       │
│  Validate after each action             │
│  Mark pass/fail in tracker              │
└─────────────────────────────────────────┘
                    ↓
         ┌────────┴────────┐
         ↓                 ↓
    ┌─────────┐      ┌─────────────────┐
    │ ALL PASS│      │ FAILURES FOUND  │
    │         │      │ → Log in FIXES  │
    │         │      │ → Fix issues    │
    │         │      │ → Retest failed │
    └────┬────┘      └────────┬────────┘
         │                    │
         │              (loop until all pass)
         ↓                    │
┌─────────────────────────────────────────┐
│  Write HANDOFF.md                       │
│  Update _STATUS.md → Next phase         │
│  Context can be closed                  │
└─────────────────────────────────────────┘
```

---

## CRITICAL REMINDERS

1. **ALWAYS read project _STATUS.md first** - Know what else is happening in the project
2. **ALWAYS read PRP _STATUS.md** - Know where you are in this feature
3. **ALWAYS read HANDOFF.md** - Know what happened before (unless Phase 0)
4. **ALWAYS update COMPLETED.md** - Document as you work
5. **ALWAYS log fixes in FIXES.md** - Track all issues and solutions
6. **ALWAYS write HANDOFF.md** - Next session depends on it
7. **ALWAYS update KB & project docs** - On EVERY phase completion, not just final phase
8. **Update project _STATUS.md** - When final phase completes
9. **Use TodoWrite** - Track your progress

**The Goal:** Seamless continuation. You should be able to pick up exactly where the previous session left off, with all knowledge preserved in the knowledge base and project documentation.

---

## SAFETY RULES

### 1. Follow Project Safety Rules
- Read the project's `CLAUDE.md` for safety rules and coding standards
- Follow all environment-specific constraints (local vs production, etc.)

### 2. NO GIT COMMITS
- **NEVER** commit code to GitHub during implementation
- The user will handle all git operations manually
- Do NOT run `git commit`, `git push`, or similar commands

### 3. NO PRODUCTION DEPLOYMENTS
- Do NOT run any deployment commands
