# Audit Context

Comprehensive workspace-level audit of the entire `context-engineering/` system. Validates documentation consistency, status accuracy, feature input lifecycle, code verification, and cross-feature conflicts.

**PURPOSE:** Catch inconsistencies caused by agents forgetting to update status files, feature inputs not being archived, stale source paths, code changes not matching PRP claims, and workspace _STATUS.md being out of sync.

**WHEN TO USE:**
- After finishing a feature and before moving to the next
- When you come back after a break and need to understand current state
- When you suspect documentation is out of sync
- Periodically as a health check

**OUTPUT:** A categorized report of issues, then offer to fix documentation issues (with user approval). Code issues are flagged for user investigation.

---

## STEP 1: SCAN WORKSPACE

### 1.1 Discover All PRPs

**Phased PRPs** (folders in `context-engineering/PRPs/`):
- List all subdirectories (excluding `templates/`)
- Each folder with a `_STATUS.md` is a phased PRP

**Simple PRPs** (files in `context-engineering/PRPs/`):
- List all `.md` files directly in the PRPs folder
- Exclude template files

### 1.2 Discover All Feature Inputs

- List files in `context-engineering/feature-inputs/pending/`
- List files in `context-engineering/feature-inputs/in-progress/`
- List files in `context-engineering/archive/feature-inputs/`

### 1.3 Read Workspace Status

- Read `context-engineering/_STATUS.md` completely
- Extract: header count, each entry (name, PRP path, phase, status), Quick Stats, Recently Completed entries

### 1.4 Build Inventory

Create an internal inventory:
```
PHASED PRPs: [{name, folder_path, _status_content}]
SIMPLE PRPs: [{name, file_path, has_status_header, status_value}]
FEATURE INPUTS: [{name, location (pending|in-progress|archive)}]
WORKSPACE ENTRIES: [{name, claimed_status, claimed_phase}]
```

---

## STEP 2: AUDIT PHASED PRPs

For EACH phased PRP folder (excluding `templates/`):

### 2.1 Read _STATUS.md
- Extract: claimed status, current phase, source document path
- Note: "Complete" | "Awaiting Testing" | "In Progress" | "Not Started" | etc.

### 2.2 Determine Actual Status

Find the LAST phase folder (highest number). Then check:

**Is it actually complete?**
- Read last phase `COMPLETED.md` — is it filled in (has dates, summary, file lists) or still a template?
- Read last phase `HANDOFF.md` — is it filled in or still has `{To be filled}` placeholders?
- If BOTH are filled → actual status is "Complete"
- If COMPLETED.md filled but HANDOFF.md is template → "Complete but missing handoff"
- If COMPLETED.md is template → not yet complete for that phase

**Cross-check with earlier phases:**
- For each phase before the last, verify COMPLETED.md exists and is not empty template
- Flag any phase marked Complete in _STATUS.md but with empty COMPLETED.md

### 2.3 Check Source Document Path

- Extract `Source Document` field from _STATUS.md or OVERVIEW.md
- Verify the file exists at that path
- If not, search in `archive/feature-inputs/` and `feature-inputs/in-progress/` and `feature-inputs/pending/`
- Flag stale paths with the correct location

### 2.4 Check Feature Input Location

Based on actual status:
- **Complete** → feature input should be in `archive/feature-inputs/`
- **Active (any non-complete status)** → feature input should be in `feature-inputs/in-progress/`
- Search all three locations for a matching filename
- Flag misplaced feature inputs

### 2.5 Check Workspace Entry

- Verify this PRP has an entry in workspace `_STATUS.md`
- Verify the entry's claimed status matches the PRP's actual `_STATUS.md`
- Verify phase numbers match
- Flag any mismatches

### 2.6 Record Issues

For each issue found, record:
```
{
  type: "DOC",
  prp: "{PRP name}",
  issue: "{description}",
  current: "{current state}",
  expected: "{expected state}",
  fix: "{what to do}"
}
```

---

## STEP 3: AUDIT SIMPLE PRPs

For EACH simple PRP file (`.md` files directly in `context-engineering/PRPs/`, excluding templates):

### 3.1 Check Status Header

Look for these fields at the top of the file:
```markdown
**Status:** Complete | In Progress | Not Started
**Feature Input:** {path to feature requirements document}
**Last Updated:** {date}
```

**If status header is missing:**
- Flag as "Missing status header"
- Try to determine status from content

### 3.2 Check Source/Feature Input Path

- Extract `Source Requirements`, `Source Document`, or `Feature Input` field
- Verify the file exists at that path
- If not, search `archive/feature-inputs/` for matching filename
- Flag stale paths

