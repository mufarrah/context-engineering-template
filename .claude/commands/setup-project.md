# /setup-project

Sets up Context Engineering in any project using the templates from this repository.

## Usage
```
/setup-project [project-path] [template-type]
```

## Parameters
- `project-path` (optional): Path to target project. If not provided, will prompt.
- `template-type` (optional): Template type (next-firebase, next-supabase, flutter-supabase, auto). Defaults to auto-detection.

## What it does

1. **Detects project type** by analyzing:
   - package.json for Node.js/Next.js projects
   - pubspec.yaml for Flutter projects
   - Dependencies to determine backend (Firebase/Supabase)

2. **Applies appropriate template**:
   - Copies CLAUDE.md with tech-stack-specific rules
   - Creates PLANNING.md template
   - Sets up TASK.md for project tracking
   - Adds setup scripts and documentation

3. **Analyzes existing project** (if applicable):
   - Scans current structure and patterns
   - Creates recommendations in CONTEXT_ANALYSIS.md
   - Suggests customizations

4. **Creates ready-to-use system**:
   - All files needed for AI-assisted development
   - Validation scripts for quality assurance
   - Documentation for team usage

## Implementation

Execute the universal setup script from this repository:

```bash
bash setup-context-engineering.sh "$ARGUMENTS"
```

This command allows you to apply Context Engineering to any project directly from this single source repository without needing separate template copies.