# Continue Phased PRP

## PRP Folder: $ARGUMENTS

Continue working on a phased PRP. This command is for resuming work on a complex feature after closing a previous context.

**This command assumes the PRP folder already exists** (created by `/generate-prp`).

---

## STEP 1: READ STATUS

Read `{$ARGUMENTS}/_STATUS.md` to find:
- Current phase number and name
- Current status: Not Started | In Progress | Awaiting Testing | Fixes Required | Complete

---

## STEP 2: LOAD CONTEXT

Read files in this order:

1. **`{$ARGUMENTS}/OVERVIEW.md`** - Full feature context
2. **Previous phase `HANDOFF.md`** (if not Phase 0) - What was done before
3. **Current phase `PLAN.md`** - Tasks to execute
4. **Current phase `FIXES.md`** - Check for pending fixes
5. **Current phase `COMPLETED.md`** - Check what's already done (if In Progress)

---

## STEP 3: DETERMINE ACTION

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
- Wait for user to test and provide feedback
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

## STEP 4: EXECUTE PHASE TASKS

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

## STEP 5: VALIDATE

After completing tasks:

1. Run validation commands from `PLAN.md`
2. Fix any failures
3. Verify acceptance criteria are met

---

## STEP 6: UPDATE STATUS

When phase tasks are complete:

1. Update `_STATUS.md`:
   ```markdown
   **Status:** Awaiting Testing
   ```

2. Update the phase emoji in Quick Status:
   ```markdown
   - Phase {N}: 🔄 Awaiting Testing
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

## STEP 7: HANDLE USER FEEDBACK

When user reports issues:

### 7.1 Log the Issue
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

### 7.2 Fix the Issue
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
  ```typescript
  // BEFORE
  {old code}

  // AFTER
  {new code}
  ```

  **Status:** Fixed
  ```

### 7.3 Continue
- Ask user to test again
- Repeat until user approves

---

## STEP 8: PHASE COMPLETION

When user approves (says "approved", "looks good", "works", etc.):

### 8.1 Write Handoff
Fill in `HANDOFF.md` with:
- Summary of what was built
- Key implementation details
- Decisions made during implementation
- Files added/modified
- Fixes that were applied
- Context the next phase needs

### 8.2 Update Status
Update `_STATUS.md`:
```markdown
**Current Phase:** Phase {N+1} - {Next Phase Name}
**Status:** Not Started

## Quick Status
- Phase {N}: ✅ Complete
- Phase {N+1}: ⏳ Not Started
```

### 8.3 Close Context
Tell user:
```
========================================
PHASE {N} COMPLETE ✅
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
│  Read FIXES.md → Pending issues         │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  Execute tasks from PLAN.md             │
│  Update COMPLETED.md as you go          │
│  Run validation commands                │
│  Update _STATUS.md to "Awaiting Testing"│
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  User tests functionality               │
└─────────────────────────────────────────┘
                    ↓
         ┌────────┴────────┐
         ↓                 ↓
    ┌─────────┐      ┌─────────────────┐
    │ APPROVE │      │ ISSUES FOUND    │
    │         │      │ → Log in FIXES  │
    │         │      │ → Fix issues    │
    │         │      │ → User retests  │
    └────┬────┘      └────────┬────────┘
         │                    │
         │              (loop until approved)
         ↓                    │
┌─────────────────────────────────────────┐
│  Write HANDOFF.md                       │
│  Update _STATUS.md → Next phase         │
│  Context can be closed                  │
└─────────────────────────────────────────┘
```

---

## CRITICAL REMINDERS

1. **ALWAYS read _STATUS.md first** - Know where you are
2. **ALWAYS read HANDOFF.md** - Know what happened before (unless Phase 0)
3. **ALWAYS update COMPLETED.md** - Document as you work
4. **ALWAYS log fixes in FIXES.md** - Track all issues and solutions
5. **ALWAYS write HANDOFF.md** - Next session depends on it
6. **Use TodoWrite** - Track your progress

**The Goal:** Seamless continuation. You should be able to pick up exactly where the previous session left off.

---

## ⚠️ SAFETY RULES

### 1. LOCAL DATABASE ONLY
- **ALWAYS** use `--local` flag with ALL Supabase commands
- Examples:
  - ✅ `npx supabase migration up --local`
  - ✅ `npx supabase db reset --local`
  - ✅ `npx supabase gen types typescript --local > src/types/database.ts`
  - ❌ `npx supabase migration up` (DANGEROUS - affects production!)
  - ❌ `npx supabase db push` (DANGEROUS!)

### 2. NO GIT COMMITS
- **NEVER** commit code to GitHub during implementation
- The user will handle all git operations manually
- Do NOT run `git commit`, `git push`, or similar commands

### 3. NO PRODUCTION DEPLOYMENTS
- Do NOT run any deployment commands
- Do NOT run `vercel`, `npm run deploy`, or similar
