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

### 1.2 Check Knowledge Base Context (From User Input)

The user should have filled the "Knowledge Base Context" section. Read it:

**If user listed specific topics:**
- Read each topic they mentioned from `knowledge-base/`
- Understand the context they want you to have
- Note patterns, gotchas, and decisions from those topics

**If user wrote "Not sure - agent should search":**
- You'll search the knowledge base thoroughly in Step 2
- This is fine - users may not know what's relevant yet

**Why this matters:**
- Ensures you start with the same context as the user
- Prevents you from contradicting past decisions
- Helps you follow established patterns from the start

### 1.3 Gather All Referenced Resources

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

## STEP 2: KNOWLEDGE BASE & CODEBASE RESEARCH

### 2.1 Search Knowledge Base (REQUIRED)

**ALWAYS search the knowledge base**, even if the user listed topics:

1. Read `knowledge-base/INDEX.md` to see all available topics
2. Read `_SUMMARY.md` for each relevant section
3. Read topics the user mentioned (if any)
4. **Search for additional relevant topics** the user might have missed

**What you're looking for:**
- **Concepts** - Entities/schemas this feature will use
- **Flows** - Processes this feature participates in or affects
- **Implementations** - Project-specific patterns this feature should follow
- **Gotchas** - Known pitfalls in the area this feature touches (PRIORITIZE THESE)
- **Decisions** - Past architecture decisions that affect this feature

**Document your findings:**
Create a comprehensive list of relevant KB topics with why each matters for this feature. This will go into the requirements document.

### 2.2 Explore Related Areas in Codebase

Based on what the user wants AND what you learned from the knowledge base, search the codebase for:

- Similar features or patterns
- Data models that might be affected
- Types and validation schemas
- UI components that need changes
- API routes or server actions

### 2.3 Identify Impact Areas

Create a map of:
- Files that will need modification
- Data models that will need changes
- Existing features that might be affected
- Integration points

### 2.4 Find Patterns to Follow

For each major component:
- Find similar existing implementations (using KB implementation topics as guides)
- Note the patterns and conventions used
- Identify reusable code or utilities
- **Cross-reference with KB topics** to ensure consistency

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

### 4.1 Data Model Design

Based on requirements and codebase patterns:
- Design new data models (if needed)
- Plan model modifications
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

### 4.5 Test Scenario Planning

Based on user flows and edge cases, identify high-level test scenarios that will become the basis for TEST-CASES.md during `/generate-prp`:

- **Happy path tests** — core functionality works as expected (create, read, update, delete)
- **Edge case tests** — boundary conditions, empty states, max limits, null values
- **Protection tests** — validation errors, blocked actions, access control
- **Regression tests** — existing functionality that must still work after changes

Document these in the requirements output under a "Test Scenarios" section.

---

## STEP 5: GENERATE REQUIREMENTS DOCUMENT

Create a structured requirements document at:
`context-engineering/feature-inputs/pending/{FEATURE-NAME}.md`

(The file will be moved to `in-progress/` when you start working on it, and then to `archive/feature-inputs/` when complete)

### Document Structure

```markdown
**FEATURE:** [{Feature Name}]

---

## HOW TO USE THIS DOCUMENT

This is a **requirements document**. To generate an implementation-ready PRP:

\`\`\`
/generate-prp context-engineering/feature-inputs/pending/{FEATURE-NAME}.md
\`\`\`

This will:
1. Validate all requirements
2. Research the codebase for patterns
3. Create implementation-ready PRP with phases
4. Move this file from `pending/` to `in-progress/`

**Commands:**
\`\`\`bash
# Step 1: Generate the PRP
/generate-prp context-engineering/feature-inputs/pending/{FEATURE-NAME}.md

# Step 2: Execute Phase 0
/execute-prp context-engineering/PRPs/{FEATURE-NAME}

# Step 3+: Continue subsequent phases
/continue-prp context-engineering/PRPs/{FEATURE-NAME}

# Before closing: Verify documentation
/ensure-tracking context-engineering/PRPs/{FEATURE-NAME}

# After completion: Move to archive
mv context-engineering/feature-inputs/in-progress/{FEATURE-NAME}.md context-engineering/archive/feature-inputs/
\`\`\`

---

## TECHNICAL CONSTRAINTS

{List all technical constraints discovered}

---

## QUICK REFERENCE: Key Decisions Summary

### Data Model Changes Required

| Model/Table | Change | Purpose |
|-------------|--------|---------|
{Fill from your analysis}

### Core Logic Decisions

| Decision | Value |
|----------|-------|
{Fill from your analysis}

---

## KNOWLEDGE BASE REFERENCES

{List all KB topics relevant to this feature - from user input AND your research}

\`\`\`yaml
concepts:
  - [topic-name.md] # Brief explanation of relevance

flows:
  - [flow-name.md] # Brief explanation of relevance

implementations:
  - [{project-name}/topic-name.md] # Brief explanation of relevance

gotchas:
  - [gotcha-name.md] # Brief explanation of relevance (CRITICAL - these prevent bugs)

decisions:
  - [NNN-decision-name.md] # Brief explanation of relevance
\`\`\`

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

## Test Scenarios (High-Level)

{These become the basis for TEST-CASES.md during /generate-prp. Include enough detail for the PRP generator to write concrete test cases.}

### Happy Path
- {Scenario 1: e.g., "Create a new record — verify data is saved correctly"}
- {Scenario 2: e.g., "Toggle status — verify state updates"}

### Edge Cases
- {Scenario 1: e.g., "Submit with maximum input length — should be handled"}
- {Scenario 2: e.g., "Empty state — no records exist yet"}

### Protection / Validation
- {Scenario 1: e.g., "Submit invalid data — should show error"}
- {Scenario 2: e.g., "Unauthorized action — should be blocked"}

### Regression
- {Scenario 1: e.g., "Existing CRUD operations still work unchanged"}
- {Scenario 2: e.g., "Related UI components not broken by new changes"}

---

## Data Flows / User Flows

{Document key user journeys}

---

## Data Model Schema (Detailed)

{Complete schema details for new models and modifications}

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
- [ ] **Knowledge base was searched and relevant topics identified**
- [ ] **KB References section is filled with relevant topics**
- [ ] All referenced documentation was read and incorporated
- [ ] All referenced codebase files were analyzed
- [ ] Codebase patterns are followed (and match KB implementation topics)
- [ ] **Gotchas from KB are acknowledged in requirements**
- [ ] Edge cases are documented
- [ ] **Test Scenarios section is filled** with happy path, edge cases, protection, and regression scenarios
- [ ] Data model changes are complete
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
- Data Model Changes: {New models: N, Modified: M}
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
