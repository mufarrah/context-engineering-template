# Execute PRP

## PRP Path: $ARGUMENTS

Execute a PRP (Project Requirement Plan). Use this for:
- **Simple PRPs** (single file) - Complete execution
- **Phased PRPs** (folder) - Initial Phase 0 execution only

**For continuing phased PRPs after Phase 0, use `/continue-prp` instead.**

---

## STEP 1: DETECT PRP TYPE

Check if `$ARGUMENTS` is:
- **A file** (e.g., `context-engineering/PRPs/feature-name.md`) → Simple PRP
- **A folder** (e.g., `context-engineering/PRPs/FEATURE-NAME/`) → Phased PRP

---

## FOR SIMPLE PRPs (Single File)

### 1. Load PRP
- Read `context-engineering/_STATUS.md` to understand current project context
- Read the PRP file completely
- Understand all context and requirements
- Note the validation commands and acceptance criteria

### 2. Update Status Header
Update the PRP file's status header to reflect work has started:
```markdown
**Status:** In Progress
**Feature Input:** {keep existing path}
**Last Updated:** {today's date}
```
If the PRP has no status header (older PRP), add one at the top of the file.

### 3. ULTRATHINK
- Plan your approach before coding
- Break down into tasks using TodoWrite tool
- Identify patterns from existing code to follow

### 4. Execute
- Implement the code following the PRP instructions
- Update TodoWrite as you complete tasks

### 5. Validate
- Run each validation command from the PRP
- Fix any failures
- Re-run until all pass

### 5.5 Guided Testing Walkthrough

If the PRP contains a "Test Cases" section:

1. Read the test cases section completely
2. Tell the user you're ready to walk them through testing:
   ```
   ========================================
   READY FOR GUIDED TESTING
   ========================================

   I'll walk you through {N} test cases.
   For each test, I'll:
   - Tell you what to do
   - Validate the result after your action
   - Mark pass/fail

   Let's start with TC-1: {title}
   ========================================
   ```
3. For each test case:
   a. Present the test case ID, title, and steps to the user
   b. Wait for user to perform the steps
   c. Run validation using the project's validation method (from project CLAUDE.md)
   d. Compare results against expected outcomes
   e. Mark the test as passed or failed with detailed notes
   f. If failed → log to fixes, fix the issue, retest
4. Update the Test Execution Tracker in the PRP with results
5. Continue to next step only when all tests pass (or user explicitly skips)

### 6. Update Status Header to Complete
Update the PRP file's status header:
```markdown
**Status:** Complete
**Feature Input:** {keep existing path}
**Last Updated:** {today's date}
```

### 7. Update Project Status
After successful implementation:
1. Read `context-engineering/_STATUS.md`
2. Move the feature from "In Progress" to "Recently Completed"
3. Update the entry with completion date

### 8. Archive Feature Input
Move the feature input document:
```bash
mv context-engineering/feature-inputs/in-progress/{feature-name}.md context-engineering/archive/feature-inputs/
```
Update the `**Feature Input:**` path in the PRP status header to reflect the archive location.

### 8.5. Update Knowledge Base & Project Docs

After archiving, run the full `/update-knowledge-base` process to:

1. **Update Knowledge Base:**
   - Extract key decisions, gotchas, patterns, and architecture from this PRP
   - Create or update topic files in appropriate sections (concepts, flows, implementations, gotchas, decisions)
   - Regenerate affected `_SUMMARY.md` files and `knowledge-base/INDEX.md`

2. **Update Project Documentation:**
   - Update `CLAUDE.md` with new patterns, conventions, module responsibilities
   - Update `PLANNING.md` with architecture changes, data flows, integrations

**What to extract:**
- Key decisions and their rationale
- Files created/modified and data flow patterns
- Gotchas discovered during implementation or fixes
- Data model changes (new tables, columns, functions)
- New code patterns or conventions established
- Module responsibility changes

For detailed instructions, see `/update-knowledge-base`.

### 9. Complete
- Verify all acceptance criteria are met
- Report completion status:
  ```
  ========================================
  PRP EXECUTION COMPLETE
  ========================================

  All tasks completed and validated.
  PRP status updated to: Complete
  Feature input archived to: context-engineering/archive/feature-inputs/
  Project _STATUS.md updated
  ========================================
  ```

---

## FOR PHASED PRPs (Folder) - Phase 0 Only

This command starts Phase 0. For subsequent phases, use `/continue-prp`.

