# Check Progress

## PRP Path: $ARGUMENTS

Comprehensive progress validation against the original requirements document. Checks ALL phases (completed, current, and remaining) to ensure nothing is missed and everything aligns with requirements.

**PURPOSE:** Full audit of implementation progress - verify completed work, investigate current phase deeply, and confirm remaining phases cover everything else.

**WHEN TO USE:** Run this anytime during development when you're not confident that all requirements are being addressed.

---

## STEP 1: GATHER ALL CONTEXT

### 1.1 Read _STATUS.md

From `{$ARGUMENTS}/_STATUS.md`, extract:
- Current phase number and name
- Status of ALL phases (which are complete, in progress, pending)
- Source document path

### 1.2 Read Source Requirements Document COMPLETELY

**CRITICAL:** Read the ENTIRE requirements document from start to finish. Extract:

1. **All defined phases** with their scope
2. **Every requirement/feature** mentioned
3. **All database changes** required
4. **All file modifications** expected
5. **All edge cases** documented
6. **All success criteria**
7. **All key decisions**

Create a master checklist of EVERYTHING that needs to be done:

```
MASTER REQUIREMENTS LIST
========================================
REQ-001: {requirement description}
REQ-002: {requirement description}
REQ-003: {requirement description}
...
REQ-N: {requirement description}
```

### 1.3 Read OVERVIEW.md

Extract:
- Implementation phases table
- Key decisions documented
- Overall success criteria
- Database changes summary

---

## STEP 2: AUDIT COMPLETED PHASES

For EACH phase marked as ✅ Complete in _STATUS.md:

### 2.1 Read Phase COMPLETED.md

Extract what was actually built:
- Summary of work
- Files created
- Files modified
- Implementation notes

### 2.2 Read Phase HANDOFF.md

Extract:
- What was built summary
- Decisions made
- Files summary
- Known issues / tech debt

### 2.3 Cross-Reference with Requirements

For each requirement, check if it was supposed to be in this phase AND if it was completed:

```
PHASE {N} - {Name} (COMPLETED)
========================================

Requirements assigned to this phase:
- REQ-001: "Add booking_mode column" → ✅ DONE (COMPLETED.md: migration created)
- REQ-002: "Create booking_participants table" → ✅ DONE (COMPLETED.md: table created)
- REQ-003: "Add RLS policies" → ✅ DONE (COMPLETED.md: policies added)

Requirements that SHOULD have been this phase but weren't done:
- REQ-004: "Add index on availability_id" → ❌ NOT FOUND (GAP - was this missed?)

Extra work done not in requirements:
- "Added phone-input fixes" → ⚠️ Not in requirements (OK if needed for feature)
```

### 2.4 Compile Completed Phase Summary

```
COMPLETED PHASES SUMMARY
========================================

Phase 0 - Foundation: ✅
  Requirements covered: 5/5 (100%)
  Gaps found: 0

Phase 1 - Booking Types: ✅
  Requirements covered: 4/4 (100%)
  Gaps found: 0

Phase 2 - Availability Form: ✅
  Requirements covered: 6/6 (100%)
  Gaps found: 0

Total requirements from completed phases: 15
Total actually completed: 15
Gaps in completed phases: 0
```

---

## STEP 3: DEEP INVESTIGATION - CURRENT PHASE

**This is where you spend the most time.** The user is running this because they're uncertain about the current phase.

### 3.1 Read Current Phase PLAN.md

Extract ALL tasks:
- Task names and descriptions
- Files to modify
- What to do steps
- Code patterns referenced
- Expected outcomes
- Acceptance criteria

### 3.2 Read Current Phase COMPLETED.md

Extract what's been done so far:
- Summary
- Files created with purposes
- Files modified with changes
- Implementation notes

### 3.3 Read Current Phase FIXES.md

Check:
- Total fixes logged
- Fixes with "Fixed" status
- Fixes with "Pending" status (⚠️ blockers!)
- Any requirements addressed via fixes

### 3.4 Task-by-Task Analysis

For EACH task in PLAN.md:

```
CURRENT PHASE: {N} - {Name}
========================================

TASK 1: {Task Name}
  Files to modify: {list}
  Status: ✅ DONE | ⚠️ PARTIAL | ❌ NOT DONE
  Evidence in COMPLETED.md: {quote or "Not mentioned"}
  Requirements this covers: REQ-010, REQ-011

TASK 2: {Task Name}
  Files to modify: {list}
  Status: ❌ NOT DONE
  Evidence in COMPLETED.md: Not mentioned
  Requirements this covers: REQ-012

TASK 3: {Task Name}
  Files to modify: {list}
  Status: ⚠️ PARTIAL - File A done, File B not done
  Evidence in COMPLETED.md: "Modified File A..."
  Requirements this covers: REQ-013, REQ-014
```

### 3.5 Requirements Coverage for Current Phase

Map EVERY requirement that should be in this phase:

