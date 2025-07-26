#!/bin/bash

# Context Engineering Setup Script for Flutter + Supabase Projects
# This script sets up the context engineering system in your Flutter project

set -e

echo "🚀 Setting up Context Engineering for Flutter + Supabase..."

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

# Check if this is a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: This doesn't appear to be a Flutter project (no pubspec.yaml found)"
    echo "Please run this script from the root of your Flutter project."
    exit 1
fi

# Check if this is a new or existing project
if grep -q "name:" pubspec.yaml; then
    echo "📦 Detected Flutter project: $(grep "name:" pubspec.yaml | cut -d' ' -f2)"
    PROJECT_TYPE="existing"
    
    # Check for Supabase
    if grep -q "supabase_flutter:" pubspec.yaml; then
        echo "✅ Supabase is already installed"
    else
        echo "📦 Adding Supabase to dependencies..."
        echo "   Please add 'supabase_flutter: ^2.0.0' to your pubspec.yaml"
        echo "   Then run: flutter pub get"
    fi
else
    echo "✨ Setting up for new Flutter project"
    PROJECT_TYPE="new"
fi

# Copy base files
echo "📄 Copying context engineering files..."
cp "$SCRIPT_DIR/CLAUDE.md" ./CLAUDE.md
cp "$SCRIPT_DIR/CONFIG.md" ./CONFIG.md
cp "$SCRIPT_DIR/../../INITIAL_EXAMPLE.md" ./context-engineering/ 2>/dev/null || echo "   INITIAL_EXAMPLE.md not found"

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
- [ ] Add Supabase dependencies to pubspec.yaml
- [ ] Initialize Supabase client
- [ ] Implement authentication flow
- [ ] Set up database operations
- [ ] Configure deep linking for auth

## Completed Tasks
<!-- Move completed tasks here -->

## Discovered During Work
<!-- Add new tasks discovered during development -->
EOF
    echo "   Created TASK.md"
fi

# Create INITIAL.md template
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
- Must work on both Android and iOS
- Must have proper error handling
- Must include test coverage

# EXAMPLES

Look at these files for patterns to follow:
- `lib/core/` - Core utilities and constants
- `lib/supabase/` - Supabase integration patterns
- `lib/features/` - Feature-based architecture
- [Add specific example files from your project]

# DOCUMENTATION

- [Supabase Flutter Docs](https://supabase.com/docs/reference/dart/introduction)
- [Flutter Docs](https://docs.flutter.dev/)
- [Supabase Auth Guide](https://supabase.com/docs/guides/auth/auth-helpers/flutter)
- [Add project-specific documentation links]

# OTHER_CONSIDERATIONS

## Edge Cases to Handle:
- Network connectivity issues
- Auth session expiration
- Database connection errors
- Platform-specific permissions
- App lifecycle changes

## Security Considerations:
- Implement proper RLS policies
- Use secure storage for sensitive data
- Validate all inputs
- Handle auth state properly
- Never expose service role key

## Performance Requirements:
- Optimize database queries
- Implement proper caching
- Use const widgets
- Handle large lists efficiently
- Minimize rebuilds
EOF
echo "   Created INITIAL.md template"

# Create directories
echo "📁 Creating directory structure..."
mkdir -p .claude/commands PRPs/examples lib/supabase lib/core lib/features

# Create basic Supabase client setup
if [ ! -f "lib/supabase/client.dart" ]; then
    cat > lib/supabase/client.dart << 'EOF'
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
}

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }
}
EOF
    echo "   Created lib/supabase/client.dart"
fi

# Create auth service
if [ ! -f "lib/supabase/auth_service.dart" ]; then
    cat > lib/supabase/auth_service.dart << 'EOF'
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  
  User? get currentUser => _client.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
EOF
    echo "   Created lib/supabase/auth_service.dart"
fi

# Create example environment file
if [ ! -f ".env.example" ]; then
    cat > .env.example << 'EOF'
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
EOF
    echo "   Created .env.example"
