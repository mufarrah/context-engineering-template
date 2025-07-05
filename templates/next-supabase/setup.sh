#!/bin/bash

# Context Engineering Setup Script for Next.js + Supabase Projects
# This script sets up the context engineering system in your project

set -e

echo "🚀 Setting up Context Engineering for Next.js + Supabase..."

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

# Check if this is a new or existing project
if [ -f "package.json" ]; then
    echo "📦 Detected existing Next.js project"
    PROJECT_TYPE="existing"
    
    # Check for Supabase
    if grep -q "@supabase/supabase-js" package.json; then
        echo "✅ Supabase is already installed"
    else
        echo "📦 Installing Supabase dependencies..."
        npm install @supabase/supabase-js @supabase/auth-helpers-nextjs
    fi
else
    echo "✨ Setting up for new project"
    PROJECT_TYPE="new"
fi

# Copy base files
echo "📄 Copying context engineering files..."
if [ -f "CLAUDE.md" ]; then
    echo "📝 CLAUDE.md exists. Creating CLAUDE_NEW.md for reference..."
    cp "$SCRIPT_DIR/CLAUDE.md" ./CLAUDE_NEW.md
    echo "   Please review and merge CLAUDE_NEW.md with your existing CLAUDE.md"
else
    cp "$SCRIPT_DIR/CLAUDE.md" ./CLAUDE.md
    echo "   Created CLAUDE.md"
fi

# Create or update PLANNING.md
if [ -f "PLANNING.md" ]; then
    echo "📝 PLANNING.md exists. Creating PLANNING_NEW.md for reference..."
    cp "$SCRIPT_DIR/PLANNING_TEMPLATE.md" ./PLANNING_NEW.md
    echo "   Please merge PLANNING_NEW.md with your existing PLANNING.md"
else
    cp "$SCRIPT_DIR/PLANNING_TEMPLATE.md" ./PLANNING.md
    echo "   Created PLANNING.md - Please customize it for your project"
fi

# Create TASK.md if it doesn't exist
if [ ! -f "TASK.md" ]; then
    cat > TASK.md << 'EOF'
# Task Tracking

## Active Tasks

### $(date +%Y-%m-%d) - Initial Setup
- [ ] Set up Supabase project
- [ ] Configure environment variables
- [ ] Generate TypeScript types from schema
- [ ] Implement authentication
- [ ] Set up RLS policies
- [ ] Create initial database migrations

## Completed Tasks
<!-- Move completed tasks here -->

## Discovered During Work
<!-- Add new tasks discovered during development -->
EOF
    echo "   Created TASK.md"
fi

# Create INITIAL.md template
if [ ! -f "INITIAL.md" ]; then
    cat > INITIAL.md << 'EOF'
# FEATURE: [Feature Name]

<!-- 
This file is used to describe new features before implementation.
It will be used to generate a comprehensive PRP (Product Requirements Prompt).
-->

[Describe what you want to build in detail]

## Requirements:
- [List specific requirements]
- [Include technical constraints]
- [Define success criteria]

## Technical Constraints:
- Must use Supabase Auth for authentication
- Must implement proper RLS policies
- Must follow existing patterns in PLANNING.md
- Must use generated TypeScript types
- Must have test coverage

# EXAMPLES

Look at these files for patterns to follow:
- `${BASE_DIR}/lib/supabase/` - Supabase client setup
- `${BASE_DIR}/services/` - Database query patterns
- [Add specific example files from your project]

# DOCUMENTATION

