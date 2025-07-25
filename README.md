# Multi-Stack Context Engineering Templates

> **Enhanced Context Engineering framework with support for Next.js + Firebase, Next.js + Supabase, and Flutter + Supabase**

Built on the foundation of [Cole Medin's Context Engineering framework](https://github.com/coleam00/context-engineering-intro) with extensions for modern development stacks.

## 🚀 Quick Start

### For Existing Projects (Add Context Engineering Only)
```bash
# Clone this repository
git clone https://github.com/mufarrah/context-engineering-template.git
cd context-engineering-templates

# Add Context Engineering to your existing project
./setup-context-engineering.sh /path/to/your/project

# This creates Context Engineering structure:
# 📁 context-engineering/     - All CE files (CLAUDE.md, PLANNING.md, TASK.md, etc.)
# 📁 .claude/commands/        - Claude Code commands (generate-prp, execute-prp, analyze-project, etc.)
# 📄 CONFIG.md               - Complete command reference for your tech stack

# After setup, run the analysis command:
cd /path/to/your/project
/analyze-project              # Analyzes your codebase and customizes CE files
/add-suggestions-to-tasks     # Adds analysis recommendations to TASK.md
```

### For New Projects (Full Setup)
```bash
# Interactive setup with optional project structure
./setup-context-engineering.sh

# You'll be asked if you want to create project directories
# (lib/, services/, hooks/, etc.)

# Or with Claude Code
/create-new-project my-app next-supabase
```

### 🌍 For Global Multi-Project Workspaces (NEW!)
```bash
# Clone this repository
git clone https://github.com/mufarrah/context-engineering-template.git
cd context-engineering-template

# Set up a global workspace for managing multiple projects
./setup-context-engineering.sh /path/to/your/workspace

# Choose option 4: "Global Multi-Project Workspace"

# This creates a complete workspace structure:
# 📁 context-engineering/      - Global Context Engineering files
# │   ├── CLAUDE.md             - Global AI assistant rules
# │   ├── PLANNING.md           - Workspace architecture
# │   ├── TASK.md               - Cross-project task tracking
# │   ├── PRPs/                 - Global PRP templates
# │   └── analysis/             - Workspace analysis files
# 📁 .claude/commands/          - Global Claude Code commands
# 📄 CONFIG.md                 - Complete command reference for workspace
# 📁 active-projects/          - Current development projects
# 📁 experiments/              - Prototypes and POCs
# 📁 archive/                  - Completed projects
# 📁 shared/                   - Templates, scripts, shared resources
# 📁 tools/                    - Development tools and configurations

# Navigate to your workspace and start using Claude commands:
cd /path/to/your/workspace
/analyze-project              # Analyze the workspace structure
/create-new-project my-app    # Create a new project with templates

# Check global workspace status
cat context-engineering/PLANNING.md  # Workspace overview
cat context-engineering/TASK.md      # Cross-project tasks

# Work with specific projects
cd active-projects/my-app
/generate-prp feature.md      # Generate implementation plans
/execute-prp context-engineering/PRPs/feature.md  # Execute with AI assistance
```

## 🎯 What This Provides

### **Intelligent Project Detection**
- Automatically detects your tech stack
- Applies appropriate templates
- Respects existing project structure

### **Smart Setup Behavior**
- **Existing Projects**: Only adds Context Engineering files
  - No project structure modifications
  - Preserves your existing architecture
  - Non-invasive integration
- **New Projects**: Optional full setup
  - Prompts for project structure creation
  - Creates recommended directories only if desired
  - Includes starter code templates

### **4 Specialized Templates**
1. **Next.js + Firebase** - Auth, Firestore, Functions
2. **Next.js + Supabase** - Auth, RLS, Real-time  
3. **Flutter + Supabase** - Mobile patterns, Clean Architecture
4. **Global Multi-Project Workspace** - Multi-stack workspace management

### **Single Source of Truth**
- No need for separate template repositories
- One repo manages all project setups
- Universal commands for consistency

## 📋 Supported Tech Stacks

| Stack | Frontend | Backend | Features |
|-------|----------|---------|----------|
| **Next.js + Firebase** | Next.js 14+ | Firebase | Auth, Firestore, Storage, Functions |
| **Next.js + Supabase** | Next.js 14+ | Supabase | Auth, RLS, Real-time, Edge Functions |
| **Flutter + Supabase** | Flutter | Supabase | Mobile, Clean Architecture, Platform-specific |
| **Global Multi-Project** | Any/Multiple | Any/Multiple | Multi-stack workspace, Project lifecycle management |

## 🔧 How It Works

### 1. **Project Analysis**
```bash
# Detects project type from:
# - package.json (Node.js/Next.js)
# - pubspec.yaml (Flutter)  
# - Dependencies (Firebase/Supabase)
```

### 2. **Template Application**
- Copies appropriate CLAUDE.md with tech-stack rules
- Creates PLANNING.md template for your architecture
- Sets up TASK.md for progress tracking
- Adds validation scripts and documentation

### 3. **Ready for AI Development**
- Comprehensive context for AI assistants
- Validation loops ensure code quality
- Team-ready documentation and patterns

## 📖 Usage Examples

### Setting Up Existing Next.js + Supabase Project
```bash
./setup-context-engineering.sh ~/my-nextjs-app
# Detects Next.js + Supabase, applies appropriate template
```

### Setting Up Flutter + Supabase Project
```bash
./setup-context-engineering.sh ~/my-flutter-app flutter-supabase
# Uses specific template regardless of auto-detection
```

### Creating New Project with Context Engineering
```bash
# With Claude Code
/create-new-project ecommerce-app next-firebase

# Creates new Next.js app with Firebase and Context Engineering pre-configured
```

## 🌍 Global Multi-Project Workspace Workflow

### Complete Workflow for Global Workspaces
```bash
# 1. Initial Setup
./setup-context-engineering.sh ~/my-workspace
# Choose option 4: "Global Multi-Project Workspace"

# 2. Navigate to workspace
cd ~/my-workspace

# 3. Analyze and understand the workspace
/analyze-project

# 4. Create your first project
/create-new-project crypto-app active
# or manually: ./shared/scripts/create-project.sh crypto-app active

# 5. Navigate to your project and customize
cd active-projects/crypto-app
# Edit PLANNING.md with your project details
# Edit TASK.md with initial tasks

# 6. For new features, create a PRP
echo "# Feature: User Authentication" > auth-feature.md
echo "Add secure user login and registration" >> auth-feature.md

# 7. Generate implementation plan
/generate-prp auth-feature.md

# 8. Execute the plan with AI assistance
/execute-prp PRPs/auth-feature.md

# 9. Add analysis suggestions to tasks
/add-suggestions-to-tasks
```

### Project Lifecycle Management
```
experiments/ ──────→ active-projects/ ──────→ archive/
     ↑                     ↑                    ↑
 Proof of              Production          Completed/
 concept              development         maintained

# Move projects between lifecycle stages:
mv experiments/my-prototype active-projects/my-app
mv active-projects/old-app archive/old-app
```

### Multi-Tech Stack Support
The global workspace supports any combination of:
- **Frontend**: React, Next.js, Vue, Angular, Svelte, vanilla JS
- **Backend**: Node.js, Python (FastAPI/Django), Go, PHP, .NET
- **Mobile**: React Native, Flutter, Ionic
- **Desktop**: Electron, Tauri
- **Databases**: PostgreSQL, MongoDB, Redis, Firebase, Supabase
- **Cloud**: AWS, GCP, Azure, Vercel, Netlify

### Directory Structure Benefits
```
workspace/
├── active-projects/     # 🚀 Main development focus
│   ├── crypto-app/      # Next.js + Supabase
│   ├── mobile-app/      # React Native
│   └── api-service/     # Python FastAPI
├── experiments/         # 🔬 Quick prototypes
│   ├── ai-chatbot/      # Test new technologies
│   └── blockchain-poc/  # Proof of concepts
├── archive/            # 📚 Completed work
│   └── old-website/     # Reference implementations
├── shared/             # 🛠️ Reusable resources
│   ├── templates/       # Project templates
│   ├── scripts/         # Automation scripts
│   └── docs/           # Shared documentation
└── tools/              # 🔧 Development tools
    ├── docker/          # Container configs
    └── ci-cd/          # Pipeline templates
```

## 🎨 Customization

### Adding Your Team's Conventions
Each template can be customized:

```markdown
# In CLAUDE.md
### 🏢 Team Conventions
- Use specific naming patterns
- Follow team code review process
- Use specific testing frameworks
```

### Creating New Templates
```bash
# Copy existing template
cp -r templates/next-firebase templates/next-custom

# Modify for your stack
# - Update CLAUDE.md
# - Modify setup.sh
# - Create appropriate PRP templates
```

## 🤖 Claude Code Integration

### Custom Commands Available
- `/setup-project` - Apply Context Engineering to any project
- `/create-new-project` - Create new project with Context Engineering
- `/analyze-project` - Analyze existing codebase and customize CE files
- `/generate-prp` - Create comprehensive implementation plans
- `/execute-prp` - Implement features with validation loops
- `/add-suggestions-to-tasks` - Add analysis recommendations to TASK.md

### 📋 CONFIG.md - Command Reference
Every template now includes a comprehensive `CONFIG.md` file that provides:
- **All available commands** for that specific tech stack
- **Development workflows** and best practices
- **Environment setup** instructions
- **Testing and deployment** commands
- **Context Engineering integration** workflows

**Examples of commands documented in CONFIG.md:**
```bash
# For Next.js projects
npm run dev                    # Start development server
/analyze-project              # Analyze project structure
/generate-prp feature.md      # Generate implementation plan

# For Flutter projects  
flutter run                   # Run on device
flutter test                  # Run all tests
/execute-prp PRPs/feature.md  # Execute with AI assistance

# For Global Multi-Project
mkdir -p active-projects/my-app
./shared/scripts/setup-project-ce.sh active-projects/my-app next-supabase
cd active-projects/my-app && /analyze-project
```

### Complete Workflow for Existing Projects
```
1. Run setup: ./setup-context-engineering.sh /path/to/project
2. Run: /analyze-project        # Analyzes codebase, updates PLANNING.md & CLAUDE.md
3. Run: /add-suggestions-to-tasks # Adds recommendations to TASK.md
4. Create: context-engineering/INITIAL.md (describe new feature)
5. Run: /generate-prp context-engineering/INITIAL.md
6. Run: /execute-prp context-engineering/PRPs/your-feature.md
7. AI implements with full context and validation
```

### Complete Workflow for Global Workspaces
```
1. Run setup: ./setup-context-engineering.sh /path/to/workspace
2. Choose: Option 4 - "Global Multi-Project Workspace"
3. Run: /analyze-project        # Analyzes workspace structure
4. Run: /create-new-project my-app active  # Create projects
5. Navigate: cd active-projects/my-app
6. Run: /analyze-project        # Analyze specific project
7. Create: feature-description.md (describe new feature)
8. Run: /generate-prp feature-description.md
9. Run: /execute-prp PRPs/feature-plan.md
10. Run: /add-suggestions-to-tasks # Add recommendations
```

### Workflow for New Features (Any Project Type)
```
1. Create feature request in INITIAL.md or feature-description.md
2. Run: /generate-prp feature-description.md  
3. Run: /execute-prp PRPs/your-feature.md
4. AI implements following project patterns and validation loops
```

## 🏗️ Architecture

```
context-engineering-templates/
├── templates/                  # Tech-stack specific templates
│   ├── next-firebase/         # Next.js + Firebase template
│   ├── next-supabase/         # Next.js + Supabase template  
│   └── flutter-supabase/      # Flutter + Supabase template
├── .claude/commands/          # Claude Code commands
├── setup-context-engineering.sh  # Universal setup script
├── git-setup.sh              # Repository setup helper
└── docs/                     # Comprehensive documentation
```

## 🔄 Migration from Original

If you're using Cole Medin's original Context Engineering:

```bash
# This extends the original - no migration needed!
# Just use this for multi-stack support
./setup-context-engineering.sh /path/to/existing/context-project
```

## 🤝 Contributing

Contributions welcome! Areas for improvement:
- Additional tech stack templates
- Enhanced project detection
- More automation features
- Better documentation
- Community examples

## 📄 License

Same license as the original Context Engineering framework. This is an extension, not a replacement.

## 🙏 Credits

**Original Framework:** [Cole Medin (@coleam00)](https://github.com/coleam00/context-engineering-intro)

**Multi-Stack Extensions:** Enhanced for broader development use cases

See [CREDITS.md](CREDITS.md) for full attribution.

---

### ⚡ **Why Context Engineering > Prompt Engineering**

- **Context Engineering**: Complete system with documentation, examples, validation
- **Prompt Engineering**: Just clever wording

**Result**: 10x better AI assistance with this comprehensive approach.

Ready to transform your development workflow? Start with:
```bash
./setup-context-engineering.sh
```