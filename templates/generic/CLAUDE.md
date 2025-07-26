# Context Engineering - AI Assistant Rules

## 🤖 Assistant Guidelines

You are an AI assistant helping with software development using Context Engineering methodology.

### 📁 Always Reference These Files First
- **PLANNING.md**: Understand the project architecture and conventions before making changes
- **TASK.md**: Check current tasks and add completed work appropriately
- **context-engineering/PRPs/**: Look for existing Project Requirement Plans

### 🎯 Core Development Principles

#### Code Quality & Standards
- **Follow existing patterns**: Always analyze existing code before creating new files
- **Maintain consistency**: Use the same naming conventions, file structure, and coding style
- **Test-driven approach**: Write or update tests for new functionality
- **Documentation**: Update relevant docs when making changes

#### Error Handling & Validation
- **Validate inputs**: Always validate user inputs and API responses
- **Graceful failures**: Handle errors appropriately with user-friendly messages  
- **Logging**: Add appropriate logging for debugging and monitoring
- **Edge cases**: Consider and handle edge cases

#### Security & Performance
- **Security first**: Never expose sensitive data, validate all inputs
- **Performance aware**: Consider performance implications of code changes
- **Resource management**: Properly handle file operations, database connections, etc.

### 🔧 Development Workflow

#### Before Starting Any Work:
1. **Read PLANNING.md** to understand the project structure and conventions
2. **Check TASK.md** to see current work and add new tasks appropriately
3. **Analyze existing code** to understand patterns and conventions
4. **Plan your approach** and break down complex tasks

#### Implementation Process:
1. **Create clear commits** with descriptive messages
2. **Test thoroughly** before marking tasks complete
3. **Update documentation** as needed
4. **Follow validation loops** as defined in PRPs

#### After Completing Work:
1. **Update TASK.md** with completed work and any discoveries
2. **Run tests and validation** to ensure everything works
3. **Update PLANNING.md** if architecture or conventions changed

### 🛠️ Code Conventions

#### General Guidelines
- Use clear, descriptive variable and function names
- Write self-documenting code with appropriate comments
- Follow language-specific best practices
- Keep functions small and focused
- Use consistent indentation and formatting

#### File Organization
- Group related functionality together
- Use clear directory structure
- Separate concerns appropriately
- Keep configuration separate from business logic

### 📝 Communication Style
- **Be explicit**: Always explain what you're doing and why
- **Ask clarifying questions** when requirements are unclear
- **Provide alternatives** when multiple approaches are possible
- **Reference specific files and line numbers** when discussing code

### ⚠️ Important Notes
- **Never assume project type** - ask if unclear about tech stack or frameworks
- **Always preserve existing functionality** unless explicitly asked to change it
- **Respect project structure** - don't reorganize without discussion
- **Keep Context Engineering files updated** as you work

### 🎯 Success Criteria
- Code works as expected and passes all tests
- Documentation is accurate and up-to-date
- Project conventions are followed consistently
- TASK.md reflects current status accurately 