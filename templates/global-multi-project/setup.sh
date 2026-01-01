#!/bin/bash

# Global Multi-Project Context Engineering Setup
# Creates a workspace structure for managing multiple projects

set -e

echo "🌍 Setting up Global Multi-Project Workspace..."
echo "=============================================="

# Get current directory (should be the target workspace directory)
TARGET_DIR="$(pwd)"
echo "📁 Setting up workspace in: $TARGET_DIR"

# Create directory structure
echo "📂 Creating directory structure..."

# Main directories
mkdir -p active-projects
mkdir -p experiments
mkdir -p archive
mkdir -p shared/{templates,scripts,docs,assets}
mkdir -p tools/{docker,ci-cd,configs}

# Context Engineering directory structure
mkdir -p context-engineering/{PRPs,analysis}

# Copy Context Engineering files
echo "📄 Setting up Context Engineering files..."

# Get the source directory (where this script is located)
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Copy main CE files to context-engineering directory
cp "$SOURCE_DIR/CLAUDE.md" context-engineering/
cp "$SOURCE_DIR/PLANNING.md" context-engineering/
cp "$SOURCE_DIR/TASK.md" context-engineering/
cp "$SOURCE_DIR/CONFIG.md" .
cp "$SOURCE_DIR/../../INITIAL_EXAMPLE.md" ./context-engineering/ 2>/dev/null || echo "   INITIAL_EXAMPLE.md not found"

# Copy Claude Code commands
echo "🤖 Setting up Claude Code commands..."
cp -r "$SOURCE_DIR/.claude" .

