#!/bin/bash

# Setup Context Engineering for Individual Projects
# This script sets up full CE structure for a specific project within the global workspace

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./setup-project-ce.sh <project-path> [template-type]"
    echo ""
    echo "Examples:"
    echo "  ./setup-project-ce.sh active-projects/crypto-app next-supabase"
    echo "  ./setup-project-ce.sh experiments/ai-bot python"
    echo "  ./setup-project-ce.sh active-projects/mobile-app react-native"
    echo ""
    echo "Template types: next-firebase, next-supabase, flutter-supabase, python, react-native, or auto"
    exit 1
fi

PROJECT_PATH="$1"
TEMPLATE_TYPE="${2:-auto}"

# Check if project directory exists
if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Project directory $PROJECT_PATH does not exist"
    echo "Create it first with: mkdir -p $PROJECT_PATH"
    exit 1
fi

echo "🚀 Setting up Context Engineering for project: $PROJECT_PATH"
echo "🎯 Template type: $TEMPLATE_TYPE"
echo ""

# Navigate to project directory
cd "$PROJECT_PATH"

# Create context-engineering directory structure
echo "📂 Creating Context Engineering structure..."
mkdir -p context-engineering/{PRPs,analysis}

# Detect project type if auto
if [ "$TEMPLATE_TYPE" = "auto" ]; then
    if [ -f "package.json" ]; then
        if grep -q "next" "package.json" 2>/dev/null; then
            if grep -q "firebase" "package.json" 2>/dev/null; then
                TEMPLATE_TYPE="next-firebase"
            elif grep -q "supabase" "package.json" 2>/dev/null; then
                TEMPLATE_TYPE="next-supabase"
            else
                TEMPLATE_TYPE="next-generic"
            fi
        elif grep -q "react-native" "package.json" 2>/dev/null; then
            TEMPLATE_TYPE="react-native"
        else
            TEMPLATE_TYPE="node"
        fi
    elif [ -f "pubspec.yaml" ]; then
        TEMPLATE_TYPE="flutter-supabase"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        TEMPLATE_TYPE="python"
    else
        TEMPLATE_TYPE="generic"
    fi
    echo "🔍 Auto-detected template type: $TEMPLATE_TYPE"
fi

# Create project-specific CLAUDE.md
echo "📄 Creating project-specific CLAUDE.md..."
cat > context-engineering/CLAUDE.md << EOF
# CLAUDE.md - $(basename "$PWD")

### 🎯 Project-Specific Context Engineering
This is a **$(basename "$PWD")** project within the global multi-project workspace.

**Tech Stack**: $TEMPLATE_TYPE
**Project Path**: $PROJECT_PATH

