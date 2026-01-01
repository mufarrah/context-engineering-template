# CONFIG.md - Global Multi-Project Workspace

## 🌍 Available Commands & Workflows

### 🚀 **Claude Code Commands** (Available anywhere in workspace)

#### Core Commands
```bash
/analyze-project              # Analyze workspace structure and projects
/add-suggestions-to-tasks     # Add analysis suggestions to TASK.md
/create-new-project           # Create new project with templates
/setup-project                # Setup Context Engineering in existing project
```

#### PRP Workflow Commands
```bash
/generate-requirements [input.md]   # Transform feature ideas into requirements doc
/generate-prp [requirements.md]     # Generate implementation plan from requirements
/check-prp [prp-path]               # Validate PRP structure and alignment
/execute-prp [prp-path]             # Start Phase 0 implementation
/continue-prp [prp-path]            # Continue phased implementation (Phase 1+)
/check-progress [prp-path]          # Comprehensive progress audit
/ensure-tracking [prp-path]         # Verify documentation before closing context
```

### 📁 **Project Management Commands**

#### Create New Project Directory
```bash
# For active development projects
mkdir -p active-projects/{project-name}

# For experiments and prototypes
mkdir -p experiments/{project-name}

# For archived/completed projects
mkdir -p archive/{project-name}
```

#### Add Context Engineering to Project
```bash
# Auto-detect project type
./shared/scripts/setup-project-ce.sh active-projects/{project-name}

# Specify tech stack explicitly
./shared/scripts/setup-project-ce.sh active-projects/{project-name} next-supabase
./shared/scripts/setup-project-ce.sh active-projects/{project-name} next-firebase
./shared/scripts/setup-project-ce.sh active-projects/{project-name} react-native
./shared/scripts/setup-project-ce.sh active-projects/{project-name} flutter-supabase
./shared/scripts/setup-project-ce.sh active-projects/{project-name} python
./shared/scripts/setup-project-ce.sh active-projects/{project-name} generic
```

#### Quick Project Creation
```bash
# Basic project with templates only
./shared/scripts/create-project.sh {project-name} active
./shared/scripts/create-project.sh {project-name} experiment
```

### 🔄 **Project Lifecycle Management**

#### Move Projects Between Stages
```bash
# Promote experiment to active project
mv experiments/{project-name} active-projects/{project-name}

# Archive completed project
mv active-projects/{project-name} archive/{project-name}

# Move back from archive (if needed)
mv archive/{project-name} active-projects/{project-name}
```

#### Navigate Between Projects
```bash
# Go to workspace root
cd ~/path/to/workspace

# Navigate to specific project
cd active-projects/{project-name}
cd experiments/{project-name}
cd archive/{project-name}
```

### 🛠️ **Development Workflow Commands**

#### Complete New Project Setup
```bash
# 1. Create project directory
mkdir -p active-projects/{project-name}

# 2. Add full Context Engineering setup
./shared/scripts/setup-project-ce.sh active-projects/{project-name} {tech-stack}

# 3. Navigate to project
cd active-projects/{project-name}

# 4. Analyze project structure
/analyze-project

# 5. Create feature description
echo "# Feature: {feature-name}" > {feature-name}.md
echo "{feature description}" >> {feature-name}.md

# 6. Generate implementation plan
/generate-prp {feature-name}.md

# 7. Execute with AI assistance
/execute-prp context-engineering/PRPs/{feature-name}.md

# 8. Add discovered tasks
/add-suggestions-to-tasks
```

#### Feature Development Workflow
```bash
# From within any project directory:

# 1. Check current tasks (global)
cat context-engineering/TASK.md

# 2. Navigate to specific project and check project tasks
cd active-projects/my-project
cat context-engineering/TASK.md

# 3. Create feature description
echo "# Feature: User Authentication" > auth-feature.md
echo "Add secure login with email/password" >> auth-feature.md

# 4. Generate PRP
/generate-prp auth-feature.md

# 5. Review generated plan
cat context-engineering/PRPs/auth-feature.md

# 6. Execute implementation
/execute-prp context-engineering/PRPs/auth-feature.md

# 7. Update tasks with discoveries
/add-suggestions-to-tasks
```

### 📊 **Workspace Management Commands**

#### View Workspace Structure
```bash
# List all projects
ls -la active-projects/
ls -la experiments/
ls -la archive/

# View project details
find active-projects/ -name "PLANNING.md" -exec grep -l "Project Name" {} \;
find experiments/ -name "TASK.md" -exec head -5 {} \;
```

#### Bulk Operations
```bash
# Update all project templates
find active-projects/ -name "setup-project-ce.sh" -exec {} \;

# Check status of all projects
find active-projects/ -name "TASK.md" -exec grep -H "In Progress" {} \;

# Archive old experiments
find experiments/ -mtime +30 -type d -exec mv {} archive/ \;
```

