# Feature Input Template

## How to Use

1. Copy this template to `context-engineering/{feature-name}-input.md`
2. Fill in whatever you know - leave sections blank if unsure
3. Run `/generate-requirements context-engineering/{feature-name}-input.md`
4. Agent will analyze, research, and create a complete requirements document

---

**FEATURE NAME:** {What do you call this feature?}

---

## What I Want

> Describe the feature in your own words. Be as detailed or brief as you want.

{Write freely here - what should this feature do? What problem does it solve?}

---

## Who Uses It

> Who will use this feature?

- {User type 1: e.g., "Coaches from their dashboard"}
- {User type 2: e.g., "Guests via online booking"}

---

## How It Should Work

> Describe the user experience. What does the user see/do?

{Step by step flow, or just general description}

---

## Technical Thoughts

> Any technical ideas or constraints you have in mind. Leave blank if unsure.

**Database ideas:**
{Any tables, columns, or data you're thinking about}

**Existing code to modify:**
{Files or features you think need to change}

**Must NOT break:**
{Existing features that must continue working}

---

## Documentation & References

> Paste links, file paths, or documentation that the agent should read.

### External Documentation

| URL           | What It Covers                         |
| ------------- | -------------------------------------- |
| {https://...} | {Description of what to learn from it} |
| {https://...} | {Description}                          |

### Files in This Project

| File Path                   | Why It's Relevant                  |
| --------------------------- | ---------------------------------- |
| {src/path/to/file.ts}       | {What pattern or logic to look at} |
| {src/path/to/component.tsx} | {What to understand from it}       |

### Paste Documentation Here

> If you have docs to paste directly, put them here in code blocks.

```
{Paste documentation, API specs, or other text here}
```

---

## Examples & Inspiration

> How similar features work - in this codebase or elsewhere.

### From This Codebase

| File/Feature                     | What to Learn From It    |
| -------------------------------- | ------------------------ |
| {src/path/to/similar-feature.ts} | {What pattern to follow} |
| {Existing feature name}          | {How it handles X}       |

### From Other Apps/Sources

| Source                   | Description                  |
| ------------------------ | ---------------------------- |
| {App name or URL}        | {What to copy/learn from it} |
| {Screenshot description} | {What it shows}              |

### Code Examples

> Paste actual code examples the agent should follow.

```typescript
// Example from: {source}
// What this shows: {description}

{paste code here}
```

```typescript
// Another example
{paste code here}
```

---

## Edge Cases I'm Thinking About

> Weird scenarios that might happen.

- {Edge case 1}
- {Edge case 2}

---

## Questions I Have

> Things you're unsure about - agent will try to answer or ask you.

- {Question 1}
- {Question 2}

---

## Constraints & Must-Haves

> Non-negotiable requirements.

- {Constraint 1: e.g., "Must work on mobile"}
- {Constraint 2: e.g., "Cannot change existing API"}

---

## Priority / Timeline

> How important is this? Any deadlines?

**Priority:** {High / Medium / Low}
**Notes:** {Any timeline considerations}

---

## Other Notes

> Anything else relevant - random thoughts, concerns, ideas.

{Free form notes}
