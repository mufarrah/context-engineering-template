# Setup Workspace

Initialize a freshly copied Cortex workspace template. Run this command after copying the template files to your workspace and placing your projects in `active-projects/`.

**Usage:** `/setup-workspace`

---

## STEP 1: DISCOVER PROJECTS

### 1.1 Scan Active Projects

List all directories in `active-projects/` and for each project:

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
   - Note if it has its own `.git/` directory
   - Check for existing CLAUDE.md or PLANNING.md

3. **Identify key dependencies** from package manager files

### 1.2 Scan Experiments

List all directories in `experiments/` and note their tech stacks (lightweight scan).

---

## STEP 2: CREATE PROJECT DOCUMENTATION

For each project found in `active-projects/`:

### 2.1 Generate Project CLAUDE.md

If the project does NOT already have a `CLAUDE.md`:

1. Read `shared/templates/CLAUDE-template.md` as the base
2. Fill in the template with:
   - Project name and detected tech stack
   - Key coding patterns discovered from analyzing the source code
   - File organization conventions
   - Build/lint/test commands detected from package manager config
   - Important conventions from existing code patterns
3. Write to `active-projects/{project-name}/CLAUDE.md`

If the project ALREADY has a `CLAUDE.md`, **do not overwrite it**. Instead, note it in the report.

### 2.2 Generate Project PLANNING.md

If the project does NOT already have a `PLANNING.md`:

1. Read `shared/templates/PLANNING-template.md` as the base
2. Fill in the template with:
   - Project name and purpose (inferred from README or package description)
   - Tech stack details (framework version, major dependencies)
   - Architecture overview (inferred from folder structure and code patterns)
   - Key data models or schemas if discoverable
3. Write to `active-projects/{project-name}/PLANNING.md`

If the project ALREADY has a `PLANNING.md`, **do not overwrite it**.

---

## STEP 3: UPDATE ROOT DOCUMENTATION

### 3.1 Update Root CLAUDE.md

Read the current `CLAUDE.md` and update the **Project Navigation** section:

- Replace the placeholder table with actual projects discovered
- Fill in tech stack, docs location, and purpose for each project
- Add any experiments to the Experiments table

### 3.2 Update Root PLANNING.md

Read the current `PLANNING.md` and update the **Project Architecture Guides** section:

- Fill in the project table with actual projects
- Add brief architecture summaries for each project
- Document any cross-project dependencies discovered

### 3.3 Update .gitignore

If any project-specific patterns need to be added to `.gitignore`, add them.

---

## STEP 4: INITIALIZE KNOWLEDGE BASE

### 4.1 Create Implementation Sub-folders

For each project discovered in `active-projects/`:
- Create `knowledge-base/implementations/{project-name}/` directory
- Create a `_SUMMARY.md` stub in each

### 4.2 Run Knowledge Base Population

Execute the logic from `/populate-knowledge-base` to:
- Scan all projects for concepts, patterns, and flows
- Create initial topic files in the appropriate knowledge-base sections
- Generate `INDEX.md` and all `_SUMMARY.md` files

---

## STEP 5: UPDATE STATUS

Update `context-engineering/_STATUS.md` with:
- List of discovered projects and their tech stacks
- Initial workspace state (0 active PRPs, 0 features)
- Timestamp of workspace setup

---

## STEP 6: REPORT

Present a summary report to the user:

```
=== Cortex Workspace Setup Complete ===

Projects Discovered:
  - {project-name} ({tech-stack}) — {brief description}
  - ...

Documentation Created:
  - {project-name}/CLAUDE.md — {created | already existed}
  - {project-name}/PLANNING.md — {created | already existed}
  - ...

Knowledge Base:
  - {N} initial topics created
  - Implementation folders: {list}

Root Docs Updated:
  - CLAUDE.md — Project navigation table updated
  - PLANNING.md — Architecture guides updated

Next Steps:
  1. Review generated project CLAUDE.md and PLANNING.md files
  2. Customize them with project-specific details
  3. Start your first feature with /generate-requirements
```

---

## SAFETY RULES

- **NEVER overwrite existing CLAUDE.md or PLANNING.md files** — only create new ones
- **NEVER modify project source code** — this command only creates documentation files
- **NEVER commit to git** — the user handles all git operations
- **Read before writing** — always check if a file exists before creating it
