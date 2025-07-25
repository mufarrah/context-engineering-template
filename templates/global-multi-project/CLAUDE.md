# CLAUDE.md - Global Multi-Project Context Engineering

### 🌍 Global Multi-Project Workspace
This is a **global workspace** containing multiple projects. Each project may use different tech stacks and patterns.

### 🔄 Project Awareness & Context
- **Always identify which project** you're working on by checking the current directory or asking the user
- **Read the project-specific `context-engineering/PLANNING.md`** in each project directory to understand that project's architecture, goals, and constraints
- **Check the project-specific `context-engineering/TASK.md`** before starting work on any project
- **Use project-specific naming conventions** as defined in each project's `context-engineering/PLANNING.md`
- **Respect each project's unique tech stack** (Next.js, React, Vue, Python, etc.)

### 🏗️ Global Workspace Structure
```
crypto/                           # Global workspace root
├── context-engineering/          # Global Context Engineering
│   ├── CLAUDE.md                 # This file - global rules
│   ├── PLANNING.md               # Global workspace overview
│   ├── TASK.md                   # Cross-project tasks and planning
│   ├── PRPs/                     # Global PRP templates
│   └── analysis/                 # Workspace analysis files
├── .claude/                      # Claude Code commands
├── project-1/                    # Individual project
│   ├── .claude/                  # Project-specific commands
│   ├── context-engineering/      # Project CE files
│   │   ├── PLANNING.md           # Project-specific architecture
│   │   ├── TASK.md               # Project-specific tasks
│   │   └── PRPs/                 # Project PRPs
│   ├── src/                      # Project source code
│   └── ...
├── project-2/                    # Another project
│   ├── .claude/
│   ├── context-engineering/
│   └── ...
└── shared/                       # Shared resources, templates, utilities
    ├── templates/
    ├── scripts/
    └── docs/
```

### 🎯 Multi-Project Development Rules

#### Before Starting Any Work:
1. **Identify the target project** explicitly
2. **Navigate to or specify** the project directory
3. **Read that project's `context-engineering/PLANNING.md`** for specific rules
4. **Check that project's `context-engineering/TASK.md`** for current status
5. **Follow that project's tech stack conventions**

#### Project-Specific Context:
- Each project has its **own architecture patterns**
- Each project has its **own dependencies and tooling**
- Each project has its **own coding standards**
- **Never mix patterns** between projects unless explicitly requested

### 🧱 Code Structure & Modularity (Global Guidelines)
- **Keep projects completely separate** - no cross-project dependencies unless intentional
- **Use clear, descriptive project names** and directory structure
- **Maintain consistent folder structure within each project type**
- **Document shared resources** in the `/shared` directory

### ✅ Task Management
- **Global tasks** go in `context-engineering/TASK.md` (workspace setup, cross-project planning)
- **Project-specific tasks** go in each project's `context-engineering/TASK.md`
- **Always specify which project** a task belongs to
- **Update the relevant `TASK.md`** when completing work

### 🔧 Technology Stack Flexibility
This workspace supports multiple tech stacks:
- **Frontend**: React, Next.js, Vue, Angular, vanilla JS
- **Backend**: Node.js, Python, Go, PHP, etc.
- **Databases**: PostgreSQL, MongoDB, Firebase, Supabase
- **Mobile**: React Native, Flutter
- **Desktop**: Electron, Tauri

### 📝 Documentation Standards
- **Each project must have** its own `context-engineering/PLANNING.md` and `context-engineering/TASK.md`
- **Global documentation** in `context-engineering/` covers workspace organization and cross-project concerns
- **Project documentation** in each project's `context-engineering/` covers that specific project's implementation details

### 🚀 Getting Started with New Projects
1. Create new project directory: `mkdir new-project-name`
2. Set up Context Engineering: `./shared/scripts/setup-project-ce.sh new-project-name tech-stack`
3. Customize the project's `context-engineering/PLANNING.md` for the specific project
4. Add initial tasks to project's `context-engineering/TASK.md`
5. Update global `context-engineering/PLANNING.md` to reference the new project
6. Add project setup task to global `context-engineering/TASK.md`

### ⚠️ Important Reminders
- **Always confirm which project** you're working on
- **Never assume tech stack** - check project-specific documentation
- **Respect project boundaries** - don't create dependencies between unrelated projects
- **Keep shared resources generic** and well-documented 