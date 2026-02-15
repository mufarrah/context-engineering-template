name: "Cortex Base PRP Template - Context-Rich with Validation Loops"
description: |

## Purpose
Template optimized for AI agents to implement features with sufficient context and self-validation capabilities to achieve working code through iterative refinement.

## Core Principles
1. **Context is King**: Include ALL necessary documentation, examples, and caveats
2. **Validation Loops**: Provide executable tests/lints the AI can run and fix
3. **Information Dense**: Use keywords and patterns from the codebase
4. **Progressive Success**: Start simple, validate, then enhance
5. **Global rules**: Be sure to follow all rules in CLAUDE.md

---

## Goal
[What needs to be built - be specific about the end state and desires]

## Why
- [Business value and user impact]
- [Integration with existing features]
- [Problems this solves and for whom]

## What
[User-visible behavior and technical requirements]

### Success Criteria
- [ ] [Specific measurable outcomes]

## All Needed Context

### Knowledge Base References
```yaml
# Relevant topics from the knowledge-base/ folder
# When executing this PRP, agents should read these topics for context

concepts:
  - [topic-name.md] # What concepts this feature uses

flows:
  - [flow-name.md] # What processes this feature interacts with

implementations:
  - [{project}/topic-name.md] # Project-specific patterns to follow

gotchas:
  - [gotcha-name.md] # Known pitfalls to avoid

decisions:
  - [NNN-decision-name.md] # Why certain approaches were chosen
```

### Documentation & References (list all context needed to implement the feature)
```yaml
# MUST READ - Include these in your context window
- url: [Official API docs URL]
  why: [Specific sections/methods you'll need]

- file: [path/to/example-file]
  why: [Pattern to follow, gotchas to avoid]

- doc: [Library documentation URL]
  section: [Specific section about common pitfalls]
  critical: [Key insight that prevents common errors]
```

### Current Codebase tree (run `tree` in the root of the project) to get an overview of the codebase
```bash

```

### Desired Codebase tree with files to be added and responsibility of file
```bash

```

### Known Gotchas of our codebase & Library Quirks
```
# CRITICAL: [Library name] requires [specific setup]
# Example: This ORM doesn't support batch inserts over 1000 records
# Example: API rate limits to 10 req/sec
```

## Implementation Blueprint

### Data models and structure

Create the core data models, ensuring type safety and consistency.
```
Examples:
 - database models / schemas
 - type definitions / interfaces
 - validation schemas
 - data transfer objects
```

### List of tasks to be completed to fulfill the PRP in the order they should be completed

```yaml
Task 1:
MODIFY src/existing_module:
  - FIND pattern: "class OldImplementation"
  - INJECT after line containing "def __init__"
  - PRESERVE existing method signatures

CREATE src/new_feature:
  - MIRROR pattern from: src/similar_feature
  - MODIFY class name and core logic
  - KEEP error handling pattern identical

...(...)

Task N:
...
```


### Per task pseudocode as needed added to each task
```
# Task 1
# Pseudocode with CRITICAL details - don't write entire code
async function newFeature(param) -> Result:
    # PATTERN: Always validate input first (see src/validators)
    validated = validateInput(param)  # raises ValidationError

    # GOTCHA: This library requires connection pooling
    connection = getConnection()  # see src/db/pool

    # CRITICAL: API returns 429 if >10 req/sec
    await rateLimiter.acquire()
    result = await externalApi.call(validated)

    # PATTERN: Standardized response format
    return formatResponse(result)  # see src/utils/responses
```

### Integration Points
```yaml
DATABASE:
  - migration: "Add column 'feature_enabled' to users table"
  - index: "CREATE INDEX idx_feature_lookup ON users(feature_id)"

CONFIG:
  - add to: config/settings
  - pattern: "FEATURE_TIMEOUT = env('FEATURE_TIMEOUT', '30')"

ROUTES:
  - add to: src/api/routes
  - pattern: "register feature route at /feature"
```

## Validation Loop

### Level 1: Syntax & Style
```bash
# Run these FIRST - fix any errors before proceeding
# Use your project's build/lint commands from CLAUDE.md

{project build command}     # Must pass
{project lint command}      # Must pass

# Expected: No errors. If errors, READ the error and fix.
```

### Level 2: Unit Tests - each new feature/file/function use existing test patterns
```
# CREATE test file with these test cases:

test_happy_path():
    """Basic functionality works"""
    result = newFeature("valid_input")
    assert result.status == "success"

test_validation_error():
    """Invalid input raises error"""
    expect(() => newFeature("")).toThrow()

test_external_api_timeout():
    """Handles timeouts gracefully"""
    mock externalApi.call to throw TimeoutError
    result = newFeature("valid")
    assert result.status == "error"
```

```bash
# Run and iterate until passing:
{project test command}
# If failing: Read error, understand root cause, fix code, re-run (never mock to pass)
```

### Level 3: Integration Test
```bash
# Start the service/dev server
{project start command}

# Test the feature end-to-end
{specific test commands from project CLAUDE.md}

# Expected: Feature works as specified
# If error: Check logs for stack trace
```

## Final Validation Checklist
- [ ] All tests pass: `{project test command}`
- [ ] No linting errors: `{project lint command}`
- [ ] No type errors: `{project type-check command}`
- [ ] Manual test successful
- [ ] Error cases handled gracefully
- [ ] Logs are informative but not verbose
- [ ] Documentation updated if needed

---

## Test Cases

Test cases for agent-guided walkthrough after implementation. The agent walks the user through each test case, validates results, and marks pass/fail.

See `context-engineering/PRPs/templates/test_cases_template.md` for full template and guidelines.

### Testing Approach
{Describe how to test — read target project's CLAUDE.md for project-specific validation methods:}
- **Database reads:** {project-specific query tool or CLI}
- **Database writes:** {project-specific write validation method}
- **UI testing:** Dev server / app running, user performs actions
- **API testing:** curl commands to endpoints

### Test Cases

{Group by feature area. Each test case needs: Steps, Expected, Validation, Status.}

#### TC-1: {Happy path test}
**Steps:**
1. {Step 1}
2. {Step 2}

**Expected:**
- {Expected outcome}

**Validation:**
```
{Concrete validation command or query}
```

**Status:** Not Tested

---

#### TC-2: {Edge case / protection test}
**Steps:**
1. {Step 1}

**Expected:**
- {Expected blocking behavior or error}

**Status:** Not Tested

---

### Test Execution Tracker

| ID | Description | Status | Notes |
|----|-------------|--------|-------|
| TC-1 | {Description} | Not Tested | |
| TC-2 | {Description} | Not Tested | |

---

## Anti-Patterns to Avoid
- Don't create new patterns when existing ones work
- Don't skip validation because "it should work"
- Don't ignore failing tests - fix them
- Don't hardcode values that should be config
- Don't catch all exceptions - be specific
