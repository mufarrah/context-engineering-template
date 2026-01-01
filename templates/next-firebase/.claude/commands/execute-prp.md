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
- Read the PRP file completely
- Understand all context and requirements
- Note the validation commands and acceptance criteria

### 2. ULTRATHINK
- Plan your approach before coding
- Break down into tasks using TodoWrite tool
- Identify patterns from existing code to follow

### 3. Execute
- Implement the code following the PRP instructions
- Update TodoWrite as you complete tasks

### 4. Validate
- Run each validation command from the PRP
- Fix any failures
- Re-run until all pass

### 5. Complete
- Verify all acceptance criteria are met
- Report completion status:
  ```
  ========================================
  PRP EXECUTION COMPLETE ✅
  ========================================

  All tasks completed and validated.
  ========================================
  ```

---

## FOR PHASED PRPs (Folder) - Phase 0 Only

This command starts Phase 0. For subsequent phases, use `/continue-prp`.

### 1. Load Context
Read in this order:
1. `{$ARGUMENTS}/_STATUS.md` - Verify we're on Phase 0
2. `{$ARGUMENTS}/OVERVIEW.md` - Full feature context
3. `{$ARGUMENTS}/phase-0-*/PLAN.md` - Phase 0 tasks

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

### 5. Update Status
1. Update `_STATUS.md`:
   ```markdown
   **Status:** Awaiting Testing
   ```
2. Update Quick Status:
   ```markdown
   - Phase 0: 🔄 Awaiting Testing
   ```

### 6. Request Testing
Tell user:
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

### 2. Update Status
Update `_STATUS.md`:
```markdown
**Current Phase:** Phase 1 - {Phase Name}
**Status:** Not Started

## Quick Status
- Phase 0: ✅ Complete
- Phase 1: ⏳ Not Started
```

### 3. Close Context
```
========================================
PHASE 0 COMPLETE ✅
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
5. **Use TodoWrite** - Track your progress

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
