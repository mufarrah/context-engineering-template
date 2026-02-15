# Feature Input Template

## How to Use

1. Copy this template to `context-engineering/feature-inputs/pending/{feature-name}.md`
2. Fill in whatever you know - leave sections blank if unsure
3. Run `/generate-requirements context-engineering/feature-inputs/pending/{feature-name}.md`
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

- {User type 1: e.g., "Admin users from the dashboard"}
- {User type 2: e.g., "End users via the web app"}

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

### Knowledge Base Context (REQUIRED)

> Check `knowledge-base/INDEX.md` and list relevant topics this feature relates to. This ensures you and the agent start with the right context.

**Concepts this feature uses:**
- {List topics from knowledge-base/concepts/ that this feature involves}

**Flows this feature affects:**
- {List topics from knowledge-base/flows/ that this feature touches}

**Implementation patterns to follow:**
- {List topics from knowledge-base/implementations/{project}/ with relevant patterns}

**Known gotchas to avoid:**
- {List topics from knowledge-base/gotchas/ relevant to this area}

**Architecture decisions to follow:**
- {List topics from knowledge-base/decisions/ that affect this feature}

_If you're unsure, write "Not sure - agent should search" and the agent will research automatically._

### External Documentation

| URL           | What It Covers                         |
| ------------- | -------------------------------------- |
| {https://...} | {Description of what to learn from it} |

### Files in This Project

| File Path                   | Why It's Relevant                  |
| --------------------------- | ---------------------------------- |
| {src/path/to/file}          | {What pattern or logic to look at} |

### Paste Documentation Here

> If you have docs to paste directly, put them here in code blocks.

```
{Paste documentation, API specs, or other text here}
```

---

## Examples & Inspiration

> How similar features work - in this codebase or elsewhere.

### From This Codebase

| File/Feature                 | What to Learn From It    |
| ---------------------------- | ------------------------ |
| {src/path/to/similar-feature} | {What pattern to follow} |

### From Other Apps/Sources

| Source                   | Description                  |
| ------------------------ | ---------------------------- |
| {App name or URL}        | {What to copy/learn from it} |

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