```
CURRENT PHASE REQUIREMENTS COVERAGE
========================================

Requirements assigned to Phase {N}:

REQ-010: "Multi-client selector for group bookings"
  In PLAN.md: ✅ Task 2
  In COMPLETED.md: ✅ ParticipantSelector created
  Status: ✅ COVERED

REQ-011: "Per-participant paid/attended toggles"
  In PLAN.md: ✅ Task 3
  In COMPLETED.md: ✅ ParticipantsList with toggles
  Status: ✅ COVERED

REQ-012: "Edit participant action"
  In PLAN.md: ❌ NOT FOUND
  In COMPLETED.md: ❌ NOT FOUND
  Status: ❌ GAP - Not planned, not implemented

REQ-013: "Date change clears availability"
  In PLAN.md: ❌ NOT FOUND
  In COMPLETED.md: ❌ NOT FOUND
  Status: ❌ GAP - Not planned, not implemented

REQ-014: "Confirmation dialogs for fee mismatch"
  In PLAN.md: ❌ NOT FOUND
  In COMPLETED.md: ❌ NOT FOUND
  Status: ❌ GAP - Not planned, not implemented
```

### 3.6 Check for Pending Blockers

```
BLOCKERS & PENDING ITEMS
========================================

Pending Fixes:
- ❌ Fix #3: "Modal scroll issue" - Status: Pending

Incomplete Tasks:
- ❌ Task 4: Not started
- ⚠️ Task 5: Partially done

Missing from PLAN but required:
- REQ-012: Edit participant
- REQ-013: Date change behavior
- REQ-014: Confirmation dialogs
```

---

## STEP 4: AUDIT REMAINING PHASES

For EACH phase marked as ⏳ Pending in _STATUS.md:

### 4.1 Read Phase PLAN.md

Extract:
- All tasks planned
- Files to be modified
- Acceptance criteria

### 4.2 Map to Remaining Requirements

For each requirement NOT YET covered by completed or current phases:

```
PHASE {N+1} - {Name} (PENDING)
========================================

Requirements planned for this phase:
- REQ-020: "Online booking capacity check" → ✅ Task 1
- REQ-021: "Registration flow" → ✅ Task 2
- REQ-022: "Booking confirmation updates" → ✅ Task 3

Missing requirements that should be here:
- REQ-023: "Cancel registration" → ❌ NOT IN PLAN

PHASE {N+2} - {Name} (PENDING)
========================================

Requirements planned for this phase:
- REQ-030: "Calendar display for groups" → ✅ Task 1
- REQ-031: "Per-participant Stripe buttons" → ✅ Task 2
...
```

### 4.3 Identify Orphaned Requirements

Find requirements that are NOT in ANY phase:

```
ORPHANED REQUIREMENTS (Not in any phase!)
========================================

These requirements from the source document are NOT covered in any phase:

- REQ-045: "Bulk participant import" - ❌ NOT FOUND IN ANY PLAN
- REQ-046: "Waitlist functionality" - ❌ NOT FOUND IN ANY PLAN
- REQ-047: "Participant notifications" - ❌ NOT FOUND IN ANY PLAN

ACTION NEEDED: Add to appropriate phase or confirm out of scope
```

---

## STEP 5: FULL REQUIREMENTS TRACEABILITY MATRIX

Create a complete matrix showing where EVERY requirement is addressed:

```
========================================
FULL REQUIREMENTS TRACEABILITY
========================================

| Req ID | Requirement | Phase | Task | Status |
|--------|-------------|-------|------|--------|
| REQ-001 | Add booking_mode column | Phase 0 | Task 1 | ✅ Complete |
| REQ-002 | Create booking_participants | Phase 0 | Task 2 | ✅ Complete |
| REQ-003 | RLS policies | Phase 0 | Task 3 | ✅ Complete |
| REQ-010 | Multi-client selector | Phase 3 | Task 2 | ✅ Complete |
| REQ-011 | Paid/attended toggles | Phase 3 | Task 3 | ✅ Complete |
| REQ-012 | Edit participant | Phase 5 | Task 8 | ⏳ Planned |
| REQ-013 | Date change clears avail | Phase 5 | Task 9 | ⏳ Planned |
| REQ-020 | Online capacity check | Phase 4 | Task 1 | ⏳ Pending |
| REQ-045 | Bulk import | ❌ NONE | - | ❌ MISSING |
| REQ-046 | Waitlist | ❌ NONE | - | ❌ MISSING |

Total Requirements: 50
Completed: 15 (30%)
In Progress: 5 (10%)
Planned: 25 (50%)
MISSING: 5 (10%) ⚠️
```

---

## STEP 6: GENERATE COMPREHENSIVE REPORT

