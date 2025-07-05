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

# Copy base files
echo "📄 Copying context engineering files..."
cp "$SCRIPT_DIR/CLAUDE.md" ./CLAUDE.md

# Create or update PLANNING.md
if [ -f "PLANNING.md" ]; then
    echo "📝 PLANNING.md exists. Creating PLANNING_NEW.md for reference..."
    cp "$SCRIPT_DIR/PLANNING_TEMPLATE.md" ./PLANNING_NEW.md
    echo "   Please merge PLANNING_NEW.md with your existing PLANNING.md"
else
    cp "$SCRIPT_DIR/PLANNING_TEMPLATE.md" ./PLANNING.md
    echo "   Created PLANNING.md - Please customize it for your project"
fi

# Create TASK.md if it doesn't exist
if [ ! -f "TASK.md" ]; then
    cat > TASK.md << 'EOF'
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
    echo "   Created TASK.md"
fi

# Create INITIAL.md template
cat > INITIAL.md << 'EOF'
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
- `components/` - Existing component patterns
- `lib/firebase/` - Firebase integration patterns
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
echo "   Created INITIAL.md template"

# Create directories
echo "📁 Creating directory structure..."
mkdir -p .claude/commands PRPs/examples

# Copy command files
cp -r "$SCRIPT_DIR/.claude/commands/"* ./.claude/commands/ 2>/dev/null || echo "   No Claude commands to copy"

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
    cat > CONTEXT_ANALYSIS.md << 'EOF'
# Context Engineering Analysis

## Detected Patterns

### Project Structure
EOF
    
    # Analyze directory structure
    if [ -d "src" ]; then
        echo "- Using src/ directory structure" >> CONTEXT_ANALYSIS.md
    elif [ -d "app" ]; then
        echo "- Using Next.js app directory" >> CONTEXT_ANALYSIS.md
    fi
    
    # Analyze dependencies
    if [ -f "package.json" ]; then
        echo -e "\n### Key Dependencies" >> CONTEXT_ANALYSIS.md
        grep -E '"(next|react|firebase|typescript)"' package.json >> CONTEXT_ANALYSIS.md || true
    fi
    
    echo -e "\n## Next Steps\n" >> CONTEXT_ANALYSIS.md
    echo "1. Review and customize PLANNING.md based on your project" >> CONTEXT_ANALYSIS.md
    echo "2. Update CLAUDE.md if you have specific conventions" >> CONTEXT_ANALYSIS.md
    echo "3. Add current work items to TASK.md" >> CONTEXT_ANALYSIS.md
    echo "4. Create your first INITIAL.md for a new feature" >> CONTEXT_ANALYSIS.md
    
    echo "   Created CONTEXT_ANALYSIS.md with project analysis"
fi

# Create README for the context system
cat > CONTEXT_ENGINEERING_README.md << 'EOF'
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

echo "✅ Context Engineering setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Review and customize PLANNING.md for your project"
echo "2. Update TASK.md with your current tasks"
echo "3. Read CONTEXT_ENGINEERING_README.md for usage instructions"
echo "4. Configure your Firebase environment variables"
echo ""
echo "🤖 Your project is now ready for AI-assisted development!"