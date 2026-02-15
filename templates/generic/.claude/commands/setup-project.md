# Setup Project

Initialize a freshly copied Cortex single-project template. Run this command after copying the template files into your project.

**Usage:** `/setup-project`

---

## STEP 1: ANALYZE PROJECT

### 1.1 Detect Tech Stack

Scan the project root and check for:

1. **Detect tech stack** by checking for:
   - `package.json` → Node.js project (check for framework: Next.js, React, Vue, Angular, etc.)
   - `pubspec.yaml` → Flutter/Dart project
   - `requirements.txt` or `pyproject.toml` or `setup.py` → Python project
   - `go.mod` → Go project
   - `Cargo.toml` → Rust project
   - `pom.xml` or `build.gradle` → Java/Kotlin project
   - `Gemfile` → Ruby project
   - `.csproj` or `.sln` → .NET project
   - `appsscript.json` → Google Apps Script
   - If none detected → Generic project

2. **Analyze project structure:**
   - Run `ls` on the project root to understand folder organization
   - Identify key directories (src/, lib/, app/, pages/, etc.)
   - Check for existing source code patterns
   - Note testing frameworks, linting tools, build tools

3. **Identify key dependencies** from package manager files

4. **Detect build/test/lint commands** from:
   - `package.json` scripts
   - `Makefile` targets
   - CI configuration files
   - README instructions

---

## STEP 2: POPULATE CLAUDE.md

Read the current `CLAUDE.md` and fill in the skeleton sections:

### 2.1 Tech Stack Table

Fill in the **Tech Stack** table with detected framework, language, package manager, testing framework, and database.

### 2.2 Commands Section

Fill in the **Commands** section with detected build, test, lint, and dev server commands.

### 2.3 File Organization

Fill in the **File Organization** section with the actual project directory structure.

### 2.4 Coding Conventions

Analyze source code to detect and document:
- Naming conventions (camelCase, snake_case, etc.)
- Import patterns (relative vs absolute, barrel files, etc.)
- Error handling patterns
- State management approach (if applicable)

### 2.5 Important Patterns

Document 2-3 key recurring patterns found in the codebase.

---

## STEP 3: POPULATE PLANNING.md

Read the current `PLANNING.md` and fill in the skeleton sections:

### 3.1 Project Overview

Fill in the **Overview** section with:
- Architecture style (monolith, microservices, etc.)
- Key directories and their purposes

### 3.2 Data Model

If discoverable, document key data models, schemas, or types.

### 3.3 Key Flows

Document 2-3 key data flows or processes in the application.

### 3.4 API Structure

If applicable, document the API organization.

---

## STEP 4: INITIALIZE KNOWLEDGE BASE

### 4.1 Run Knowledge Base Population

Execute the logic from `/populate-knowledge-base` to:
- Scan the project for concepts, patterns, and flows
- Create initial topic files in the appropriate knowledge-base sections
- Generate `INDEX.md` and all `_SUMMARY.md` files

---

## STEP 5: UPDATE STATUS

Update `context-engineering/_STATUS.md` with:
- Detected tech stack
- Initial project state (0 active PRPs, 0 features)
- Timestamp of project setup

---

## STEP 6: REPORT

Present a summary report to the user:

```
=== Cortex Project Setup Complete ===

Project: {project-name}
Tech Stack: {detected tech stack}
Framework: {framework and version}

Documentation Updated:
  - CLAUDE.md — Coding standards, file organization, commands populated
  - PLANNING.md — Architecture, data model, key flows populated

Knowledge Base:
  - {N} initial topics created
  - INDEX.md generated

Next Steps:
  1. Review CLAUDE.md and customize the coding standards
  2. Review PLANNING.md and add architecture details
  3. Start your first feature with /generate-requirements
```

---

## SAFETY RULES

- **NEVER modify project source code** — this command only creates/updates documentation files
- **NEVER commit to git** — the user handles all git operations
- **Read before writing** — always read existing file content before updating
- **Preserve user customizations** — if a section already has user content, do not overwrite it