### 🔄 Project Awareness & Context
- **Always read this project's \`PLANNING.md\`** to understand architecture, goals, and constraints
- **Check this project's \`TASK.md\`** before starting work
- **Follow project-specific naming conventions** as defined in \`PLANNING.md\`
- **Respect this project's tech stack patterns** and dependencies

### 🏗️ Project Structure
\`\`\`
$(basename "$PWD")/
├── .claude/                 # Claude Code commands (PROJECT ROOT)
│   ├── settings.local.json  # Claude settings
│   └── commands/            # Available commands
├── context-engineering/     # Context Engineering files
│   ├── CLAUDE.md            # This file - project rules
│   ├── PLANNING.md          # Project architecture
│   ├── TASK.md              # Project tasks
│   ├── PRPs/                # Project Requirement Plans
│   └── analysis/            # Project analysis files
├── src/                     # Source code
├── tests/                   # Test files
├── docs/                    # Project documentation
├── .env.example             # Environment variables template
└── README.md                # Project documentation
\`\`\`

### 🧱 Code Structure & Modularity
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic")
        echo "- **Use Next.js 14+ App Router** with TypeScript"
        echo "- **Components in \`src/components/\`** with proper TypeScript interfaces"
        echo "- **Pages in \`src/app/\`** following App Router conventions"
        echo "- **Utilities in \`src/lib/\`** for shared functions"
        echo "- **Use proper error boundaries** and loading states"
        ;;
    "react-native")
        echo "- **Use React Native with TypeScript**"
        echo "- **Screens in \`src/screens/\`** with navigation"
        echo "- **Components in \`src/components/\`** with proper props"
        echo "- **Services in \`src/services/\`** for API calls"
        echo "- **Follow platform-specific patterns** for iOS/Android"
        ;;
    "flutter-supabase")
        echo "- **Use Flutter with Dart**"
        echo "- **Screens in \`lib/screens/\`** with proper routing"
        echo "- **Widgets in \`lib/widgets/\`** following Flutter conventions"
        echo "- **Services in \`lib/services/\`** for business logic"
        echo "- **Follow Clean Architecture** patterns"
        ;;
    "python")
        echo "- **Use Python 3.9+ with type hints**"
        echo "- **Modules in clear directory structure**"
        echo "- **Services for business logic separation**"
        echo "- **Use FastAPI or Django** for web applications"
        echo "- **Follow PEP 8** coding standards"
        ;;
    *)
        echo "- **Use clear, descriptive file and function names**"
        echo "- **Separate concerns** into logical modules"
        echo "- **Follow language-specific conventions**"
        echo "- **Document complex logic** with comments"
        ;;
esac)

### 🧪 Testing & Reliability
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic")
        echo "- **Use Jest and React Testing Library** for unit tests"
        echo "- **Test components in \`__tests__/\`** directories"
        echo "- **Use Playwright or Cypress** for E2E testing"
        ;;
    "react-native")
        echo "- **Use Jest and React Native Testing Library**"
        echo "- **Test screens and components** thoroughly"
        echo "- **Use Detox** for E2E testing"
        ;;
    "flutter-supabase")
        echo "- **Use Flutter's built-in testing framework**"
        echo "- **Widget tests for UI components**"
        echo "- **Integration tests for full flows**"
        ;;
    "python")
        echo "- **Use pytest for testing**"
        echo "- **Test coverage with pytest-cov**"
        echo "- **Mock external dependencies**"
        ;;
    *)
        echo "- **Write comprehensive unit tests**"
        echo "- **Test edge cases and error conditions**"
        echo "- **Maintain test coverage above 80%**"
        ;;
esac)

### ✅ Task Completion
- **Mark completed tasks in \`context-engineering/TASK.md\`** immediately after finishing
- **Update global workspace \`TASK.md\`** for cross-project tasks
- **Add discovered tasks** to appropriate TASK.md file

### 🔧 Project-Specific Guidelines
$(case $TEMPLATE_TYPE in
    "next-firebase")
        echo "- **Use Firebase Auth** for authentication"
        echo "- **Firestore** for database operations"
        echo "- **Firebase Functions** for serverless logic"
        echo "- **Firebase Storage** for file uploads"
        ;;
    "next-supabase")
        echo "- **Use Supabase Auth** for authentication"
        echo "- **Supabase Database** with Row Level Security"
        echo "- **Real-time subscriptions** where appropriate"
        echo "- **Edge Functions** for serverless logic"
        ;;
    "flutter-supabase")
        echo "- **Use Supabase Flutter SDK**"
        echo "- **State management with Riverpod or Bloc**"
        echo "- **Responsive design** for different screen sizes"
        echo "- **Platform-specific features** when needed"
        ;;
    "python")
        echo "- **Use virtual environments** (venv or conda)"
        echo "- **Requirements management** with requirements.txt or pyproject.toml"
        echo "- **Environment variables** for configuration"
        echo "- **Logging** for debugging and monitoring"
        ;;
esac)

### 📝 Documentation Requirements
- **Update \`PLANNING.md\`** when architecture changes
- **Document API endpoints** in \`docs/api.md\`
- **Keep \`README.md\`** current with setup instructions
- **Comment complex business logic** in code

### 🚀 Development Workflow
1. Check \`context-engineering/TASK.md\` for current tasks
2. Create feature branch for new work
3. Write tests before implementation (TDD)
4. Implement feature following project patterns
5. Run validation commands before commit
6. Update documentation as needed
7. Mark tasks complete in TASK.md
EOF

# Create project-specific PLANNING.md
echo "📋 Creating project-specific PLANNING.md..."
cat > context-engineering/PLANNING.md << EOF
# PLANNING.md - $(basename "$PWD")

## 🎯 Project Overview
**Project Name**: $(basename "$PWD")
**Tech Stack**: $TEMPLATE_TYPE
**Purpose**: [Describe what this project does and its main goals]

**Repository**: [Link to repository if applicable]
**Deployment**: [Deployment URL or method]
**Status**: 🚧 In Development

## 🏗️ Architecture

### Technology Stack
$(case $TEMPLATE_TYPE in
    "next-firebase")
        echo "- **Frontend**: Next.js 14+ with TypeScript"
        echo "- **Backend**: Firebase (Auth, Firestore, Functions, Storage)"
        echo "- **Deployment**: Vercel + Firebase"
        echo "- **Styling**: [Tailwind CSS / styled-components / CSS modules]"
        ;;
    "next-supabase")
        echo "- **Frontend**: Next.js 14+ with TypeScript"
        echo "- **Backend**: Supabase (Auth, Database, Edge Functions, Storage)"
        echo "- **Deployment**: Vercel + Supabase"
        echo "- **Styling**: [Tailwind CSS / styled-components / CSS modules]"
        ;;
    "react-native")
        echo "- **Framework**: React Native with TypeScript"
        echo "- **Navigation**: React Navigation"
        echo "- **State**: [Redux / Zustand / Context API]"
        echo "- **Backend**: [Specify API or backend service]"
        ;;
    "flutter-supabase")
        echo "- **Framework**: Flutter with Dart"
        echo "- **Backend**: Supabase"
        echo "- **State Management**: [Riverpod / Bloc / Provider]"
        echo "- **Navigation**: Go Router"
        ;;
    "python")
        echo "- **Language**: Python 3.9+"
        echo "- **Framework**: [FastAPI / Django / Flask]"
        echo "- **Database**: [PostgreSQL / MongoDB / SQLite]"
        echo "- **Deployment**: [Docker / Heroku / AWS]"
        ;;
    *)
        echo "- **Language**: [Specify main language]"
        echo "- **Framework**: [Specify main framework]"
        echo "- **Database**: [Specify database]"
        echo "- **Deployment**: [Specify deployment method]"
        ;;
esac)

### Project Structure
\`\`\`
$(basename "$PWD")/
├── context-engineering/         # Context Engineering files
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic")
        echo "├── src/"
        echo "│   ├── app/                    # Next.js App Router pages"
        echo "│   ├── components/             # Reusable components"
        echo "│   ├── lib/                    # Utilities and configurations"
        echo "│   └── types/                  # TypeScript type definitions"
        echo "├── public/                     # Static assets"
        echo "├── tests/                      # Test files"
        ;;
    "react-native")
        echo "├── src/"
        echo "│   ├── screens/                # App screens"
        echo "│   ├── components/             # Reusable components"
        echo "│   ├── navigation/             # Navigation setup"
        echo "│   ├── services/               # API and business logic"
        echo "│   └── types/                  # TypeScript types"
        echo "├── __tests__/                  # Test files"
        ;;
    "flutter-supabase")
        echo "├── lib/"
        echo "│   ├── screens/                # App screens"
        echo "│   ├── widgets/                # Reusable widgets"
        echo "│   ├── services/               # Business logic"
        echo "│   ├── models/                 # Data models"
        echo "│   └── utils/                  # Utilities"
        echo "├── test/                       # Test files"
        ;;
    "python")
        echo "├── src/"
        echo "│   ├── api/                    # API endpoints"
        echo "│   ├── models/                 # Data models"
        echo "│   ├── services/               # Business logic"
        echo "│   └── utils/                  # Utilities"
        echo "├── tests/                      # Test files"
        ;;
    *)
        echo "├── src/                        # Source code"
        echo "├── tests/                      # Test files"
        echo "├── docs/                       # Documentation"
        ;;
esac)
├── docs/                       # Project documentation
├── .env.example                # Environment variables template
└── README.md                   # Project setup and usage
\`\`\`

## 📋 Development Standards

### Code Style
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic"|"react-native")
        echo "- **ESLint + Prettier** for code formatting"
        echo "- **TypeScript strict mode** enabled"
        echo "- **Component naming**: PascalCase for components, camelCase for functions"
        echo "- **File naming**: kebab-case for files, PascalCase for component files"
        ;;
    "flutter-supabase")
        echo "- **Dart analyzer** for code quality"
        echo "- **Widget naming**: PascalCase for widgets"
        echo "- **File naming**: snake_case for files"
        echo "- **Follow effective Dart guidelines**"
        ;;
    "python")
        echo "- **Black + isort** for code formatting"
        echo "- **mypy** for type checking"
        echo "- **flake8 or ruff** for linting"
        echo "- **PEP 8** naming conventions"
        ;;
    *)
        echo "- **Consistent naming conventions**"
        echo "- **Code formatting tools** configured"
        echo "- **Linting rules** enforced"
        ;;
esac)

### Testing Strategy
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic")
        echo "- **Unit tests**: Jest + React Testing Library"
        echo "- **Integration tests**: API route testing"
        echo "- **E2E tests**: Playwright or Cypress"
        echo "- **Coverage target**: 80%+"
        ;;
    "react-native")
        echo "- **Unit tests**: Jest + React Native Testing Library"
        echo "- **E2E tests**: Detox"
        echo "- **Coverage target**: 75%+"
        ;;
    "flutter-supabase")
        echo "- **Unit tests**: Flutter test framework"
        echo "- **Widget tests**: For UI components"
        echo "- **Integration tests**: For full user flows"
        echo "- **Coverage target**: 80%+"
        ;;
    "python")
        echo "- **Unit tests**: pytest"
        echo "- **Coverage**: pytest-cov"
        echo "- **Mocking**: pytest-mock"
        echo "- **Coverage target**: 90%+"
        ;;
    *)
        echo "- **Unit tests**: [Specify testing framework]"
        echo "- **Integration tests**: [Specify approach]"
        echo "- **Coverage target**: 80%+"
        ;;
esac)

## 🚀 Getting Started

### Prerequisites
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic"|"react-native")
        echo "- Node.js 18+ and npm/yarn"
        echo "- [Specify other requirements]"
        ;;
    "flutter-supabase")
        echo "- Flutter SDK 3.0+"
        echo "- Dart SDK"
        echo "- [Platform-specific requirements]"
        ;;
    "python")
        echo "- Python 3.9+"
        echo "- pip or poetry"
        echo "- [Database requirements]"
        ;;
    *)
        echo "- [List all prerequisites]"
        ;;
esac)

### Environment Setup
1. Clone and navigate to project
2. Copy \`.env.example\` to \`.env\` and configure
3. Install dependencies
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic"|"react-native")
        echo "4. Run \`npm install\` or \`yarn install\`"
        echo "5. Run \`npm run dev\` or \`yarn dev\`"
        ;;
    "flutter-supabase")
        echo "4. Run \`flutter pub get\`"
        echo "5. Run \`flutter run\`"
        ;;
    "python")
        echo "4. Create virtual environment: \`python -m venv venv\`"
        echo "5. Activate: \`source venv/bin/activate\` (Linux/Mac) or \`venv\\Scripts\\activate\` (Windows)"
        echo "6. Install dependencies: \`pip install -r requirements.txt\`"
        ;;
    *)
        echo "4. [Installation steps]"
        echo "5. [Run steps]"
        ;;
esac)

### Development Workflow
1. Check \`context-engineering/TASK.md\` for current tasks
2. Create feature branch: \`git checkout -b feature/feature-name\`
3. Write tests first (TDD approach)
4. Implement feature following project patterns
5. Run validation commands (tests, linting)
6. Commit and push changes
7. Create pull request
8. Update TASK.md when complete

## 🎨 Design Patterns

### [Pattern 1: Component Structure]
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic"|"react-native")
        echo "- Use functional components with TypeScript"
        echo "- Props interfaces defined in same file"
        echo "- Custom hooks for logic separation"
        ;;
    "flutter-supabase")
        echo "- StatelessWidget for UI-only components"
        echo "- StatefulWidget for interactive components"
        echo "- Separate business logic into services"
        ;;
    "python")
        echo "- Class-based services for business logic"
        echo "- Dependency injection for testability"
        echo "- Repository pattern for data access"
        ;;
esac)

### [Pattern 2: State Management]
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic")
        echo "- React Context for global state"
        echo "- useState/useReducer for local state"
        echo "- SWR/React Query for server state"
        ;;
    "react-native")
        echo "- [Redux/Zustand/Context] for global state"
        echo "- Local state for component-specific data"
        ;;
    "flutter-supabase")
        echo "- [Riverpod/Bloc/Provider] for state management"
        echo "- Immutable state updates"
        ;;
    "python")
        echo "- Service layer for business logic"
        echo "- Database models for data persistence"
        ;;
esac)

## 🔧 Configuration

### Environment Variables
\`\`\`
$(case $TEMPLATE_TYPE in
    "next-firebase")
        echo "NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key"
        echo "NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_domain"
        echo "NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id"
        ;;
    "next-supabase")
        echo "NEXT_PUBLIC_SUPABASE_URL=your_supabase_url"
        echo "NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key"
        ;;
    "flutter-supabase")
        echo "SUPABASE_URL=your_supabase_url"
        echo "SUPABASE_ANON_KEY=your_anon_key"
        ;;
    "python")
        echo "DATABASE_URL=your_database_url"
        echo "SECRET_KEY=your_secret_key"
        ;;
    *)
        echo "# Add your environment variables here"
        ;;
esac)
\`\`\`

### External Services
$(case $TEMPLATE_TYPE in
    "next-firebase")
        echo "- **Firebase**: Authentication, Firestore, Storage, Functions"
        ;;
    "next-supabase"|"flutter-supabase")
        echo "- **Supabase**: Authentication, Database, Storage, Edge Functions"
        ;;
    *)
        echo "- [List external APIs and services]"
        ;;
esac)

## 📝 Implementation Notes

### Current Status
- [Track major milestones and current progress]

### Known Limitations
- [Document any current limitations or constraints]

### Future Considerations
- [Ideas for future enhancements or architectural changes]

### Decision Log
| Date | Decision | Reasoning |
|------|----------|-----------|
| [Date] | [Technical decision] | [Why this decision was made] |

## 🔗 Resources
- [Documentation links]
- [Useful tutorials or guides]
- [Team communication channels]
EOF

# Create project-specific TASK.md
echo "📝 Creating project-specific TASK.md..."
cat > context-engineering/TASK.md << EOF
# TASK.md - $(basename "$PWD")

## 🎯 Current Sprint/Milestone

**Goal**: [Define current development goal]
**Deadline**: [If applicable]
**Progress**: [0-100%]

## 📋 Active Tasks

### 🔥 High Priority
| Task | Status | Assignee | Due Date | Notes |
|------|--------|----------|----------|-------|
| Project setup and initial architecture | 🔄 In Progress | - | - | Setting up CE structure |

### 📈 Medium Priority
| Task | Status | Assignee | Due Date | Notes |
|------|--------|----------|----------|-------|
| [Add medium priority tasks] | 📋 Pending | - | - | - |

### 🔧 Low Priority / Backlog
- [ ] Set up CI/CD pipeline
- [ ] Add comprehensive documentation
- [ ] Performance optimization
- [ ] Security audit

## 🔄 In Progress

| Task | Started | Progress | Blockers | ETA |
|------|---------|----------|----------|-----|
| Context Engineering Setup | $(date +%Y-%m-%d) | 50% | None | Today |

## ✅ Recently Completed

| Task | Completed | Notes |
|------|-----------|-------|
| [Completed tasks will appear here] | - | - |

## 🐛 Bugs & Issues

| Issue | Priority | Status | Reporter | Notes |
|-------|----------|--------|----------|-------|
| [Bug descriptions] | [High/Med/Low] | 📋 Open | - | - |

## 🚀 Feature Requests

| Feature | Priority | Status | Requester | Notes |
|---------|----------|--------|-----------|-------|
| [Feature descriptions] | [High/Med/Low] | 📋 Backlog | - | - |

## 🔧 Technical Debt

| Item | Impact | Effort | Priority | Notes |
|------|--------|--------|----------|-------|
| [Technical debt items] | [High/Med/Low] | [Hours/Days] | [High/Med/Low] | - |

## 📝 Development Notes

### Architecture Decisions
- [Important architectural decisions and reasoning]

### Implementation Insights
- [Key insights discovered during development]

### Performance Considerations
- [Performance bottlenecks and optimization notes]

### Security Considerations
- [Security requirements and implementation notes]

## 🎯 Upcoming Milestones

### Milestone 1: [Name]
- **Target Date**: [Date]
- **Goals**: [What needs to be accomplished]
- **Dependencies**: [What this depends on]

### Milestone 2: [Name]
- **Target Date**: [Date]
- **Goals**: [What needs to be accomplished]
- **Dependencies**: [What this depends on]

## 📚 Research & Learning

### Technologies to Explore
- [New technologies or techniques to research]

### Documentation to Create
- [Documentation that needs to be written]

### Team Knowledge Sharing
- [Topics for team discussion or knowledge sharing]

---

## 📖 Task Management Guide

### Task Status Icons:
- 📋 **Pending**: Not started
- 🔄 **In Progress**: Currently working on
- ⏸️ **Paused**: Temporarily stopped
- ✅ **Complete**: Finished
- ❌ **Cancelled**: No longer needed
- 🔍 **Review**: Needs review/testing

### Priority Levels:
- 🔥 **Critical**: Blocking other work, security issues
- ⚡ **High**: Important features, user-facing
- 📈 **Medium**: Nice to have, improvements
- 🔧 **Low**: Minor improvements, cleanup

### How to Use:
1. **Add new tasks** to appropriate priority section
2. **Update status** regularly as work progresses
3. **Move completed tasks** to "Recently Completed"
4. **Review weekly** to reprioritize as needed
5. **Archive old completed tasks** monthly
EOF

# Copy PRP templates
echo "📋 Setting up PRP templates..."
mkdir -p context-engineering/PRPs
if [ -d "../../PRPs" ]; then
    cp -r ../../PRPs/* context-engineering/PRPs/ 2>/dev/null || echo "No PRP templates found"
fi

# Copy .claude commands to project root (not inside context-engineering)
echo "🤖 Setting up project-specific Claude commands..."
if [ -d "../../.claude" ]; then
    cp -r ../../.claude .
fi

# Create project README if it doesn't exist
if [ ! -f "README.md" ]; then
    echo "📖 Creating project README.md..."
    cat > README.md << EOF
# $(basename "$PWD")

[Brief description of what this project does]

## 🚀 Quick Start

### Prerequisites
$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic"|"react-native")
        echo "- Node.js 18+"
        echo "- npm or yarn"
        ;;
    "flutter-supabase")
        echo "- Flutter SDK 3.0+"
        echo "- Dart SDK"
        ;;
    "python")
        echo "- Python 3.9+"
        echo "- pip or poetry"
        ;;
    *)
        echo "- [List prerequisites]"
        ;;
esac)

### Installation
\`\`\`bash
# Clone the workspace
git clone [workspace-repo-url]
cd [workspace-name]/$PROJECT_PATH

# Copy environment variables
cp .env.example .env
# Edit .env with your configuration

$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic"|"react-native")
        echo "# Install dependencies"
        echo "npm install"
        echo ""
        echo "# Start development server"
        echo "npm run dev"
        ;;
    "flutter-supabase")
        echo "# Install dependencies"
        echo "flutter pub get"
        echo ""
        echo "# Run the app"
        echo "flutter run"
        ;;
    "python")
        echo "# Create virtual environment"
        echo "python -m venv venv"
        echo "source venv/bin/activate  # Linux/Mac"
        echo "# venv\\Scripts\\activate  # Windows"
        echo ""
        echo "# Install dependencies"
        echo "pip install -r requirements.txt"
        echo ""
        echo "# Run the application"
        echo "python main.py  # or appropriate run command"
        ;;
    *)
        echo "# [Installation commands]"
        echo ""
        echo "# [Run commands]"
        ;;
esac)
\`\`\`

## 📋 Context Engineering

This project uses **Context Engineering** for AI-assisted development.

### Available Commands
- \`/analyze-project\` - Analyze project structure and patterns
- \`/generate-prp [feature.md]\` - Generate Project Requirement Plan
- \`/execute-prp [prp-file.md]\` - Execute implementation from PRP
- \`/add-suggestions-to-tasks\` - Add analysis suggestions to TASK.md

### Key Files
- \`.claude/\` - Claude Code commands (in project root)
- \`context-engineering/CLAUDE.md\` - AI assistant rules for this project
- \`context-engineering/PLANNING.md\` - Project architecture and standards
- \`context-engineering/TASK.md\` - Current tasks and progress
- \`context-engineering/PRPs/\` - Project Requirement Plans

### Development Workflow
1. Check \`context-engineering/TASK.md\` for current tasks
2. For new features, create a feature description file
3. Run \`/generate-prp feature-description.md\` to create implementation plan
4. Run \`/execute-prp PRPs/feature-plan.md\` to implement with AI assistance
5. Update TASK.md when work is complete

## 🏗️ Architecture

[Describe your project architecture, key components, and tech stack]

## 🧪 Testing

$(case $TEMPLATE_TYPE in
    "next-firebase"|"next-supabase"|"next-generic")
        echo "\`\`\`bash"
        echo "# Run tests"
        echo "npm test"
        echo ""
        echo "# Run tests in watch mode"
        echo "npm test -- --watch"
        echo ""
        echo "# Run E2E tests"
        echo "npm run test:e2e"
        echo "\`\`\`"
        ;;
    "react-native")
        echo "\`\`\`bash"
        echo "# Run tests"
        echo "npm test"
        echo ""
        echo "# Run E2E tests"
        echo "npm run test:e2e"
        echo "\`\`\`"
        ;;
    "flutter-supabase")
        echo "\`\`\`bash"
        echo "# Run unit tests"
        echo "flutter test"
        echo ""
        echo "# Run integration tests"
        echo "flutter test integration_test"
        echo "\`\`\`"
        ;;
    "python")
        echo "\`\`\`bash"
        echo "# Run tests"
        echo "pytest"
        echo ""
        echo "# Run with coverage"
        echo "pytest --cov=src"
        echo "\`\`\`"
        ;;
    *)
        echo "\`\`\`bash"
        echo "# [Testing commands]"
        echo "\`\`\`"
        ;;
esac)

## 📝 Documentation

- [Link to detailed documentation]
- [API documentation if applicable]
- [Deployment guide]

## 🤝 Contributing

See the global workspace documentation for contribution guidelines.

## 📄 License

[License information]
EOF
fi

echo ""
echo "✅ Context Engineering setup complete for $(basename "$PWD")!"
echo ""
echo "📁 Project structure created:"
echo "   ├── .claude/               (Claude Code commands - PROJECT ROOT)"
echo "   ├── README.md              (project documentation)"
echo "   ├── .env.example           (environment template)"
echo "   └── context-engineering/"
echo "       ├── CLAUDE.md          (project-specific AI rules)"
echo "       ├── PLANNING.md        (project architecture)"
echo "       ├── TASK.md            (project tasks)"
echo "       ├── PRPs/              (Project Requirement Plans)"
echo "       └── analysis/          (project analysis files)"
echo ""
echo "🤖 Available Claude Commands:"
echo "   ├── /analyze-project       - Analyze this specific project"
echo "   ├── /generate-prp          - Generate PRPs for this project"
echo "   ├── /execute-prp           - Execute PRPs for this project"
echo "   └── /add-suggestions-to-tasks - Add suggestions to this project's TASK.md"
echo ""
echo "🎯 Next Steps:"
echo "   1. Review and customize context-engineering/PLANNING.md"
echo "   2. Add initial tasks to context-engineering/TASK.md"
echo "   3. Run /analyze-project to understand current codebase"
echo "   4. Start developing with AI assistance!"
echo ""
echo "📖 This project now has its own Context Engineering structure!"
echo "   Each project in your workspace can have independent CE setup." 