### 🔧 **Utility Commands**

#### Backup and Restore
```bash
# Backup entire workspace
tar -czf workspace-backup-$(date +%Y%m%d).tar.gz .

# Backup specific project
tar -czf {project-name}-backup-$(date +%Y%m%d).tar.gz active-projects/{project-name}

# Extract backup
tar -xzf workspace-backup-{date}.tar.gz
```

#### Cleanup Commands
```bash
# Remove empty project directories
find . -type d -empty -delete

# Clean up old PRP files
find . -name "*.md" -path "*/PRPs/*" -mtime +60 -delete

# Remove temporary files
find . -name "*.tmp" -delete
find . -name "*_SUGGESTED.md" -mtime +7 -delete
```

### 📝 **Documentation Commands**

#### Generate Documentation
```bash
# Update global workspace documentation
echo "# Workspace Status" > STATUS.md
echo "Generated: $(date)" >> STATUS.md
echo "## Active Projects:" >> STATUS.md
ls active-projects/ >> STATUS.md

# Create project summaries
for project in active-projects/*/; do
    echo "## $(basename $project)" >> PROJECT_SUMMARY.md
    grep -H "Purpose" $project/context-engineering/PLANNING.md >> PROJECT_SUMMARY.md
done
```

#### View Project Information
```bash
# Quick project overview
grep -r "Project Name" active-projects/*/context-engineering/PLANNING.md
grep -r "Tech Stack" active-projects/*/context-engineering/PLANNING.md
grep -r "Status" active-projects/*/context-engineering/TASK.md

# Global workspace overview
grep -r "Purpose" context-engineering/PLANNING.md
cat context-engineering/TASK.md | grep -E "(In Progress|Pending)"
```

### 🎯 **Git Integration Commands**

#### Initialize Git for New Projects
```bash
# From within project directory
git init
git add .
git commit -m "Initial Context Engineering setup"

# Add remote (if applicable)
git remote add origin {repository-url}
git push -u origin main
```

#### Workspace-wide Git Operations
```bash
# Status of all projects
find . -name ".git" -type d -execdir git status --porcelain \;

# Pull updates for all projects
find . -name ".git" -type d -execdir git pull \;

# Commit workspace changes
git add .
git commit -m "Update workspace configuration"
```

## 🔍 **Supported Tech Stacks**

When using `setup-project-ce.sh`, available options:

- **`next-firebase`** - Next.js with Firebase (Auth, Firestore, Functions, Storage)
- **`next-supabase`** - Next.js with Supabase (Auth, Database, Edge Functions, Storage)
- **`react-native`** - React Native mobile application
- **`flutter-supabase`** - Flutter with Supabase backend
- **`python`** - Python (FastAPI, Django, Flask, etc.)
- **`generic`** - Generic project template
- **`auto`** - Auto-detect based on existing files (default)

## 📚 **Quick Reference**

### Most Common Commands
```bash
# 1. Create and setup new project
mkdir -p active-projects/my-app && ./shared/scripts/setup-project-ce.sh active-projects/my-app next-supabase

# 2. Navigate and analyze
cd active-projects/my-app && /analyze-project

# 3. Plan and implement feature
echo "# Feature: Dashboard" > dashboard.md && /generate-prp dashboard.md && /execute-prp context-engineering/PRPs/dashboard.md

# 4. Check project status
cat context-engineering/TASK.md

# 5. Return to workspace root
cd ../../
```

### File Locations
- **Global CE files**: `context-engineering/` (CLAUDE.md, PLANNING.md, TASK.md, PRPs/)
- **Global commands**: `.claude/` (workspace-level commands)
- **Project CE files**: `{project}/context-engineering/` (project-specific CE files)
- **Project commands**: `{project}/.claude/` (project-specific commands)
- **Templates**: `shared/templates/`
- **Scripts**: `shared/scripts/`
- **Tools**: `tools/`

### Project Structure Template
```
workspace/
├── active-projects/{project-name}/
│   ├── .claude/                    # Claude commands (PROJECT ROOT)
│   ├── context-engineering/        # Project-specific CE files
│   ├── src/                        # Source code
│   ├── .env.example               # Environment template
│   └── README.md                  # Project documentation
```

## 🚨 **Important Notes**

1. **Claude Commands Scope**: 
   - From workspace root: Commands affect entire workspace
   - From project directory: Commands scoped to that project

2. **Project Independence**: Each project has its own complete Context Engineering setup

3. **Tech Stack Flexibility**: Mix different tech stacks within the same workspace

4. **Lifecycle Management**: Easy promotion from experiments → active → archive

This CONFIG.md provides all available commands for efficient development in your global multi-project workspace! 