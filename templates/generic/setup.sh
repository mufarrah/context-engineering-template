#!/bin/bash

# Context Engineering Setup Script for Generic Projects
# This script sets up the context engineering system without any tech-stack assumptions

set -e

echo "🚀 Setting up Context Engineering for Generic Project..."

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

# Create context engineering directories first
echo "📁 Creating context engineering directories..."
mkdir -p context-engineering/PRPs/templates .claude/commands

# Copy base files
echo "📄 Copying context engineering files..."
if [ -f "context-engineering/CLAUDE.md" ]; then
    echo "📝 CLAUDE.md exists. Creating CLAUDE_NEW.md for reference..."
    cp "$SCRIPT_DIR/CLAUDE.md" ./context-engineering/CLAUDE_NEW.md
    echo "   Please review and merge CLAUDE_NEW.md with your existing CLAUDE.md"
else
    cp "$SCRIPT_DIR/CLAUDE.md" ./context-engineering/CLAUDE.md
fi

# Copy CONFIG.md (always update)
cp "$SCRIPT_DIR/CONFIG.md" ./CONFIG.md
cp "$SCRIPT_DIR/../../INITIAL_EXAMPLE.md" ./context-engineering/ 2>/dev/null || echo "   INITIAL_EXAMPLE.md not found"
echo "   Created/Updated CONFIG.md"

# Create or update PLANNING.md
if [ -f "context-engineering/PLANNING.md" ]; then
    echo "📋 PLANNING.md exists. Creating PLANNING_NEW.md for reference..."
    cp "$SCRIPT_DIR/PLANNING_TEMPLATE.md" ./context-engineering/PLANNING_NEW.md
    echo "   Please review and merge PLANNING_NEW.md with your existing PLANNING.md"
else
    cp "$SCRIPT_DIR/PLANNING_TEMPLATE.md" ./context-engineering/PLANNING.md
fi

# Create or update TASK.md
if [ -f "context-engineering/TASK.md" ]; then
    echo "📝 TASK.md exists. Creating TASK_NEW.md for reference..."
    cp "$SCRIPT_DIR/TASK.md" ./context-engineering/TASK_NEW.md
    echo "   Please review and merge TASK_NEW.md with your existing TASK.md"
else
    cp "$SCRIPT_DIR/TASK.md" ./context-engineering/TASK.md
fi

# Copy PRP templates
echo "📋 Setting up PRP templates..."
cp -r "$SCRIPT_DIR/PRPs/templates/"* ./context-engineering/PRPs/templates/ 2>/dev/null || echo "   No PRP templates to copy"

# Create analysis directory
mkdir -p context-engineering/analysis

# Copy Claude Code commands
echo "🤖 Setting up Claude Code commands..."
cp -r "$SCRIPT_DIR/.claude/commands/"* ./.claude/commands/ 2>/dev/null || echo "   No Claude commands to copy"

# Copy Claude settings
cp "$SCRIPT_DIR/.claude/settings.local.json" ./.claude/ 2>/dev/null || echo "   No Claude settings to copy"

# Create a basic .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "📄 Creating basic .gitignore..."
    cat > .gitignore << 'EOF'
# Dependencies (adjust based on your tech stack)
node_modules/
venv/
__pycache__/
.env
.env.local
.env.*.local

# Build outputs (adjust based on your tech stack)
dist/
build/
target/
*.pyc
*.pyo
*.pyd
.Python

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Logs
*.log
logs/

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
.nyc_output/

# Dependency directories (adjust based on your tech stack)
jspm_packages/
bower_components/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# next.js build output
.next

# nuxt.js build output
.nuxt

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/
EOF
    echo "   Created basic .gitignore (customize for your tech stack)"
fi

# Create basic README if it doesn't exist
if [ ! -f "README.md" ]; then
    echo "📖 Creating basic README.md..."
    cat > README.md << 'EOF'
# Project Name

## Description
Brief description of what this project does.

## Setup
1. Clone this repository
2. Install dependencies (see CONFIG.md for tech-stack specific commands)
3. Configure environment variables
4. Run the application

## Context Engineering
This project uses Context Engineering for AI-assisted development.

### Available Commands
See `CONFIG.md` for all available commands and workflows.

### Key Files
- `context-engineering/CLAUDE.md` - AI assistant rules
- `context-engineering/PLANNING.md` - Project architecture
- `context-engineering/TASK.md` - Task tracking
- `context-engineering/INITIAL_EXAMPLE.md` - Example feature request

### Getting Started with AI Development
1. Read `context-engineering/PLANNING.md` to understand the project
2. Check `context-engineering/TASK.md` for current tasks
3. Use `/analyze-project` to understand the codebase
4. Create feature descriptions and use `/generate-prp` for implementation plans

## Documentation
- [CONFIG.md](CONFIG.md) - Complete command reference
- [context-engineering/PLANNING.md](context-engineering/PLANNING.md) - Project architecture
- [context-engineering/TASK.md](context-engineering/TASK.md) - Current tasks

## Contributing
1. Read the project documentation
2. Check current tasks in `context-engineering/TASK.md`
3. Follow the development patterns in `context-engineering/PLANNING.md`
4. Use Context Engineering commands for AI-assisted development
EOF
    echo "   Created basic README.md"
fi

echo ""
echo "✅ Context Engineering setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Run '/analyze-project' to analyze your codebase and update context files"
echo "2. Review context-engineering/PLANNING.md and customize for your project"
echo "3. Update context-engineering/TASK.md with your current tasks"
echo "4. Review context-engineering/CLAUDE.md for AI assistant guidelines"
echo "5. Use '/add-suggestions-to-tasks' to add analysis recommendations to tasks"
echo "6. Create context-engineering/INITIAL.md when starting a new feature"
echo ""
echo "🤖 Claude Code Commands Available:"
echo "   Core Commands:"
echo "   ├── /analyze-project           - Analyze this project and customize CE files"
echo "   └── /add-suggestions-to-tasks  - Add analysis suggestions to TASK.md"
echo ""
echo "   PRP Workflow Commands:"
echo "   ├── /generate-requirements     - Transform feature ideas into requirements"
echo "   ├── /generate-prp              - Generate implementation plan from requirements"
echo "   ├── /check-prp                 - Validate PRP structure and alignment"
echo "   ├── /execute-prp               - Start Phase 0 implementation"
echo "   ├── /continue-prp              - Continue phased implementation (Phase 1+)"
echo "   ├── /check-progress            - Comprehensive progress audit"
echo "   └── /ensure-tracking           - Verify documentation before closing context"
echo ""
echo "📖 See CONFIG.md for complete command reference and workflows!"
echo ""
echo "🎯 Your project is ready for AI-assisted development!" 