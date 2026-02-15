# Test Cases Template

## Purpose
Template for generating test cases for each PRP phase. Used by `/generate-prp` to create TEST-CASES.md files that the agent uses during guided testing walkthroughs in `/execute-prp` and `/continue-prp`.

## When to Use
- **Phased PRPs:** Create a separate `TEST-CASES.md` file in each phase folder
- **Simple PRPs:** Add an inline "Test Cases" section in the PRP file itself

## Key Principles
1. **Project-agnostic** — The "Testing Approach" section adapts to whichever project is being tested
2. **Agent-guided** — Test cases are designed for the agent to walk the user through step by step
3. **Validated** — Every test case that touches data includes a validation query or command the agent runs
4. **Trackable** — Status indicators and execution tracker table provide clear progress visibility

---

## FILE TEMPLATE

```markdown
# Phase {N}: Test Cases — {Phase Name}

**Tester:** User ({action type — UI actions / runs commands / inspects files})
**Validator:** AI Agent ({validation method — runs queries / checks files / runs commands})
**Date:** {date}

---

## Testing Approach

{Brief description of how this phase should be tested — what the user does and what the agent validates.}

### Database Validation Method

{Project-specific instructions — filled by /generate-prp based on the target project's CLAUDE.md.}

{Describe the validation tools available for this project:}
- **Database queries:** {How to query the database — CLI tool, MCP tool, ORM console, etc.}
- **API testing:** {curl commands, Postman, etc.}
- **Build verification:** {project build/lint/test commands}
- **UI testing:** {Dev server / app must be running}

---

## Pre-requisites

Before testing:
- [ ] {Phase N} implementation complete
- [ ] {Build/analyze command} passes with no errors
- [ ] {Dev server / app / service} running
- [ ] {Required test data exists — describe specific data needed}

---

## SECTION A: {Section Name — group related tests}

### TC-A1: {Test Case Title}
**Steps:**
1. {User action step 1}
2. {User action step 2}
3. {User action step 3}

**Expected:**
- {Expected outcome 1}
- {Expected outcome 2}
- {Expected UI feedback — toast, redirect, state change}

**DB Validation:**
```sql
-- Agent runs this after user performs steps
{Concrete SQL query — NOT a placeholder. Use actual table names, column names, and WHERE clauses.}
```

**Status:** Not Tested

---

### TC-A2: {Test Case Title}
**Steps:**
1. {Step 1}
2. {Step 2}

**Expected:**
- {Expected outcome}

**DB Validation:**
```sql
{SQL query}
```

**Status:** Not Tested

---

## SECTION B: {Section Name}

### TC-B1: {Test Case Title}
...

---

## SECTION C: {Edge Cases & Protection}

### TC-C1: {Edge case or validation test}
**Setup:** {Any special setup needed — DB state, config changes}

**Steps:**
1. {Step 1}

**Expected:**
- {Expected blocking behavior or error message}

**DB Validation:**
```sql
-- Verify nothing changed (protection test)
{SQL query confirming state unchanged}
```

**Status:** Not Tested

---

## SECTION D: {Regression — Existing Functionality}

### TC-D1: {Existing feature still works}
**Steps:**
1. {Perform existing action that should still work}

**Expected:**
- {Same behavior as before implementation}

**Status:** Not Tested

---

## Test Execution Tracker

| ID | Description | Status | Notes |
|----|-------------|--------|-------|
| **SECTION A: {Name}** | | | |
| TC-A1 | {Short description} | Not Tested | |
| TC-A2 | {Short description} | Not Tested | |
| **SECTION B: {Name}** | | | |
| TC-B1 | {Short description} | Not Tested | |
| **SECTION C: {Edge Cases}** | | | |
| TC-C1 | {Short description} | Not Tested | |
| **SECTION D: {Regression}** | | | |
| TC-D1 | {Short description} | Not Tested | |
```

---

## STATUS LEGEND

| Status | Meaning |
|--------|---------|
| Not Tested | Test has not been executed yet |
| Passed | Passed — with date and notes |
| Failed | Failed — logged in FIXES.md |
| N/A | Not Applicable — with reason |

---

## GUIDELINES FOR GENERATING TEST CASES

When `/generate-prp` creates TEST-CASES.md files, follow these rules:

### Test Case Coverage
1. **Happy path** — Every task in PLAN.md should have at least one test verifying its expected outcome
2. **Edge cases** — Boundary conditions, empty states, max limits, null values
3. **Protection/validation** — Blocked actions, error messages, access control
4. **Regression** — Existing functionality that must still work after changes

### DB Validation Queries
- Use **concrete SQL** with actual table/column names — never `{placeholder}`
- Include `WHERE` clauses that narrow to the specific test data
- For protection tests, use queries that confirm state was NOT changed
- Use `ORDER BY` and `LIMIT` to get deterministic results

### Section Organization
- Group by **feature area**, not by test type
- Alphabetical section letters: A, B, C...
- Sequential test numbers within sections: TC-A1, TC-A2...
- Put regression tests in their own section (usually last)

### Pre-requisites
- Be specific about test data: names, IDs, counts
- Include setup SQL if test data needs to be created
- Reference previous phase completions where applicable

### Test Case Size
- Aim for **5-30 test cases per phase** depending on complexity
- Low-risk phases (type changes, wiring): 5-10 cases
- High-risk phases (forms, business logic): 15-30 cases
- Each test case should be independently verifiable
