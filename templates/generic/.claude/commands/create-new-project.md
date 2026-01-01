# /create-new-project

Creates a new project with Context Engineering pre-configured.

## Usage
```
/create-new-project project-name tech-stack
```

## Parameters
- `project-name`: Name for the new project
- `tech-stack`: Technology stack (next-firebase, next-supabase, flutter-supabase)

## What it does

1. **Creates new project** using appropriate CLI tools:
   - Next.js: `npx create-next-app@latest`
   - Flutter: `flutter create`

2. **Applies Context Engineering immediately**:
   - Sets up appropriate template
   - Configures development environment
   - Adds all necessary documentation
   - Installs PRP templates (feature_input_template.md, prp_complex.md)
   - Sets up all Claude Code commands

3. **Initializes git repository**:
   - Creates initial commit
   - Sets up .gitignore properly
   - Prepares for remote repository

4. **Provides next steps**:
   - Environment setup instructions
   - Initial feature suggestions
   - Team onboarding guide
   - Available commands reference (see CONFIG.md)

## Implementation

When this command is executed:

1. Parse the arguments to get project name and tech stack
2. Run appropriate project creation command
3. Navigate to new project directory  
4. Apply Context Engineering setup
5. Initialize git and create initial commit
6. Provide setup completion summary

This creates a fully configured project ready for AI-assisted development from day one.