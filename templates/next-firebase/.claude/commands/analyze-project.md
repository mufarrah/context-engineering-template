# /analyze-project

Analyzes the current Next.js + Firebase project structure and generates customized context engineering files based on existing patterns and conventions.

## Usage
```
/analyze-project
```

## What it does

1. **Scans project structure** to understand:
   - Directory organization
   - Component patterns
   - Firebase integration approach
   - Testing setup
   - State management solution

2. **Analyzes code patterns**:
   - Naming conventions
   - Import styles
   - TypeScript usage
   - Firebase SDK usage (client vs admin)
   - Authentication patterns

3. **Generates or updates**:
   - Customized PLANNING.md based on actual structure
   - Updated CLAUDE.md with detected conventions
   - Task list based on TODOs and comments
   - Example patterns from existing code

4. **Creates recommendations** for:
   - Missing Firebase security rules
   - Potential performance improvements
   - Testing gaps
   - Architecture improvements

## Implementation

When this command is run:

1. Use Glob to find all TypeScript/JavaScript files
2. Analyze directory structure and naming patterns
3. Grep for Firebase imports to understand usage
4. Check test files to understand testing approach
5. Read package.json for dependencies
6. Generate comprehensive analysis report
7. Create/update context files based on findings

The analysis should be non-destructive and create new files with `_SUGGESTED` suffix if files already exist.