- [Supabase Docs](https://supabase.com/docs)
- [Supabase Auth Helpers for Next.js](https://supabase.com/docs/guides/auth/auth-helpers/nextjs)
- [Next.js Docs](https://nextjs.org/docs)
- [Add project-specific documentation links]

# OTHER_CONSIDERATIONS

## Edge Cases to Handle:
- Database connection errors
- Auth session expiration
- RLS policy violations
- Network failures
- Race conditions in real-time updates

## Security Considerations:
- Implement proper RLS policies
- Validate all inputs
- Use parameterized queries
- Never expose service role key
- Handle auth properly

## Performance Requirements:
- Optimize database queries
- Implement proper pagination
- Use database indexes
- Cache when appropriate
EOF
    echo "   Created INITIAL.md template"
fi

# Detect if project uses src directory
if [ -d "src" ]; then
    echo "📁 Detected src/ directory structure"
    BASE_DIR="src"
else
    echo "📁 Using root directory structure"
    BASE_DIR="."
fi

# Create directories
echo "📁 Creating directory structure..."
mkdir -p .claude/commands PRPs/examples
mkdir -p "$BASE_DIR/lib/supabase" "$BASE_DIR/services" "$BASE_DIR/hooks"

# Copy command files
cp -r "$SCRIPT_DIR/.claude/commands/"* ./.claude/commands/ 2>/dev/null || echo "   No Claude commands to copy"

# Create scripts directory
mkdir -p scripts

# Create Supabase type generation script
cat > scripts/generate-types.sh << 'EOF'
#!/bin/bash
# Generate TypeScript types from Supabase schema

echo "🔄 Generating TypeScript types from Supabase..."

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Please install it first:"
    echo "   npm install -g supabase"
    exit 1
fi

# Detect base directory
if [ -d "src" ]; then
    BASE_DIR="src"
else
    BASE_DIR="."
fi

# Generate types
npx supabase gen types typescript --project-id "$NEXT_PUBLIC_SUPABASE_PROJECT_ID" > "$BASE_DIR/lib/supabase/types.ts"

echo "✅ Types generated successfully!"
EOF
chmod +x scripts/generate-types.sh

# Create basic Supabase client setup
if [ ! -f "$BASE_DIR/lib/supabase/client.ts" ]; then
    cat > "$BASE_DIR/lib/supabase/client.ts" << 'EOF'
import { createBrowserClient } from '@supabase/ssr'
import type { Database } from './types'

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
EOF
    echo "   Created $BASE_DIR/lib/supabase/client.ts"
fi

if [ ! -f "$BASE_DIR/lib/supabase/server.ts" ]; then
    cat > "$BASE_DIR/lib/supabase/server.ts" << 'EOF'
import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { cookies } from 'next/headers'
import type { Database } from './types'

export function createClient() {
  const cookieStore = cookies()

  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value
        },
        set(name: string, value: string, options: CookieOptions) {
          cookieStore.set({ name, value, ...options })
        },
        remove(name: string, options: CookieOptions) {
          cookieStore.set({ name, value: '', ...options })
        },
      },
    }
  )
}
EOF
    echo "   Created $BASE_DIR/lib/supabase/server.ts"
fi

# Create example environment variables file
if [ ! -f ".env.local.example" ]; then
    cat > .env.local.example << 'EOF'
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Optional: For type generation
NEXT_PUBLIC_SUPABASE_PROJECT_ID=your-project-id
EOF
    echo "   Created .env.local.example"
fi

# Create .gitignore entries
if [ -f ".gitignore" ]; then
    echo "📝 Updating .gitignore..."
    if ! grep -q "# Context Engineering" .gitignore; then
        cat >> .gitignore << 'EOF'

