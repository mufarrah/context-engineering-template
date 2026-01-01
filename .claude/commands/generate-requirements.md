# Generate Requirements Document

## Input File: $ARGUMENTS

Transform a user's feature input into a complete, structured requirements document that is compatible with `/generate-prp`, `/execute-prp`, `/continue-prp`, and `/ensure-tracking`.

**Input:** User's raw feature ideas (from `feature_input_template.md`)
**Output:** Structured requirements document ready for `/generate-prp`

---

## STEP 1: READ USER INPUT

### 1.1 Read the Input File

- Read `$ARGUMENTS` completely
- Understand what the user wants to build
- Note their technical thoughts and constraints
- Identify any questions they have

### 1.2 Gather All Referenced Resources

**For each documentation URL provided:**
- Use WebFetch to read the documentation
- Extract relevant information for this feature
- Note important patterns, APIs, or methods

**For each file path provided:**
- Read the file
- Understand what pattern or logic the user wants you to learn
- Note code snippets that are relevant

**For pasted documentation:**
- Parse and understand the content
- Extract key requirements or patterns

**For codebase examples:**
- Read the referenced files
- Understand the patterns to follow
- Note conventions used

---

## STEP 2: CODEBASE RESEARCH

### 2.1 Explore Related Areas

Based on what the user wants, search the codebase for:

- Similar features or patterns
- Database tables that might be affected
- Types and validation schemas
- UI components that need changes
- API routes or server actions

### 2.2 Identify Impact Areas

Create a map of:
- Files that will need modification
- Tables that will need changes
- Existing features that might be affected
- Integration points

### 2.3 Find Patterns to Follow

For each major component:
- Find similar existing implementations
- Note the patterns and conventions used
- Identify reusable code or utilities

---

## STEP 3: ANALYZE & ANSWER QUESTIONS

### 3.1 Answer User Questions

For each question the user listed:
- Research the answer in the codebase
- Research externally if needed (WebSearch)
- Document your findings

### 3.2 Identify Missing Information

Based on your research, identify:
- Decisions that need to be made
- Edge cases the user hasn't considered
- Technical constraints they should know about

### 3.3 Ask Clarifying Questions (If Critical)

If there are CRITICAL ambiguities that would block implementation:
- List them clearly
- Suggest options
- Ask the user for their preference

**Do NOT ask about:**
- Minor implementation details you can decide
- Things that can be refined later
- Preferences that have obvious defaults

---

## STEP 4: DESIGN THE SOLUTION

### 4.1 Database Design

Based on requirements and codebase patterns:
- Design new tables (if needed)
- Plan table modifications
- Consider indexes and constraints
- Ensure backwards compatibility

### 4.2 User Flows

Map out how each user type will interact:
- Step-by-step flows
- What they see at each step
- Error states and edge cases

### 4.3 Architecture Decisions

For each major decision point:
- List the options
- Choose the best approach based on:
  - User's stated preferences
  - Codebase conventions
  - Technical constraints
- Document the reasoning

### 4.4 Phase Planning

If the feature is complex:
- Break into logical phases
- Each phase should be independently testable
- Order by dependencies and risk

---

## STEP 5: GENERATE REQUIREMENTS DOCUMENT

Create a structured requirements document at:
`context-engineering/{FEATURE-NAME}.md`

### Document Structure

```markdown
**FEATURE:** [{Feature Name}]

---

## HOW TO USE THIS DOCUMENT

This is a **requirements document**. To generate an implementation-ready PRP:

\`\`\`
/generate-prp context-engineering/{FEATURE-NAME}.md
\`\`\`

This will:
1. Validate all requirements
2. Research the codebase for patterns
3. Create implementation-ready PRP with phases

**Commands:**
\`\`\`bash
# Step 1: Generate the PRP
/generate-prp context-engineering/{FEATURE-NAME}.md

# Step 2: Execute Phase 0
/execute-prp context-engineering/PRPs/{FEATURE-NAME}

# Step 3+: Continue subsequent phases
/continue-prp context-engineering/PRPs/{FEATURE-NAME}

# Before closing: Verify documentation
/ensure-tracking context-engineering/PRPs/{FEATURE-NAME}
\`\`\`

---

## TECHNICAL CONSTRAINTS

{List all technical constraints discovered}

---

## QUICK REFERENCE: Key Decisions Summary

### Database Changes Required

| Table | Change | Purpose |
|-------|--------|---------|
{Fill from your analysis}

### Core Logic Decisions

| Decision | Value |
|----------|-------|
{Fill from your analysis}

---

## PLANNING AGENT: Required Reading Before Implementation

{List all files the implementing agent must read, with why}

---

# {Feature Name} - Requirements Document

## User Decisions (Confirmed)

{Document decisions made by user or derived from their input}

---

## Deep Code Analysis - Critical Findings

{Document your codebase research findings with file paths and current state}

---

## Critical Edge Cases

{Document edge cases - both from user input and discovered during research}

---

## Files That Need Modification

{Categorized list of all files that will be changed}

---

## Implementation Phases

{Break down into phases if complex, otherwise note it's a simple feature}

---

## Overall Success Criteria

{What must be true for this feature to be complete}

---

## Data Flows / User Flows

{Document key user journeys}

---

## Database Schema (Detailed)

{Complete SQL for new tables and modifications}

---

## Answers to User Questions

{Answer each question the user asked in their input}

---

## Additional Considerations

{Things you discovered during research that the user should know}
```

---

## STEP 6: QUALITY CHECK

Before finishing, verify:

- [ ] All user requirements are captured
- [ ] All referenced documentation was read and incorporated
- [ ] All referenced codebase files were analyzed
- [ ] Codebase patterns are followed
- [ ] Edge cases are documented
- [ ] Database changes are complete
- [ ] User flows are clear
- [ ] Success criteria are measurable
- [ ] Document is compatible with `/generate-prp`

---

## STEP 7: OUTPUT SUMMARY

After creating the requirements document:

```
========================================
REQUIREMENTS DOCUMENT GENERATED
========================================

Source: {input file path}
Output: context-engineering/{FEATURE-NAME}.md

Summary:
- Feature: {Brief description}
- Complexity: {Simple | Complex/Phased}
- Phases: {N} (if complex)
- Database Changes: {New tables: N, Modified: M}
- Files Affected: {count}

Research Completed:
- External docs read: {count}
- Codebase files analyzed: {count}
- Patterns identified: {count}

User Questions Answered: {count}/{total}

========================================
Next: /generate-prp context-engineering/{FEATURE-NAME}.md
========================================
```

---

## CRITICAL REMINDERS

1. **READ ALL REFERENCES** - Fetch all URLs, read all files the user mentioned
2. **RESEARCH THE CODEBASE** - Don't just use what user provided, explore further
3. **FOLLOW PATTERNS** - The generated requirements must follow codebase conventions
4. **ANSWER QUESTIONS** - User questions should be answered in the output
5. **BE COMPLETE** - The output should be detailed enough for `/generate-prp` to work
6. **ASK ONLY IF CRITICAL** - Don't ask about things you can reasonably decide

**The Goal:** Transform the user's raw ideas into a structured requirements document that an agent can use with `/generate-prp` to create an implementation-ready PRP.
