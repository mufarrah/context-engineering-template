# PLANNING.md - Global Multi-Project Workspace

## 🌍 Workspace Overview
This is a **global development workspace** for managing multiple projects across different tech stacks and domains.

**Purpose**: Centralized location for all development projects with shared Context Engineering practices.

## 🏗️ Workspace Architecture

### Directory Structure
```
crypto/                           # Workspace root
├── 📄 CLAUDE.md                  # Global AI assistant rules
├── 📄 PLANNING.md                # This file - workspace overview
├── 📄 TASK.md                    # Cross-project tasks and planning
├── 📄 README.md                  # Workspace documentation
│
├── 🚀 active-projects/           # Currently active projects
│   ├── project-alpha/
│   ├── project-beta/
│   └── project-gamma/
│
├── 🔬 experiments/               # Proof of concepts and experiments
│   ├── tech-spike-1/
│   └── prototype-xyz/
│
├── 📚 archive/                   # Completed or paused projects
│   └── old-project/
│
├── 🛠️ shared/                   # Shared resources and utilities
│   ├── templates/               # Project templates
│   ├── scripts/                 # Utility scripts
│   ├── docs/                    # Shared documentation
│   └── assets/                  # Shared assets
│
└── 🔧 tools/                    # Development tools and configs
    ├── docker/                  # Docker configurations
    ├── ci-cd/                   # CI/CD templates
    └── configs/                 # Shared configurations
```

## 📋 Project Standards

### Every Project Must Have:
- `📄 PLANNING.md` - Project-specific architecture and goals
- `📄 TASK.md` - Project-specific task tracking
- `📄 README.md` - Project documentation
- `📁 src/` or equivalent source directory
- Tech stack appropriate structure

### Supported Tech Stacks:
- **Frontend**: React, Next.js, Vue, Angular, Svelte
- **Backend**: Node.js, Python (FastAPI/Django), Go, PHP
- **Mobile**: React Native, Flutter, Ionic
- **Desktop**: Electron, Tauri
- **Databases**: PostgreSQL, MongoDB, Redis, Firebase, Supabase
- **Cloud**: AWS, GCP, Azure, Vercel, Netlify

## 🔄 Workflow Patterns

### Starting New Projects:
1. Determine project category (active/experiment)
2. Create project directory
3. Copy appropriate template from `/shared/templates/`
4. Customize project-specific `PLANNING.md` and `TASK.md`
5. Update this global `PLANNING.md` with project reference
6. Add setup task to global `TASK.md`

### Project Lifecycle:
```
experiments/ → active-projects/ → archive/
     ↑              ↑               ↑
  Proof of     Production      Completed/
  concept      development     maintained
```

### Cross-Project Considerations:
- **Shared utilities** go in `/shared/`
- **No direct dependencies** between projects unless intentional
- **Consistent naming conventions** across projects
- **Documentation standards** apply to all projects

## 🎯 Current Projects

### Active Projects:
*Update this section as projects are added*

| Project | Tech Stack | Status | Description |
|---------|------------|--------|-------------|
| *None yet* | - | - | *Add your first project here* |

### Experiments:
*List experimental/prototype projects here*

### Archived:
*List completed or paused projects here*

## 🛠️ Development Environment

### Global Tools:
- **Node.js** (for JavaScript/TypeScript projects)
- **Python** (for Python projects)
- **Docker** (for containerization)
- **Git** (version control)

### Shared Resources:
- **Templates**: Starter templates for different project types
- **Scripts**: Automation and utility scripts
- **Configs**: ESLint, Prettier, TypeScript configs
- **Documentation**: Shared guidelines and standards

## 📝 Documentation Philosophy

### Three Levels of Documentation:
1. **Global** (this file): Workspace organization and standards
2. **Project** (project/PLANNING.md): Project-specific architecture
3. **Code** (inline comments): Implementation details

### Documentation Standards:
- Keep global docs high-level and organizational
- Keep project docs specific to that project's needs
- Update docs when making structural changes
- Use clear, consistent formatting

## 🚀 Getting Started

### For New Users:
1. Read this `PLANNING.md` to understand the workspace
2. Read `CLAUDE.md` for AI assistant guidelines
3. Check `TASK.md` for any global setup tasks
4. Create your first project using templates from `/shared/templates/`

### For Adding New Projects:
1. Choose appropriate directory (`active-projects/` vs `experiments/`)
2. Create project directory with descriptive name
3. Copy relevant templates from `/shared/templates/`
4. Customize project-specific documentation
5. Update this `PLANNING.md` with project reference
6. Add project setup to global `TASK.md`

## 🔄 Maintenance

### Regular Reviews:
- **Weekly**: Update project statuses in this file
- **Monthly**: Review and clean up experiments
- **Quarterly**: Archive completed projects

### Workspace Health:
- Keep active projects list current
- Maintain shared templates and tools
- Update documentation when patterns change
- Clean up unused experiments 