# Context Engineering (optional - remove if you want to track these)
INITIAL.md
PRPs/*
!PRPs/examples
!PRPs/templates
.claude/commands/*_output.md

# Supabase
.env.local
supabase/.temp
supabase/.branches
EOF
    fi
fi

# For existing projects, analyze and create suggestions
if [ "$PROJECT_TYPE" = "existing" ]; then
    echo "🔍 Analyzing existing project structure..."
    
    # Create analysis file
    cat > CONTEXT_ANALYSIS.md << 'EOF'
# Context Engineering Analysis

## Detected Patterns

### Project Structure
EOF
    
    # Analyze directory structure
    if [ -d "src" ]; then
        echo "- Using src/ directory structure" >> CONTEXT_ANALYSIS.md
    elif [ -d "app" ]; then
        echo "- Using Next.js app directory" >> CONTEXT_ANALYSIS.md
    fi
    
    # Check for existing Supabase setup
    if [ -f "lib/supabase/client.ts" ] || [ -f "src/lib/supabase/client.ts" ] || [ -f "utils/supabase.ts" ] || [ -f "src/utils/supabase.ts" ]; then
        echo "- Existing Supabase client setup detected" >> CONTEXT_ANALYSIS.md
    fi
    
    # Analyze dependencies
    if [ -f "package.json" ]; then
        echo -e "\n### Key Dependencies" >> CONTEXT_ANALYSIS.md
        grep -E '"(next|react|@supabase|typescript)"' package.json >> CONTEXT_ANALYSIS.md || true
    fi
    
    echo -e "\n## Next Steps\n" >> CONTEXT_ANALYSIS.md
    echo "1. Review and customize PLANNING.md based on your project" >> CONTEXT_ANALYSIS.md
    echo "2. Set up Supabase environment variables in .env.local" >> CONTEXT_ANALYSIS.md
    echo "3. Generate TypeScript types: npm run generate:types" >> CONTEXT_ANALYSIS.md
    echo "4. Update CLAUDE.md if you have specific conventions" >> CONTEXT_ANALYSIS.md
    echo "5. Add current work items to TASK.md" >> CONTEXT_ANALYSIS.md
    
    echo "   Created CONTEXT_ANALYSIS.md with project analysis"
fi

# Add scripts to package.json if it exists
if [ -f "package.json" ] && command -v jq &> /dev/null; then
    echo "📝 Adding helper scripts to package.json..."
    jq '.scripts += {
        "generate:types": "bash scripts/generate-types.sh",
        "db:reset": "supabase db reset",
        "db:push": "supabase db push",
        "db:pull": "supabase db pull"
    }' package.json > package.json.tmp && mv package.json.tmp package.json
fi

# Create README for the context system
cat > CONTEXT_ENGINEERING_README.md << 'EOF'
# Context Engineering System

This project uses Context Engineering to provide comprehensive context to AI coding assistants.

## Quick Start

1. **For AI Assistants**: Start by reading `CLAUDE.md` and `PLANNING.md`
2. **For New Features**: Create an `INITIAL.md` file describing what you want to build
3. **Track Progress**: Use `TASK.md` to track ongoing work

## Key Files

- **CLAUDE.md**: Global rules and conventions for AI assistants
- **PLANNING.md**: Project architecture and patterns
- **TASK.md**: Current and completed tasks
- **INITIAL.md**: Feature request template
- **PRPs/**: Detailed implementation plans

## Supabase Setup

1. **Environment Variables**: Copy `.env.local.example` to `.env.local` and fill in your values
2. **Generate Types**: Run `npm run generate:types` to create TypeScript types from your schema
3. **Database Migrations**: Use Supabase CLI for managing migrations

## Workflow

1. Describe your feature in `INITIAL.md`
2. AI reads context from all documentation
3. AI implements following validation loops
4. Track progress in `TASK.md`

## Supabase-Specific Guidelines

This template is optimized for Next.js + Supabase projects:
- Server vs Client component patterns
- RLS policy implementation
- Type-safe database operations
- Auth flow best practices

See `PLANNING.md` for detailed architecture guidelines.
EOF

echo "✅ Context Engineering setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Set up your Supabase project at https://app.supabase.com"
echo "2. Copy .env.local.example to .env.local and add your Supabase credentials"
echo "3. Generate TypeScript types: npm run generate:types"
echo "4. Review and customize PLANNING.md for your project"
echo "5. Update TASK.md with your current tasks"
echo ""
echo "🤖 Your project is now ready for AI-assisted development with Supabase!"