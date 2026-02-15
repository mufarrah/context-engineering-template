# Update Template

Safely pull the latest Cortex template updates from GitHub without overwriting your customizations.

**Usage:** `/update-template`

---

## STEP 1: READ CURRENT VERSION

1. Read the `.template-version` file in the workspace root
2. If missing, assume version `1.0.0` and create the file

---

## STEP 2: FETCH LATEST VERSION

1. Use the `gh` CLI to check the latest release of the Cortex template repository:
   ```bash
   gh release view --repo {cortex-template-repo} --json tagName,body
   ```
2. Compare the current version with the latest release version
3. If already up to date, report and exit:
   ```
   Cortex template is up to date (v{version}).
   ```
4. If a newer version exists, list the changelog/release notes for the user

---

## STEP 3: CLASSIFY FILES

Classify all template files into three categories:

### Infrastructure (Safe to Update)
These are "system" files that contain command logic, skill definitions, and templates. They can be safely updated without losing user work:

- `.claude/commands/*.md` — All command files
- `.claude/skills/*/` — All skill files
- `knowledge-base/_TEMPLATES/*.md` — KB topic templates
- `context-engineering/PRPs/templates/*.md` — PRP templates
- `shared/templates/*.md` — Project doc templates
- `shared/docs/*.md` — Documentation guides

### User Content (Never Touch)
These contain user-specific work and customizations. NEVER modify or overwrite:

- `CLAUDE.md` — Root navigation (customized with project info)
- `PLANNING.md` — Root philosophy (customized with architecture)
- `knowledge-base/concepts/`, `flows/`, `implementations/`, `gotchas/`, `decisions/` — All topic files (excluding _TEMPLATES)
- `context-engineering/feature-inputs/` — All feature inputs
- `context-engineering/PRPs/` — All PRPs (excluding templates/)
- `context-engineering/_STATUS.md` — Workspace status
- `active-projects/` — All project content
- `experiments/` — All experiments
- `archive/` — All archived content

### Review Candidates (Show Diff, Ask User)
These may have both template structure and user customizations:

- `CONFIG.md` — May have new commands added
- `.gitignore` — May have new patterns
- `README.md` — May have new sections

---

## STEP 4: DOWNLOAD AND COMPARE

For each **Infrastructure** file:

1. Download the latest version from the release
2. Compare with the current local version
3. If different, show the diff to the user:
   ```
   === .claude/commands/generate-prp.md ===
   Changes: {brief description of what changed}

   [Show diff]

   Update this file? (y/n)
   ```
4. Track which files the user approves for update

For each **Review Candidate** file:

1. Download the latest version
2. Show the diff with clear annotations of what's new
3. Ask the user whether to:
   - **Update**: Replace with new version
   - **Skip**: Keep current version
   - **Merge**: Manually review and merge specific sections

---

## STEP 5: CHECK FOR NEW FILES

1. Compare the file list in the latest release with local files
2. For any files that exist in the latest release but NOT locally:
   ```
   New files available in v{version}:
   - .claude/commands/new-command.md — {description}
   - .claude/skills/new-skill/ — {description}

   Add these files? (y/n for each)
   ```
3. Create any files the user approves

---

## STEP 6: APPLY UPDATES

1. Apply all approved file updates
2. Update `.template-version` to the new version number
3. Report summary:
   ```
   === Cortex Template Updated: v{old} → v{new} ===

   Updated Files:
   - .claude/commands/generate-prp.md
   - .claude/commands/execute-prp.md
   - ...

   New Files Added:
   - .claude/commands/new-command.md
   - ...

   Skipped (user choice):
   - CONFIG.md
   - ...

   Unchanged (user content preserved):
   - CLAUDE.md
   - PLANNING.md
   - knowledge-base/* (all topics)
   - context-engineering/* (all PRPs and features)
   - active-projects/* (all projects)
   ```

---

## SAFETY RULES

- **NEVER modify User Content files** — These are sacred and belong to the user
- **NEVER force-update** — Always show diffs and ask for approval
- **NEVER delete files** — Only add or update
- **NEVER commit to git** — The user handles all git operations
- **Always create backups** before updating Review Candidate files (save as `{filename}.backup`)

---

## FALLBACK: No GitHub Access

If the `gh` CLI is not available or the repo is not accessible:

1. Inform the user:
   ```
   Cannot access GitHub. To update manually:
   1. Download the latest release from {repo-url}
   2. Place the downloaded template in a temporary directory
   3. Run: /update-template --local {path-to-downloaded-template}
   ```
2. If `--local` path is provided, use that directory as the source instead of GitHub
