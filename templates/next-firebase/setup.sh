#!/bin/bash

# Context Engineering Setup Script for Next.js + Firebase Projects
# This script sets up the context engineering system in your project

set -e

echo "🚀 Setting up Context Engineering for Next.js + Firebase..."

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "⚠️  Warning: Not in a git repository. It's recommended to initialize git first."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if this is a new or existing project
if [ -f "package.json" ]; then
    echo "📦 Detected existing Next.js project"
    PROJECT_TYPE="existing"
else
    echo "✨ Setting up for new project"
    PROJECT_TYPE="new"
fi

# Create context engineering directories first
echo "📁 Creating context engineering directories..."
mkdir -p context-engineering/PRPs/examples .claude/commands

# Copy base files
echo "📄 Copying context engineering files..."
if [ -f "context-engineering/CLAUDE.md" ]; then
    echo "📝 CLAUDE.md exists. Creating CLAUDE_NEW.md for reference..."
    cp "$SCRIPT_DIR/CLAUDE.md" ./context-engineering/CLAUDE_NEW.md
    echo "   Please review and merge CLAUDE_NEW.md with your existing CLAUDE.md"
else
    cp "$SCRIPT_DIR/CLAUDE.md" ./context-engineering/CLAUDE.md
    echo "   Created context-engineering/CLAUDE.md"
fi

# Copy CONFIG.md (always update)
cp "$SCRIPT_DIR/CONFIG.md" ./CONFIG.md
cp "$SCRIPT_DIR/../../INITIAL_EXAMPLE.md" ./context-engineering/ 2>/dev/null || echo "   INITIAL_EXAMPLE.md not found"
echo "   Created/Updated CONFIG.md"

# Create or update PLANNING.md
if [ -f "context-engineering/PLANNING.md" ]; then
    echo "📝 PLANNING.md exists. Creating PLANNING_NEW.md for reference..."
    cp "$SCRIPT_DIR/PLANNING_TEMPLATE.md" ./context-engineering/PLANNING_NEW.md
    echo "   Please merge PLANNING_NEW.md with your existing PLANNING.md"
else
    cp "$SCRIPT_DIR/PLANNING_TEMPLATE.md" ./context-engineering/PLANNING.md
    echo "   Created context-engineering/PLANNING.md - Please customize it for your project"
fi

# Create TASK.md if it doesn't exist
if [ ! -f "context-engineering/TASK.md" ]; then
    cat > context-engineering/TASK.md << 'EOF'
# Task Tracking

## Active Tasks

### $(date +%Y-%m-%d) - Initial Setup
- [ ] Configure Firebase project
- [ ] Set up environment variables
- [ ] Implement authentication
- [ ] Set up Firestore collections
- [ ] Configure security rules

## Completed Tasks
<!-- Move completed tasks here -->

## Discovered During Work
<!-- Add new tasks discovered during development -->
EOF
    echo "   Created context-engineering/TASK.md"
fi

# Create INITIAL.md template
if [ ! -f "context-engineering/INITIAL.md" ]; then
    cat > context-engineering/INITIAL.md << 'EOF'
# FEATURE: [Feature Name]

<!-- 
This file is used to describe new features before implementation.
It will be used to generate a comprehensive PRP (Product Requirements Prompt).
-->

[Describe what you want to build in detail]

## Requirements:
- [List specific requirements]
- [Include technical constraints]
- [Define success criteria]

## Technical Constraints:
- Must use Firebase Auth for authentication
- Must follow existing patterns in PLANNING.md
- Must include proper TypeScript types
- Must have test coverage

# EXAMPLES

Look at these files for patterns to follow:
- `${BASE_DIR}/components/` - Existing component patterns
- `${BASE_DIR}/lib/firebase/` - Firebase integration patterns
- [Add specific example files from your project]

# DOCUMENTATION