```
========================================
COMPREHENSIVE PROGRESS REPORT
========================================

PRP: {path}
Source: {requirements document}
Report Generated: {date}

========================================
EXECUTIVE SUMMARY
========================================

Overall Progress: {X}% requirements addressed
- ✅ Completed: {count} ({%})
- 🔄 In Progress: {count} ({%})
- ⏳ Planned: {count} ({%})
- ❌ MISSING: {count} ({%}) ← ATTENTION NEEDED

Current Phase: {N} - {Name}
Current Phase Completion: {X}% tasks done

========================================
COMPLETED PHASES AUDIT
========================================

{For each completed phase:}

Phase {N}: {Name} ✅
  Tasks: {done}/{total}
  Requirements: {covered}/{assigned}
  Gaps: {count or "None"}
  {List any gaps}

========================================
CURRENT PHASE DEEP DIVE
========================================

Phase {N}: {Name} 🔄
Status: {In Progress | Awaiting Testing}

Task Completion:
  ✅ Done: {count}
  ⚠️ Partial: {count}
  ❌ Not Started: {count}

{Detailed task list with status}

Requirements Coverage:
  ✅ Covered: {count}
  ❌ Gaps: {count}

GAPS IN CURRENT PHASE:
{List each gap with requirement text}

Pending Fixes: {count}
{List if any}

========================================
REMAINING PHASES AUDIT
========================================

{For each pending phase:}

Phase {N}: {Name} ⏳
  Tasks Planned: {count}
  Requirements Assigned: {count}
  Coverage: {covered}/{should be covered}
  {List any missing requirements}

========================================
ORPHANED REQUIREMENTS
========================================

The following requirements are NOT in any phase:

1. REQ-XXX: "{requirement}"
   - Recommendation: Add to Phase {N} or confirm out of scope

2. REQ-XXX: "{requirement}"
   - Recommendation: Add to Phase {N} or confirm out of scope

{Or "None - All requirements are assigned to phases"}

========================================
OVERALL ASSESSMENT
========================================

Requirements Coverage Score: {X}/10
Implementation Progress Score: {X}/10
Alignment Score: {X}/10

Status:
✅ ON TRACK - All requirements accounted for, good progress
⚠️ GAPS FOUND - Some requirements missing from plans
❌ CRITICAL GAPS - Significant requirements not addressed

========================================
RECOMMENDED ACTIONS
========================================

IMMEDIATE (Current Phase):
1. {action item}
2. {action item}

PLANNING FIXES NEEDED:
1. Add REQ-XXX to Phase {N} PLAN.md
2. Add REQ-XXX to Phase {N} PLAN.md

BEFORE MOVING TO NEXT PHASE:
1. Complete pending tasks: {list}
2. Resolve pending fixes: {list}
3. Update COMPLETED.md

CONFIRM WITH USER:
1. Is REQ-XXX intentionally out of scope?
2. Should REQ-XXX be in Phase {N} or Phase {N+1}?

========================================
```

---

## STEP 7: OFFER REMEDIATION

### 7.1 If Gaps Found in Current Phase

```
I found {N} requirements that should be in the current phase but aren't addressed:

1. "{requirement}"
2. "{requirement}"

Options:
A) Add as new tasks to current phase PLAN.md
B) Defer to a later phase (specify which)
C) Confirm these are out of scope

What would you like to do?
```

### 7.2 If Orphaned Requirements Found

```
I found {N} requirements not assigned to ANY phase:

1. "{requirement}"
2. "{requirement}"

These need to be assigned to a phase or confirmed as out of scope.
Which phase should each go to?
```

### 7.3 If Everything Looks Good

```
✅ FULL ALIGNMENT CONFIRMED

All requirements from the source document are:
- Either completed in previous phases
- Being worked on in current phase
- Planned for upcoming phases

No orphaned requirements found.
No gaps in current phase.

You can proceed with confidence!

Current focus: Complete remaining tasks in Phase {N}
Next milestone: {description}
```

---

## CRITICAL REMINDERS

1. **READ EVERYTHING** - Requirements doc, ALL phase files, not just current phase
2. **CREATE MASTER LIST** - Every single requirement needs to be tracked
3. **CHECK EVERY PHASE** - Completed, current, AND remaining
4. **FIND ORPHANS** - Requirements not in any phase are the biggest risk
5. **BE THOROUGH** - This is a confidence check, don't rush it
6. **ACTIONABLE OUTPUT** - Every gap needs a specific recommendation

---

## COMPARISON WITH OTHER SKILLS

| Skill | When to Use | What It Checks |
|-------|-------------|----------------|
| `/check-prp` | After /generate-prp | PRP structure, file existence, format |
| `/check-progress` | Mid-development, when uncertain | ALL phases vs requirements, full alignment |
| `/ensure-tracking` | Before closing context | Documentation completeness for handoff |

---

## QUICK CHECKLIST

```
□ Read _STATUS.md - got phase statuses
□ Read requirements document COMPLETELY
□ Created master requirements list
□ Read OVERVIEW.md
□ For EACH completed phase:
  □ Read COMPLETED.md
  □ Read HANDOFF.md
  □ Verified requirements coverage
□ For current phase (DEEP DIVE):
  □ Read PLAN.md - extracted all tasks
  □ Read COMPLETED.md - extracted work done
  □ Read FIXES.md - checked for pending
  □ Task-by-task analysis
  □ Requirements coverage check
□ For EACH remaining phase:
  □ Read PLAN.md
  □ Mapped to remaining requirements
□ Created full traceability matrix
□ Identified ALL gaps
□ Identified orphaned requirements
□ Generated comprehensive report
□ Provided specific action items
□ Offered remediation options
```