### 1. Load Context
Read in this order:
1. `context-engineering/_STATUS.md` - Current project status
2. `{$ARGUMENTS}/_STATUS.md` - Verify we're on Phase 0
3. `{$ARGUMENTS}/OVERVIEW.md` - Full feature context
4. `{$ARGUMENTS}/phase-0-*/PLAN.md` - Phase 0 tasks
5. `{$ARGUMENTS}/phase-0-*/TEST-CASES.md` - Phase 0 test cases (for guided testing after implementation)

### 2. Verify Starting Point
- Confirm status is "Not Started" for Phase 0
- If not Phase 0, tell user to use `/continue-prp` instead

### 3. Execute Phase 0 Tasks
For each task in `PLAN.md`:
1. Read the required files mentioned
2. Follow the code patterns provided
3. Implement the changes
4. Document in `COMPLETED.md` as you work

Use TodoWrite to track progress.

### 4. Validate
- Run validation commands from `PLAN.md`
- Fix any failures
- Verify acceptance criteria

### 4.5 Guided Testing Walkthrough

1. Read `{phase}/TEST-CASES.md`
2. Tell the user:
   ```
   ========================================
   READY FOR GUIDED TESTING
   ========================================

   I'll walk you through {N} test cases for Phase 0.
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

### 5. Update Status
1. Update `_STATUS.md`:
   ```markdown
   **Status:** Awaiting Testing
   ```
2. Update Quick Status:
   ```markdown
   - Phase 0: Awaiting Testing
   ```

### 6. Request Testing
If guided testing was already completed in Step 4.5 and all tests passed, skip to PHASE 0 COMPLETION.

Otherwise, tell user:
```
========================================
PHASE 0 TASKS COMPLETE
========================================

Status: Awaiting Testing

Please test the functionality and let me know:
- If it works → say "approved" and I'll complete the handoff
- If issues → describe the problem and I'll fix it

After this phase is approved, use:
/continue-prp {$ARGUMENTS}
========================================
```

---

## HANDLING FIXES (Same Session)

If user reports issues while still in the same session:

### 1. Log the Issue
Add to `phase-0-*/FIXES.md`:
```markdown
## Fix #1: {Issue Title}

**Reported:** {Date}
**Status:** Pending

**User Feedback:**
> {Exact quote from user}
```

### 2. Fix and Document
- Implement the fix
- Update `FIXES.md` with root cause, solution, code changes
- Mark as "Fixed"

### 3. Ask for Retest
Continue until user approves.

---

## PHASE 0 COMPLETION

When user approves Phase 0:

### 1. Write Handoff
Fill in `phase-0-*/HANDOFF.md` with:
- Summary of what was built
- Key implementation details
- Decisions made
- Files added/modified
- Fixes applied
- Context for Phase 1

### 1.5. Update Knowledge Base & Project Docs

**REQUIRED for EVERY phase** (including Phase 0):

Run the full `/update-knowledge-base` process to preserve knowledge:

1. **Update Knowledge Base:**
   - Extract key decisions, gotchas, patterns, and architecture from this phase
   - Create or update topic files in appropriate sections
   - Regenerate affected `_SUMMARY.md` files and `knowledge-base/INDEX.md`

2. **Update Project Documentation:**
   - Update `CLAUDE.md` with new patterns, conventions
   - Update `PLANNING.md` with architecture changes

**Why every phase matters:**
- Context may be lost between sessions
- Different agents may continue the work
- Gotchas discovered early should be captured immediately

**Skip only if:** Phase was purely bug fixes with no new patterns or decisions.

For detailed instructions, see `/update-knowledge-base`.

### 2. Update Status
Update `_STATUS.md`:
```markdown
**Current Phase:** Phase 1 - {Phase Name}
**Status:** Not Started

## Quick Status
- Phase 0: Complete
- Phase 1: Not Started
```

### 3. Close Context
```
========================================
PHASE 0 COMPLETE
========================================

Handoff: phase-0-*/HANDOFF.md
Next: Phase 1 - {Name}

You can close this context.
To continue: /continue-prp {$ARGUMENTS}
========================================
```

---

## SUMMARY

| PRP Type | Command | Purpose |
|----------|---------|---------|
| Simple (file) | `/execute-prp` | Complete execution |
| Phased (folder) - Phase 0 | `/execute-prp` | Start Phase 0 |
| Phased (folder) - Phase 1+ | `/continue-prp` | Continue any phase |

---

## CRITICAL REMINDERS

1. **Use `/continue-prp` for Phase 1+** - This command is for Phase 0 only
2. **Document as you go** - Update `COMPLETED.md` during implementation
3. **Log all fixes** - Every issue goes in `FIXES.md`
4. **Write handoff** - Critical for next session
5. **Update KB & project docs** - On EVERY phase/PRP completion
6. **Use TodoWrite** - Track your progress

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
