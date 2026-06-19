# {PROJECT_NAME} — Agent Instructions: Coding Standards & Architecture

**Project:** {PROJECT_DESCRIPTION}
**Framework:** {FRAMEWORK_AND_VERSION}
**Last Updated:** {YYYY-MM-DD}

> Claude Code loads this file through the project's `CLAUDE.md` (which imports it). Other agent
> tools read `AGENTS.md` directly. **Edit this file, not `CLAUDE.md`.**

---

## Quick Reference

| Need | Location |
|------|----------|
| Coding standards & architecture (this project) | This file |
| Workspace navigation & workflow | `../../AGENTS.md` (workspace root) |
| Knowledge about past decisions | `../../knowledge-base/INDEX.md` |

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

### Key Dependencies

- **{DEPENDENCY_1}** ({VERSION}) — {PURPOSE}
- **{DEPENDENCY_2}** ({VERSION}) — {PURPOSE}

---

## Common Commands

```bash
# Development
{ADD_DEV_COMMANDS_HERE}

# Testing
{ADD_TEST_COMMANDS_HERE}

# Building
{ADD_BUILD_COMMANDS_HERE}
```

---

## Code Style & Conventions

### {LANGUAGE} Conventions

```{language}
// CORRECT - {Example}
{code_example}

// WRONG - {Anti-pattern}
{anti_pattern_example}
```

### File Naming

- {FILE_NAMING_CONVENTION_1}
- {FILE_NAMING_CONVENTION_2}

### Common Patterns

#### Pattern: {PATTERN_NAME}

```{language}
// {Pattern description and usage}
{code_example}
```

### Common Mistakes to Avoid

#### Mistake 1: {MISTAKE_NAME}

```{language}
// WRONG
{wrong_code}

// CORRECT
{correct_code}
```

---

## Project Structure

```
{PROJECT_ROOT}/
├── {folder1}/                # {Description}
│   ├── {subfolder1}/         # {Description}
│   └── {subfolder2}/         # {Description}
├── {folder2}/                # {Description}
└── {folder3}/                # {Description}
```

### Key File Responsibilities

| File/Folder | Purpose | Used By |
|-------------|---------|---------|
| `{path1}` | {Purpose} | {Users} |
| `{path2}` | {Purpose} | {Users} |

---

## Architecture Overview

### High-Level Architecture

```
┌─────────────────────────────────────────┐
│         {COMPONENT_1}                   │
└───────────────┬─────────────────────────┘
                │
       ┌────────┼────────┐
   {COMP_2} {COMP_3} {COMP_4}
       │        │        │
       ▼        ▼        ▼
   {LAYER_1} {LAYER_2} {LAYER_3}
```

### Component Responsibilities

**{COMPONENT_1}:**
- {Responsibility 1}
- {Responsibility 2}

### Data Flow

```
Read:  {STEP_1} → {STEP_2} → {STEP_3}
Write: {STEP_1} → {STEP_2} → {STEP_3}
```

### Authentication & Authorization

{High-level description of how auth works, if applicable}

### Integration Points

| External Service | Purpose | Integration Method |
|------------------|---------|--------------------|
| {SERVICE_1} | {Why} | {How} |

> **Design decisions (the "why")** and detailed flows live in `../../knowledge-base/` (`decisions/`, `flows/`), not here. Keep this file a high-level map.

---

## Configuration

### Environment Variables

```bash
{ENV_VAR_1}={VALUE}
{ENV_VAR_2}={VALUE}
```

---

## Keeping This File Current

This file loads into **every** session for this project, so keep it high-signal. Update it **only** for durable, every-session facts: structure, stack, build/test/lint commands, conventions, "always/never" rules, and high-level architecture changes.

**Do NOT** put fix logs, changelogs, per-feature narratives, or transient status here — route those to the PRP's `FIXES.md`/`COMPLETED.md` and the workspace `knowledge-base/` (`gotchas/`, `decisions/`, `flows/`, `implementations/{project}/`).

---

## Summary: Key Rules

1. {RULE_1}
2. {RULE_2}
3. {RULE_3}

**When in doubt:** {GUIDANCE}

---

## Resources

- **{FRAMEWORK} Docs:** {URL}
- **{LIBRARY} Docs:** {URL}