- [Firebase Auth Docs](https://firebase.google.com/docs/auth/web/start)
- [Firestore Docs](https://firebase.google.com/docs/firestore)
- [Next.js Docs](https://nextjs.org/docs)
- [Add project-specific documentation links]

# OTHER_CONSIDERATIONS

## Edge Cases to Handle:
- [List potential edge cases]
- Network errors
- Auth state changes
- Firebase quota limits

## Security Considerations:
- Implement proper Firestore security rules
- Validate all inputs
- Handle authentication properly
- Never expose sensitive data

## Performance Requirements:
- Minimize Firestore reads
- Implement proper caching
- Lazy load components
- Optimize bundle size
EOF
    echo "   Created context-engineering/INITIAL.md template"
fi

# Only create project structure for new projects
if [ "$PROJECT_TYPE" = "new" ]; then
    echo ""
    echo "🏗️  Would you like to create the recommended project structure?"
    echo "   This will create: lib/firebase/, components/, hooks/ directories"
    read -p "   Create project structure? (y/n) " -n 1 -r CREATE_STRUCTURE
    echo
    
    if [[ $CREATE_STRUCTURE =~ ^[Yy]$ ]]; then
        # Detect if project uses src directory
        if [ -d "src" ]; then
            echo "📁 Detected src/ directory structure"
            BASE_DIR="src"
        else
            echo "📁 Using root directory structure"
            BASE_DIR="."
        fi
        
        mkdir -p "$BASE_DIR/lib/firebase" "$BASE_DIR/components" "$BASE_DIR/hooks"
        echo "   Created project structure directories"
    else
        echo "   Skipping project structure creation"
        BASE_DIR="."
    fi
else
    echo "📦 Existing project detected - skipping project structure creation"
    # Still detect BASE_DIR for file references
    if [ -d "src" ]; then
        BASE_DIR="src"
    else
        BASE_DIR="."
    fi
fi

# Copy command files
cp -r "$SCRIPT_DIR/.claude/commands/"* ./.claude/commands/ 2>/dev/null || echo "   No Claude commands to copy"

# Copy core context engineering commands from root
if [ -d "$SCRIPT_DIR/../../.claude/commands" ]; then
    cp "$SCRIPT_DIR/../../.claude/commands/generate-prp.md" ./.claude/commands/ 2>/dev/null || echo "   generate-prp.md not found"
    cp "$SCRIPT_DIR/../../.claude/commands/execute-prp.md" ./.claude/commands/ 2>/dev/null || echo "   execute-prp.md not found"
    cp "$SCRIPT_DIR/../../.claude/commands/analyze-project.md" ./.claude/commands/ 2>/dev/null || echo "   analyze-project.md not found"
    cp "$SCRIPT_DIR/../../.claude/commands/add-suggestions-to-tasks.md" ./.claude/commands/ 2>/dev/null || echo "   add-suggestions-to-tasks.md not found"
    echo "   Copied core context engineering commands"
fi

# Create .gitignore entries
if [ -f ".gitignore" ]; then
    echo "📝 Updating .gitignore..."
    if ! grep -q "# Context Engineering" .gitignore; then
        cat >> .gitignore << 'EOF'

# Context Engineering (optional - remove if you want to track these)
INITIAL.md
PRPs/*
!PRPs/examples
!PRPs/templates
.claude/commands/*_output.md
EOF
    fi
fi

# For existing projects, analyze and create suggestions
if [ "$PROJECT_TYPE" = "existing" ]; then
    echo "🔍 Analyzing existing project structure..."
    
    # Create analysis file
    cat > context-engineering/CONTEXT_ANALYSIS.md << 'EOF'
# Context Engineering Analysis

## Detected Patterns

### Project Structure
EOF
    
    # Analyze directory structure
    if [ -d "src" ]; then
        echo "- Using src/ directory structure" >> context-engineering/CONTEXT_ANALYSIS.md
    elif [ -d "app" ]; then
        echo "- Using Next.js app directory" >> context-engineering/CONTEXT_ANALYSIS.md
    fi
    
    # Analyze dependencies
    if [ -f "package.json" ]; then
        echo -e "\n### Key Dependencies" >> context-engineering/CONTEXT_ANALYSIS.md
        grep -E '"(next|react|firebase|typescript)"' package.json >> context-engineering/CONTEXT_ANALYSIS.md || true
    fi
    
    echo -e "\n## Next Steps\n" >> context-engineering/CONTEXT_ANALYSIS.md
    echo "1. Review and customize PLANNING.md based on your project" >> context-engineering/CONTEXT_ANALYSIS.md
    echo "2. Update CLAUDE.md if you have specific conventions" >> context-engineering/CONTEXT_ANALYSIS.md
    echo "3. Add current work items to TASK.md" >> context-engineering/CONTEXT_ANALYSIS.md
    echo "4. Create your first INITIAL.md for a new feature" >> context-engineering/CONTEXT_ANALYSIS.md
    
    echo "   Created context-engineering/CONTEXT_ANALYSIS.md with project analysis"
fi

# Create README for the context system
if [ ! -f "context-engineering/CONTEXT_ENGINEERING_README.md" ]; then
    cat > context-engineering/CONTEXT_ENGINEERING_README.md << 'EOF'
# Context Engineering System

This project uses Context Engineering to provide comprehensive context to AI coding assistants.

## Quick Start

1. **For AI Assistants**: Start by reading `CLAUDE.md` and `PLANNING.md`
2. **For New Features**: Create an `INITIAL.md` file describing what you want to build
3. **Track Progress**: Use `TASK.md` to track ongoing work

## Key Files

- **CLAUDE.md**: Global rules and conventions for AI assistants
- **PLANNING.md**: Project architecture and patterns
- **TASK.md**: Current and completed tasks
- **INITIAL.md**: Feature request template
- **PRPs/**: Detailed implementation plans

## Workflow

1. Describe your feature in `INITIAL.md`
2. AI reads context from all documentation
3. AI implements following validation loops
4. Track progress in `TASK.md`

## Customization

- Edit `CLAUDE.md` to add project-specific rules
- Update `PLANNING.md` as architecture evolves
- Add examples to `PRPs/examples/` for common patterns

## Firebase-Specific Guidelines

This template is optimized for Next.js + Firebase projects:
- Client vs Admin SDK usage patterns
- Security rules considerations
- Type-safe Firestore operations
- Authentication flow patterns

See `PLANNING.md` for detailed architecture guidelines.
EOF
    echo "   Created context-engineering/CONTEXT_ENGINEERING_README.md"
fi

echo "✅ Context Engineering setup complete!"
echo ""
echo "📋 Next steps:"
if [ "$PROJECT_TYPE" = "existing" ]; then
    echo "1. Run '/analyze-project' to analyze your codebase and update context files"
    echo "2. Review context-engineering/PLANNING.md for your project architecture"
    echo "3. Update context-engineering/TASK.md with your current tasks"
    echo "4. Review context-engineering/CLAUDE.md for AI assistant guidelines"
    echo "5. Use '/add-suggestions-to-tasks' to add analysis recommendations to tasks"
    echo "6. Create context-engineering/INITIAL.md when starting a new feature"
else
    echo "1. Set up your Firebase project at https://console.firebase.google.com"
    echo "2. Configure your Firebase environment variables"
    echo "3. Review context-engineering/PLANNING.md for your project"
    echo "4. Update context-engineering/TASK.md with your current tasks"
fi
echo ""
echo "🤖 Your project is now ready for AI-assisted development!"