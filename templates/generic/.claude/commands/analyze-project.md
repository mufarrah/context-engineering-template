# Analyze Project

## Purpose
Analyzes the existing project structure, code patterns, and conventions to customize the context engineering files accordingly.

## Usage
```bash
/analyze-project
```

## What it does
1. **Analyzes Project Structure**
   - Detects framework (Next.js, React, etc.)
   - Identifies directory structure (src/ vs root)
   - Finds existing patterns and conventions

2. **Updates Context Engineering Files**
   - Customizes `context-engineering/PLANNING.md` based on actual project structure
   - Updates `context-engineering/CLAUDE.md` with detected conventions
   - Creates recommendations in `*_SUGGESTED.md` files

3. **Detects Code Patterns**
   - Import styles (named vs default)
   - Component patterns
   - State management approach
   - Testing framework
   - Styling approach (CSS modules, styled-components, etc.)

4. **Technology Stack Detection**
   - Frontend framework
   - Backend/API setup
   - Database integration
   - Authentication patterns
   - Build tools and configuration

## Output Files
- `context-engineering/PLANNING.md` - Updated with actual architecture
- `context-engineering/CLAUDE.md` - Updated with detected conventions  
- `context-engineering/PLANNING_SUGGESTED.md` - Recommended improvements
- `context-engineering/CLAUDE_SUGGESTED.md` - Suggested convention updates

## Compatibility
Works with all templates:
- Next.js + Firebase
- Next.js + Supabase
- Flutter + Supabase
- Generic projects