# Copy PRP templates to context-engineering directory
echo "📋 Setting up PRP templates..."
cp -r "$SOURCE_DIR/PRPs"/* context-engineering/PRPs/ 2>/dev/null || echo "No PRP templates found"

# Create workspace README
cat > README.md << 'EOF'
# Global Multi-Project Workspace

This workspace uses **Context Engineering** to manage multiple development projects with AI assistance.

## 🚀 Quick Start

1. **Read the documentation**:
   - `PLANNING.md` - Workspace architecture and standards
   - `CLAUDE.md` - AI assistant guidelines
   - `TASK.md` - Current tasks and project status

2. **Create your first project**:
   ```bash
   mkdir active-projects/my-project
   cp shared/templates/PLANNING_template.md active-projects/my-project/PLANNING.md
   cp shared/templates/TASK_template.md active-projects/my-project/TASK.md
   ```

3. **Customize for your project**:
   - Update the project's `PLANNING.md` with your architecture
   - Add initial tasks to the project's `TASK.md`
   - Update the global `PLANNING.md` to reference your project

## 📁 Directory Structure

- `active-projects/` - Current development projects
- `experiments/` - Prototypes and proof-of-concepts
- `archive/` - Completed or paused projects
- `shared/` - Shared resources and templates
- `tools/` - Development tools and configurations

## 🤖 AI Assistant

This workspace is optimized for AI-assisted development. The AI will:
- Understand your multi-project structure
- Respect each project's unique tech stack
- Help manage tasks across projects
- Maintain documentation standards

## 🛠️ Adding New Projects

Use the templates in `shared/templates/` to quickly set up new projects with proper Context Engineering structure.

EOF

# Create project templates
echo "📋 Creating project templates..."

# Create PLANNING template
cat > shared/templates/PLANNING_template.md << 'EOF'
# PLANNING.md - [Project Name]

## 🎯 Project Overview
**Project Name**: [Your Project Name]
**Tech Stack**: [e.g., Next.js + Supabase, Python + FastAPI, etc.]
**Purpose**: [Brief description of what this project does]

## 🏗️ Architecture

### Tech Stack
- **Frontend**: [React, Vue, Angular, etc.]
- **Backend**: [Node.js, Python, Go, etc.]
- **Database**: [PostgreSQL, MongoDB, etc.]
- **Deployment**: [Vercel, AWS, etc.]

### Project Structure
```
project-name/
├── src/
├── tests/
├── docs/
├── PLANNING.md
├── TASK.md
└── README.md
```

## 📋 Development Standards

### Code Style
- [Define your coding standards]
- [Naming conventions]
- [File organization patterns]

### Testing
- [Testing framework and patterns]
- [Coverage requirements]
- [Testing strategies]

### Documentation
- [Documentation requirements]
- [API documentation standards]
- [Code comment guidelines]

## 🚀 Getting Started

### Prerequisites
- [List required tools and versions]

### Setup
1. [Setup step 1]
2. [Setup step 2]
3. [Setup step 3]

### Development Workflow
1. [Typical development process]
2. [Testing procedures]
3. [Deployment process]

## 🎨 Design Patterns

### [Pattern 1]
- [When to use]
- [Implementation details]

### [Pattern 2]
- [When to use]
- [Implementation details]

## 🔧 Configuration

### Environment Variables
- [List required environment variables]

### External Services
- [List external APIs or services]

## 📝 Notes
- [Additional project-specific notes]
- [Known limitations or constraints]
- [Future considerations]
EOF

# Create TASK template
cat > shared/templates/TASK_template.md << 'EOF'
# TASK.md - [Project Name]

## 🎯 Current Sprint/Milestone

**Goal**: [Current development goal]
**Deadline**: [If applicable]

## 📋 Active Tasks

### High Priority
| Task | Status | Assignee | Due Date | Notes |
|------|--------|----------|----------|-------|
| [Task description] | 📋 Pending | - | - | - |

### Medium Priority
| Task | Status | Assignee | Due Date | Notes |
|------|--------|----------|----------|-------|
| [Task description] | 📋 Pending | - | - | - |

### Low Priority / Backlog
- [ ] [Task description]
- [ ] [Task description]
- [ ] [Task description]

## 🔄 In Progress

| Task | Started | Progress | Blockers | ETA |
|------|---------|----------|----------|-----|
| [Current task] | [Date] | [%] | [Issues] | [Date] |

## ✅ Recently Completed

| Task | Completed | Notes |
|------|-----------|-------|
| [Task description] | [Date] | [Any notes] |

## 🐛 Bugs & Issues

| Issue | Priority | Status | Reporter | Notes |
|-------|----------|--------|----------|-------|
| [Bug description] | [High/Med/Low] | 📋 Open | - | - |

## 🚀 Feature Requests

| Feature | Priority | Status | Requester | Notes |
|---------|----------|--------|-----------|-------|
| [Feature description] | [High/Med/Low] | 📋 Backlog | - | - |

## 🔧 Technical Debt

| Item | Impact | Effort | Priority | Notes |
|------|--------|--------|----------|-------|
| [Tech debt item] | [High/Med/Low] | [Hours/Days] | [High/Med/Low] | - |

## 📝 Notes & Ideas

### Development Notes
- [Important development insights]
- [Architecture decisions]
- [Performance considerations]

### Future Enhancements
- [Ideas for future features]
- [Potential improvements]
- [Research items]

---

## Task Status Guide

### Status Icons:
- 📋 **Pending**: Not started
- 🔄 **In Progress**: Currently working on
- ⏸️ **Paused**: Temporarily stopped
- ✅ **Complete**: Finished
- ❌ **Cancelled**: No longer needed
- 🔍 **Review**: Needs review/testing

### Priority Levels:
- 🔥 **Critical**: Blocking, security issues
- ⚡ **High**: Important features
- 📈 **Medium**: Nice to have
- 🔧 **Low**: Minor improvements
EOF

# Create basic shared configurations
echo "⚙️ Creating shared configurations..."

# Create basic .gitignore template
cat > shared/templates/gitignore_template << 'EOF'
# Dependencies
node_modules/
__pycache__/
*.pyc
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build outputs
dist/
build/
.next/
out/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
EOF

# Create basic package.json template for Node.js projects
cat > shared/templates/package_template.json << 'EOF'
{
  "name": "project-name",
  "version": "1.0.0",
  "description": "Project description",
  "scripts": {
    "dev": "npm run start:dev",
    "build": "npm run build:prod",
    "test": "npm run test:unit"
  },
  "keywords": [],
  "author": "",
  "license": "MIT"
}
EOF

# Create utility script for creating new projects
cat > shared/scripts/create-project.sh << 'EOF'
#!/bin/bash

# Utility script to create new projects with proper structure

if [ $# -eq 0 ]; then
    echo "Usage: ./create-project.sh <project-name> [project-type]"
    echo "Project types: active, experiment, or custom path"
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_TYPE="${2:-active}"

# Determine target directory
case $PROJECT_TYPE in
    "active")
        TARGET_DIR="active-projects/$PROJECT_NAME"
        ;;
    "experiment")
        TARGET_DIR="experiments/$PROJECT_NAME"
        ;;
    *)
        TARGET_DIR="$PROJECT_TYPE/$PROJECT_NAME"
        ;;
esac

echo "🚀 Creating new project: $PROJECT_NAME"
echo "📁 Location: $TARGET_DIR"

# Create project directory
mkdir -p "$TARGET_DIR"

# Copy templates
cp shared/templates/PLANNING_template.md "$TARGET_DIR/PLANNING.md"
cp shared/templates/TASK_template.md "$TARGET_DIR/TASK.md"

# Replace placeholders in templates
sed -i "s/\[Project Name\]/$PROJECT_NAME/g" "$TARGET_DIR/PLANNING.md"
sed -i "s/\[Project Name\]/$PROJECT_NAME/g" "$TARGET_DIR/TASK.md"

echo "✅ Project created successfully!"
echo "📝 Next steps:"
echo "   1. Edit $TARGET_DIR/PLANNING.md with your project details"
echo "   2. Add initial tasks to $TARGET_DIR/TASK.md"
echo "   3. Update global PLANNING.md to reference this project"
EOF

chmod +x shared/scripts/create-project.sh

echo ""
echo "✅ Global Multi-Project Workspace setup complete!"
echo ""
echo "📁 Directory structure created:"
echo "   ├── active-projects/    (for main development projects)"
echo "   ├── experiments/        (for prototypes and POCs)"
echo "   ├── archive/           (for completed projects)"
echo "   ├── shared/            (templates, scripts, docs)"
echo "   └── tools/             (development tools and configs)"
echo ""
echo "📄 Context Engineering files:"
echo "   ├── context-engineering/"
echo "   │   ├── CLAUDE.md      (AI assistant rules)"
echo "   │   ├── PLANNING.md    (workspace architecture)"
echo "   │   ├── TASK.md        (cross-project tasks)"
echo "   │   ├── INITIAL_EXAMPLE.md (example feature request)"
echo "   │   ├── PRPs/          (Project Requirement Plans templates)"
echo "   │   └── analysis/      (workspace analysis files)"
echo "   ├── .claude/           (Claude Code commands)"
echo "   ├── CONFIG.md          (command reference)"
echo "   └── README.md          (workspace documentation)"
echo ""
echo "🚀 Quick start:"
echo "   1. Read context-engineering/PLANNING.md to understand the workspace"
echo "   2. Check context-engineering/TASK.md for initial setup tasks"
echo "   3. Create your first project:"
echo "      ./shared/scripts/create-project.sh my-first-project active"
echo ""
echo "🤖 Claude Code Commands Available:"
echo "   Core Commands:"
echo "   ├── /analyze-project           - Analyze workspace and projects"
echo "   ├── /add-suggestions-to-tasks  - Add analysis suggestions to TASK.md"
echo "   ├── /create-new-project        - Create new project with templates"
echo "   └── /setup-project             - Setup Context Engineering in existing project"
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
echo "🎯 Typical Workflow:"
echo "   1. /analyze-project               (understand current state)"
echo "   2. /create-new-project            (create a new project)"
echo "   3. /generate-requirements input.md (create requirements from ideas)"
echo "   4. /generate-prp requirements.md  (plan new features)"
echo "   5. /execute-prp prp-path          (implement Phase 0)"
echo "   6. /continue-prp prp-path         (continue Phase 1+)"
echo ""
echo "🌍 Your global workspace is ready for AI-assisted development!" 