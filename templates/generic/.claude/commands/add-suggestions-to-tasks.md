# Add Analysis Suggestions to TASK.md

## Purpose
Checks if analyze-project command generated a _SUGGESTED file and offers to add recommendations to TASK.md under the "Discovered During Work" section.

## Usage
```bash
/add-suggestions-to-tasks
```

## What it does
1. Looks for *_SUGGESTED.md files in the context-engineering directory
2. If found, prompts user to add suggestions to TASK.md
3. Adds them under "## Discovered During Work" section
4. Comments them out by default so user can uncomment when ready

## Implementation
- Check for files matching pattern: context-engineering/*_SUGGESTED.md
- Parse suggestions from the file
- Add to context-engineering/TASK.md under appropriate section
- Comment out suggestions with `<!-- ` and ` -->`