### 3.3 Check Workspace Entry

- Simple PRPs that are "Complete" do NOT need an entry in workspace _STATUS.md (they're historical)
- Simple PRPs that are "In Progress" or "Not Started" SHOULD have an entry
- Flag active simple PRPs missing from workspace status

### 3.4 Record Issues

Same format as Step 2.6.

---

## STEP 4: AUDIT FEATURE INPUTS

### 4.1 Files in `in-progress/`

For each file:
- Find the corresponding PRP (search by name match in both simple and phased PRPs)
- If PRP exists and is complete → flag: "Feature input should be archived"
- If NO PRP exists → flag: "Feature input in-progress but no PRP found (stale?)"

### 4.2 Files in `pending/`

For each file:
- Check if a PRP already exists for this feature
- If PRP exists → flag: "Feature input still in pending but PRP already generated — should be in-progress or archived"
- If no PRP → this is normal (awaiting `/generate-prp`)

### 4.3 Orphaned Feature Inputs

Check if any archived feature inputs DON'T have a corresponding PRP:
- This is informational only (some features may have been cancelled)
- Don't flag as an issue

---

## STEP 5: AUDIT WORKSPACE _STATUS.md

### 5.1 Header Count

- Count entries in the "In Progress" section
- Compare to the header text (e.g., "## In Progress (3 Active PRPs)")
- Flag mismatch

### 5.2 Entry Accuracy

For each entry in workspace _STATUS.md:
- Find the corresponding PRP
- Compare claimed phase/status with PRP's actual _STATUS.md
- Flag any mismatches

### 5.3 Quick Stats

Verify each stat:
- **In-Progress PRPs:** count non-complete entries
- **Pending Feature Inputs:** count files in `feature-inputs/pending/`
- Flag incorrect numbers

### 5.4 Recently Completed

- For each PRP confirmed as complete, verify it appears in "Recently Completed"
- Flag complete PRPs missing from this section

### 5.5 Stale Conflict Notes

- Read the "Critical Cross-Feature Impact Analysis" section (if exists)
- For each conflict mentioned, check if the referenced PRPs are still active
- If BOTH PRPs in a conflict are now complete → flag: "Stale conflict note — both PRPs are complete"

---

## STEP 5.5: AUDIT KNOWLEDGE BASE

### 5.5.1 Scan Knowledge Base

- List all section folders: `knowledge-base/concepts/`, `knowledge-base/flows/`, `knowledge-base/implementations/` (and subfolders), `knowledge-base/gotchas/`, `knowledge-base/decisions/`
- Count topic files per section (`.md` files excluding `_SUMMARY.md`)
- Verify `_SUMMARY.md` exists in each section folder
- Verify `knowledge-base/INDEX.md` exists

### 5.5.2 Check Topic Coverage

For each COMPLETED PRP (both phased and simple):
- Search all topic files in `knowledge-base/` for the PRP name in `**Source PRPs:**` fields
- If not found: flag as `KB-{N}: Completed PRP "{name}" has no knowledge base entry`

### 5.5.3 Check Staleness

For each topic file:
- Read `**Last Updated:**` date
- Read `**Source PRPs:**` list
- For each source PRP, check if it was completed more recently than the topic's Last Updated date
- If stale: flag as `KB-{N}: Topic "{name}" may be stale (PRP completed after last update)`

### 5.5.4 Check Index/Summary Sync

- Count actual topic files per domain
- Compare with topic count in `_SUMMARY.md` header
- Compare with topic count in `INDEX.md`
- Flag mismatches: `KB-{N}: Index shows {X} topics for {domain} but {Y} exist`

### 5.5.5 Add to Report

```
KNOWLEDGE BASE:
  Sections: 5 (concepts, flows, implementations, gotchas, decisions)
  Total Topics: {count}
  PRPs with KB entries: {count}/{total completed PRPs}
  Missing entries: {count}
  Stale topics: {count}
  Index in sync: {yes/no}

{If issues found:}
KB-1: Completed PRP "feature-name" has no knowledge base entry
KB-2: Topic "entity-name" in concepts/ may be stale
KB-3: Index shows 5 topics for concepts but 6 exist
```

---

## STEP 5.6: AUDIT PROJECT DOCUMENTATION

Check if project-specific `CLAUDE.md` and `PLANNING.md` files are up to date with completed PRPs.

### 5.6.1 Identify Projects with Completed PRPs

For each completed PRP (phased or simple), determine which project(s) in `active-projects/` were modified.

### 5.6.2 Check Project CLAUDE.md Staleness

For each project that had completed PRPs:

1. Read the project's `CLAUDE.md`
2. Search for PRP references (comments like `<!-- Added from PRP: ... -->`)
3. Check if patterns from completed PRPs are documented
4. Flag if: A completed PRP touched this project but no relevant updates appear in CLAUDE.md

### 5.6.3 Check Project PLANNING.md Staleness

For each project that had completed PRPs:

1. Read the project's `PLANNING.md`
2. Search for PRP references (comments like `<!-- Updated from PRP: ... -->`)
3. Check if architecture changes from completed PRPs are documented
4. Flag if: A completed PRP made architecture changes but PLANNING.md wasn't updated

### 5.6.4 Add to Report

```
PROJECT DOCUMENTATION:
  Projects checked: {count}
  Up to date: {count}
  Potentially stale: {count}

{If issues found:}
PROJ-1: {project}/CLAUDE.md may be stale — PRP "{name}" added module but not documented
PROJ-2: {project}/PLANNING.md may be stale — PRP "{name}" changed schema but not documented
```

---

## STEP 6: CODE VERIFICATION

**Use Explore agents to verify PRP-claimed changes exist in the actual source code.**

This step validates that what PRPs claim was implemented actually exists. Focus on phased PRPs that are marked as complete or awaiting testing.

### 6.1 For Each Phased PRP (complete or awaiting testing):

Read the HANDOFF.md (or COMPLETED.md) from the final completed phase. Extract:
- **Files Created** — list of new files with paths
- **Files Modified** — list of modified files with descriptions of changes
- **Key features/strings** — identifiable strings, function names, config keys, etc.

### 6.2 Files Created Verification

For each file claimed to be created:
- Check if the file exists at the claimed path (under `active-projects/`)
- Check if the file is not empty (has meaningful content, not just a template)
- Flag: `CODE-{N}: {PRP} — Claimed file does not exist: {path}`

### 6.3 Files Modified Verification

For each file claimed to be modified, pick 1-2 **key identifiers** from the claimed changes and grep for them:
- Example: PRP says "added CONFIG_ENABLED to config.py" → grep for `CONFIG_ENABLED` in `config.py`
- Flag: `CODE-{N}: {PRP} — Expected string "{string}" not found in {file}`

### 6.4 Cross-PRP File Overlap

Build a map of files modified across all complete/active PRPs. For files touched by 2+ PRPs:
- Read the file
- Grep for key identifiers from EACH PRP's changes
- If identifiers from one PRP are missing → flag as potential overwrite
- Flag: `CODE-{N}: {file} modified by {PRP-A} and {PRP-B} — changes from {PRP-A} appear missing`

### 6.5 Cleanup Verification

For PRPs that claim code removal/cleanup:
- Grep for the function names, variable names, or patterns claimed to be removed
- If still present → flag
- Flag: `CODE-{N}: {PRP} claims removal of {identifier} but it's still present in {file}`

### 6.6 Simple PRP Verification (Lightweight)

For simple PRPs with status "Complete":
- Only check if 1-2 key files mentioned in the PRP exist
- No deep grep needed
- Flag only if files are completely missing

### Scope Control

**DO:**
- Check file existence
- Grep for key identifiers (function names, config keys, class names)
- Flag missing files and missing identifiers

**DO NOT:**
- Do full code review
- Validate logic correctness
- Check code quality
- Read entire large files

**Use Explore agents** (Task tool with subagent_type=Explore) to parallelize this work efficiently. Group verifications by project.

---

## STEP 7: CROSS-FEATURE CONFLICT DETECTION

For ACTIVE (non-complete) phased PRPs only:

### 7.1 Extract File Lists

Read the PLAN.md of the current/next pending phase. Extract all file paths that will be modified.

### 7.2 Find Overlaps

Compare file lists across all active PRPs. Flag files that appear in 2+ active PRPs.

### 7.3 Compare with Documented Conflicts

Check if the overlap is already documented in workspace _STATUS.md's conflict analysis section.

Flag NEW overlaps not already documented:
```
CONFLICT-{N}: New file overlap between active PRPs
  File: {path}
  PRPs: {PRP-A Phase X}, {PRP-B Phase Y}
  Action: Add to workspace _STATUS.md conflict analysis
```

---

## STEP 8: GENERATE REPORT

```
========================================
CONTEXT AUDIT REPORT
========================================
Date: {today's date}

PHASED PRPs: {total found}
  Consistent: {count}
  Issues found: {count}

SIMPLE PRPs: {total found}
  Have status header: {count}
  Missing status header: {count}

FEATURE INPUTS:
  Pending: {count}
  In-Progress: {count}
  Archived: {count}
  Misplaced: {count}

KNOWLEDGE BASE:
  Total topics: {count}
  PRPs with KB entries: {count}/{total completed PRPs}
  Index in sync: {yes/no}

PROJECT DOCUMENTATION:
  Projects checked: {count}
  Up to date: {count}
  Potentially stale: {count}

CODE VERIFICATION:
  Files verified: {count}
  Missing/inconsistent: {count}

WORKSPACE _STATUS.md:
  Accurate: {yes/no}
  Issues: {count}

========================================
DOCUMENTATION ISSUES ({count})
========================================

{For each documentation issue:}

DOC-{N}: {PRP name} - {issue type}
  {description}
  Current: {current state}
  Expected: {expected state}
  Fix: {what needs to change}

KB-{N}: {issue description}

PROJ-{N}: {project} - {issue type}

========================================
CODE ISSUES ({count})
========================================

{For each code issue:}

CODE-{N}: {PRP name} - {issue type} [{severity}]
  {description}
  PRP claims: {what the PRP says}
  Actual: {what was found in code}

{Severities:}
- CRITICAL: File doesn't exist (implementation may be missing)
- WARNING: Expected content not found (may be overwritten or renamed)
- INFO: Cross-PRP overlap detected (verify both changes present)

========================================
CONFLICT ANALYSIS ({count})
========================================

CONFLICT-{N}: {description}
  File: {path}
  PRPs: {list}
  Status: Already documented / NEW - needs documentation

========================================
SUMMARY
========================================

Total Issues: {count}
  Documentation (auto-fixable): {count}
  Code (needs investigation): {count}
  Conflicts (needs documentation): {count}

{If no issues:}
All clear! Context engineering system is consistent.

{If issues found:}
Would you like me to fix the documentation issues?
- Fix all ({count} documentation fixes)
- Fix specific issues (tell me which DOC numbers)
- Skip (report only)

Note: CODE issues are flagged for your review. They may indicate
incomplete implementations or overwritten changes that need manual
investigation. They are NOT auto-fixed.
```

---

## STEP 9: APPLY FIXES (After User Approval Only)

**CRITICAL: Do NOT fix anything without explicit user approval.**

### 9.1 What Can Be Auto-Fixed (DOC issues)

- Update PRP `_STATUS.md` (status, phase, last updated date)
- Move feature inputs between folders (in-progress → archive)
- Add status headers to simple PRPs
- Update stale source document paths in PRPs
- Update workspace `_STATUS.md` entries (status, phase, counts)
- Add missing entries to "Recently Completed" section
- Remove stale conflict notes

### 9.2 What CANNOT Be Auto-Fixed (CODE issues)

- Missing source code files
- Missing code modifications
- Overwritten changes
- Incomplete cleanup
- Missing migrations

These are reported for the user to investigate manually.

### 9.3 Fix Execution Order

1. **PRP-level fixes first** (individual _STATUS.md files, source paths)
2. **Feature input moves** (archive completed feature inputs)
3. **Simple PRP status headers** (add missing headers)
4. **Workspace _STATUS.md last** (after all source data is corrected)

**Always re-read a file before editing it.** Files may have been modified by earlier fixes in the same run.

### 9.4 Post-Fix Verification

After applying fixes, do a quick re-scan to confirm:
- All fixed issues are resolved
- No new issues were introduced
- Workspace _STATUS.md counts are correct

---

## CRITICAL REMINDERS

1. **READ-ONLY FIRST** — Complete ALL auditing steps before proposing any fixes
2. **ASK BEFORE FIXING** — Never auto-fix without explicit user approval
3. **RE-READ BEFORE EDIT** — Always re-read files before modifying them
4. **CODE ISSUES ARE INFORMATIONAL** — Do NOT attempt to fix code issues, only report them
5. **ORDER MATTERS** — Fix PRP files first, workspace _STATUS.md last
6. **USE EXPLORE AGENTS** — For code verification (Step 6), use Task tool with Explore agents to parallelize file checks efficiently
7. **BE THOROUGH** — Check EVERY phased PRP, EVERY simple PRP, EVERY feature input
8. **BE CONCISE** — The report should be scannable. Use consistent formatting for every issue.

---

## SAFETY RULES

- **NEVER** commit code to GitHub
- **NEVER** modify source code files (only context-engineering documentation)
- **NEVER** run deployment commands
- **NEVER** modify PRP PLAN.md files (only _STATUS.md, HANDOFF.md, and status headers)
- **NEVER** delete any files (only move feature inputs to archive)
