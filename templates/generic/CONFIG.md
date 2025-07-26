# CONFIG.md - Generic Project Context Engineering

## 🚀 Available Commands & Workflows

### 🤖 **Claude Code Commands** (Available in any project)
```bash
/analyze-project              # Analyze project structure and customize CE files
/generate-prp [feature.md]    # Generate Project Requirement Plan
/execute-prp [prp-file.md]    # Execute implementation from PRP
/add-suggestions-to-tasks     # Add analysis suggestions to TASK.md
/setup-project                # Setup Context Engineering in existing project
```

### 📋 **Context Engineering Workflow**

#### Complete Development Workflow
```bash
# 1. Check current tasks
cat context-engineering/TASK.md

# 2. Create feature description
echo "# Feature: New Authentication System" > new-feature.md
echo "Add secure user login with JWT tokens" >> new-feature.md

# 3. Generate PRP
/generate-prp new-feature.md

# 4. Review generated plan
cat context-engineering/PRPs/new-feature.md

# 5. Execute implementation
/execute-prp context-engineering/PRPs/new-feature.md

# 6. Update tasks with discoveries
/add-suggestions-to-tasks
```

## 🛠️ Development Commands

### **Code Quality & Testing**
```bash
# These commands depend on your project's tech stack
# Update based on your specific tools:

# For Node.js/JavaScript projects:
npm test                      # Run tests
npm run lint                  # Check code quality
npm run build                 # Build for production
npm run dev                   # Start development server

# For Python projects:
python -m pytest             # Run tests
python -m pylint src/         # Check code quality
python -m mypy src/           # Type checking
python setup.py build        # Build project

# For Go projects:
go test ./...                 # Run tests
go vet ./...                  # Check code quality
go build                      # Build binary
go run main.go                # Run development server

# For Rust projects:
cargo test                    # Run tests
cargo clippy                  # Check code quality
cargo build                   # Build project
cargo run                     # Run development version
```

### **Git & Version Control**
```bash
# Standard Git workflow
git status                    # Check current status
git add .                     # Stage changes
git commit -m "descriptive message"  # Commit with message
git push origin feature-branch       # Push to remote

# Branch management
git checkout -b feature/new-feature  # Create feature branch
git checkout main             # Switch to main branch
git merge feature/new-feature # Merge feature branch
git branch -d feature/new-feature    # Delete merged branch
```

### **Project Management**
```bash
# View project structure
tree                          # Show directory tree
find . -name "*.md"          # Find all markdown files
grep -r "TODO" src/          # Find all TODO comments

# Documentation
ls context-engineering/       # View CE files
cat context-engineering/PLANNING.md  # View project architecture
grep -E "(In Progress|Pending)" context-engineering/TASK.md  # View active tasks
```

## 📊 Project Analysis & Monitoring

### **Codebase Analysis**
```bash
# File statistics (adapt based on your language)
find src/ -name "*.py" | wc -l       # Count Python files
find src/ -name "*.js" | wc -l       # Count JavaScript files
find src/ -name "*.go" | wc -l       # Count Go files

# Code complexity (language-specific tools)
# For Python: radon cc src/
# For JavaScript: complexity-report
# For Go: gocyclo
```

### **Testing & Coverage**
```bash
# Test coverage (adapt based on your tools)
# For Python: pytest --cov=src
# For JavaScript: npm run test:coverage
# For Go: go test -cover ./...
```

## 🔧 Environment & Configuration

### **Environment Management**
```bash
# Environment variables
cp .env.example .env          # Copy environment template
cat .env.example              # View required variables

# Virtual environments (language-specific)
# For Python: python -m venv venv && source venv/bin/activate
# For Node.js: npm install
# For Go: go mod download
```

### **Database Operations** (if applicable)
```bash
# Common database commands (adapt to your database)
# For SQL databases:
# psql -U username -d database  # Connect to PostgreSQL
# mysql -u username -p database # Connect to MySQL

# For NoSQL databases:
# mongo                         # Connect to MongoDB
# redis-cli                     # Connect to Redis
```

## 📚 Documentation & Help

### **View Documentation**
```bash
# Context Engineering documentation
cat context-engineering/CLAUDE.md    # AI assistant rules
cat context-engineering/PLANNING.md  # Project architecture
cat context-engineering/TASK.md      # Current tasks
cat context-engineering/INITIAL_EXAMPLE.md  # Example feature request

# Project documentation
cat README.md                 # Project overview
ls docs/                      # Additional documentation
```

### **Quick References**
```bash
# Command help (language-specific)
# For Python: python --help
# For Node.js: npm help
# For Go: go help
# For Rust: cargo help

# Tool-specific help
git help [command]            # Git command help
[your-tool] --help           # Tool-specific help
```

## 🚀 Quick Reference

### **File Locations**
- **Context Engineering files**: `context-engineering/` (CLAUDE.md, PLANNING.md, TASK.md, etc.)
- **Claude commands**: `.claude/` (project-specific commands)
- **Project docs**: `README.md`, `docs/`
- **Configuration**: Based on your tech stack (package.json, requirements.txt, go.mod, etc.)

### **Essential Workflow**
1. **Read**: `context-engineering/PLANNING.md` to understand project
2. **Check**: `context-engineering/TASK.md` for current work
3. **Plan**: Create feature description file
4. **Generate**: Use `/generate-prp` for implementation plan
5. **Execute**: Use `/execute-prp` for AI-assisted implementation
6. **Update**: Use `/add-suggestions-to-tasks` for discoveries

### **Common Tasks**
- **Start new feature**: Create description → `/generate-prp` → `/execute-prp`
- **Check project status**: Review `TASK.md` and `PLANNING.md`
- **Update project**: Use `/analyze-project` after major changes
- **Quality check**: Run tests, linting, and validation commands

---

## ⚠️ Important Notes

### **Customization Required**
This is a generic template - you'll need to customize:
- **Tech stack specific commands** in the "Development Commands" section
- **Project-specific tools** and their commands
- **Environment setup** instructions
- **Database and deployment** commands

### **Best Practices**
- Update this CONFIG.md as you add new tools or change workflows
- Keep commands organized by category
- Include examples for complex operations
- Document any project-specific quirks or requirements

### **Getting Help**
- Check `context-engineering/PLANNING.md` for project-specific patterns
- Use `/analyze-project` to understand codebase conventions
- Refer to tool-specific documentation for detailed usage 