fi

# Create analysis configuration
cat > analysis_options.yaml << 'EOF'
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Add custom rules here
    avoid_print: true
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    use_build_context_synchronously: true
    
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
EOF
echo "   Created analysis_options.yaml"

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

# Environment
.env

# Flutter build outputs
build/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
EOF
    fi
fi

# For existing projects, analyze and create suggestions
if [ "$PROJECT_TYPE" = "existing" ]; then
    echo "🔍 Analyzing existing Flutter project structure..."
    
    # Create analysis file
    cat > CONTEXT_ANALYSIS.md << 'EOF'
# Context Engineering Analysis

## Detected Patterns

### Project Structure
EOF
    
    # Analyze directory structure
    if [ -d "lib/features" ]; then
        echo "- Using feature-based architecture" >> CONTEXT_ANALYSIS.md
    elif [ -d "lib/screens" ]; then
        echo "- Using screen-based architecture" >> CONTEXT_ANALYSIS.md
    fi
    
    if [ -d "lib/providers" ]; then
        echo "- Using Provider for state management" >> CONTEXT_ANALYSIS.md
    elif [ -d "lib/blocs" ]; then
        echo "- Using Bloc for state management" >> CONTEXT_ANALYSIS.md
    fi
    
    # Check for existing Supabase setup
    if [ -f "lib/supabase.dart" ] || [ -f "lib/services/supabase_service.dart" ]; then
        echo "- Existing Supabase setup detected" >> CONTEXT_ANALYSIS.md
    fi
    
    # Analyze dependencies
    if [ -f "pubspec.yaml" ]; then
        echo -e "\n### Key Dependencies" >> CONTEXT_ANALYSIS.md
        grep -E "flutter|supabase|bloc|provider|riverpod" pubspec.yaml >> CONTEXT_ANALYSIS.md || true
    fi
    
    echo -e "\n## Next Steps\n" >> CONTEXT_ANALYSIS.md
    echo "1. Review and customize PLANNING.md based on your project" >> CONTEXT_ANALYSIS.md
    echo "2. Add Supabase configuration to your environment" >> CONTEXT_ANALYSIS.md
    echo "3. Initialize Supabase in your main.dart" >> CONTEXT_ANALYSIS.md
    echo "4. Update CLAUDE.md if you have specific conventions" >> CONTEXT_ANALYSIS.md
    echo "5. Add current work items to TASK.md" >> CONTEXT_ANALYSIS.md
    
    echo "   Created CONTEXT_ANALYSIS.md with project analysis"
fi

# Create README for the context system
cat > CONTEXT_ENGINEERING_README.md << 'EOF'
# Context Engineering System

This Flutter project uses Context Engineering to provide comprehensive context to AI coding assistants.

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

1. **Environment Variables**: Copy `.env.example` to `.env` and fill in your values
2. **Initialize Supabase**: Add initialization code to `main.dart`
3. **Configure Deep Linking**: Set up URL schemes for auth redirects

## Workflow

1. Describe your feature in `INITIAL.md`
2. AI reads context from all documentation
3. AI implements following validation loops
4. Track progress in `TASK.md`

## Flutter + Supabase Guidelines

This template is optimized for Flutter + Supabase projects:
- Clean architecture patterns
- Proper state management integration
- Platform-specific considerations
- Testing patterns for Supabase operations

See `PLANNING.md` for detailed architecture guidelines.
EOF

echo "✅ Context Engineering setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Set up your Supabase project at https://app.supabase.com"
echo "2. Copy .env.example to .env and add your Supabase credentials"
echo "3. Add supabase_flutter to your pubspec.yaml dependencies"
echo "4. Initialize Supabase in your main.dart file"
echo "5. Review and customize PLANNING.md for your project"
echo "6. Update TASK.md with your current tasks"
echo ""
echo "🤖 Your Flutter project is now ready for AI-assisted development with Supabase!"