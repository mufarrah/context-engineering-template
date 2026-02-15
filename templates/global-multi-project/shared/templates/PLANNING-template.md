# {PROJECT_NAME} - Architecture & Planning

**Project:** {PROJECT_DESCRIPTION}
**Last Updated:** {YYYY-MM-DD}

---

## Quick Reference

| What You Need | Where to Find It |
|---------------|------------------|
| Coding standards | [`CLAUDE.md`](CLAUDE.md) (this project) |
| Workspace philosophy | `../../PLANNING.md` (root) |
| Workspace navigation | `../../CLAUDE.md` (root) |

---

## Executive Summary

### What is {PROJECT_NAME}?

{1-2 paragraphs describing the project's purpose, users, and core functionality}

### Architecture in One Sentence

{Single sentence summarizing the architectural approach}

---

## Technology Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| **{LAYER_1}** | {TECH_1} | {VERSION} | {PURPOSE} |
| **{LAYER_2}** | {TECH_2} | {VERSION} | {PURPOSE} |
| **{LAYER_3}** | {TECH_3} | {VERSION} | {PURPOSE} |

### Key Dependencies

- **{DEPENDENCY_1}** ({VERSION}) - {PURPOSE}
- **{DEPENDENCY_2}** ({VERSION}) - {PURPOSE}

---

## Folder Structure

```
{PROJECT_ROOT}/
├── {folder1}/                # {Description}
│   ├── {subfolder1}/         # {Description}
│   └── {subfolder2}/         # {Description}
│
├── {folder2}/                # {Description}
│
└── {folder3}/                # {Description}
```

---

## Architecture Overview

### High-Level Architecture

```
┌─────────────────────────────────────────┐
│         {COMPONENT_1}                   │
└───────────────┬─────────────────────────┘
                │
       ┌────────┼────────┐
       │        │        │
   {COMP_2} {COMP_3} {COMP_4}
       │        │        │
       ▼        ▼        ▼
   {LAYER_1} {LAYER_2} {LAYER_3}
```

### Component Responsibilities

**{COMPONENT_1}:**
- {Responsibility 1}
- {Responsibility 2}

---

## Data Flow Patterns

### Read Flow (Data Fetching)

```
{STEP_1} → {STEP_2} → {STEP_3} → {STEP_4}
```

### Write Flow (Mutations)

```
{STEP_1} → {STEP_2} → {STEP_3} → {STEP_4}
```

---

## Authentication & Authorization

### Authentication Model

{Description of how authentication works}

### Authorization Strategy

{Description of how permissions/authorization works}

---

## Key Features

### Feature 1: {FEATURE_NAME}

**Description:** {What it does}

**Key Files:**
- `{file1}` - {Purpose}
- `{file2}` - {Purpose}

---

## Integration Points

### {EXTERNAL_SERVICE_1}

**Purpose:** {Why we integrate with this}
**Integration Method:** {How we integrate}

---

## Build & Deployment

### Build Process

```bash
{BUILD_COMMAND_1}
{BUILD_COMMAND_2}
```

### Deployment Strategy

{Description of how deployment works}

---

## Testing Strategy

### Unit Tests

{Description of unit testing approach}

### Integration Tests

{Description of integration testing approach}

---

## Key Architectural Decisions

### Decision 1: {DECISION_NAME}

**Context:** {Why this decision was needed}
**Decision:** {What was decided}
**Rationale:** {Why this was chosen}

---

## Future Enhancements

### Planned Features

1. **{FEATURE_1}:** {Description}
2. **{FEATURE_2}:** {Description}

### Technical Debt

1. **{DEBT_ITEM_1}:** {Description and plan}

---

## Summary

{PROJECT_NAME} is built with {CORE_TECHNOLOGIES} and follows {ARCHITECTURAL_PATTERN}. The key principles are:

1. {PRINCIPLE_1}
2. {PRINCIPLE_2}
3. {PRINCIPLE_3}

For coding conventions, see [`CLAUDE.md`](CLAUDE.md).
