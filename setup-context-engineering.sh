#!/bin/bash

# Universal Context Engineering Setup Script
# This script can set up context engineering in any project from this single source

set -e

echo "🚀 Universal Context Engineering Setup"
echo "======================================="
echo ""

# Get the directory where this script is located (the source repo)
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to detect project type
detect_project_type() {
    local project_dir="$1"
    
    if [ -f "$project_dir/package.json" ]; then
        if grep -q "firebase" "$project_dir/package.json" 2>/dev/null; then
            echo "next-firebase"
        elif grep -q "supabase" "$project_dir/package.json" 2>/dev/null; then
            echo "next-supabase"
        elif grep -q "next" "$project_dir/package.json" 2>/dev/null; then
            echo "next-generic"
        else
            echo "node"
        fi
    elif [ -f "$project_dir/pubspec.yaml" ]; then
        if grep -q "supabase" "$project_dir/pubspec.yaml" 2>/dev/null; then
            echo "flutter-supabase"
        else
            echo "flutter-generic"
        fi
    else
        echo "unknown"
    fi
}

# Function to setup project
setup_project() {
    local target_dir="$1"
    local template_type="$2"
    
    echo "📁 Setting up in: $target_dir"
    echo "🎯 Template type: $template_type"
    echo ""
    
    # Navigate to target directory
    cd "$target_dir"
    
    # Copy appropriate template
    case $template_type in
        "next-firebase")
            echo "🔥 Setting up Next.js + Firebase template..."
            bash "$SOURCE_DIR/templates/next-firebase/setup.sh"
            ;;
        "next-supabase")
            echo "🌊 Setting up Next.js + Supabase template..."
            bash "$SOURCE_DIR/templates/next-supabase/setup.sh"
            ;;
        "flutter-supabase")
            echo "📱 Setting up Flutter + Supabase template..."
            bash "$SOURCE_DIR/templates/flutter-supabase/setup.sh"
            ;;
        "manual")
            echo "🎛️  Manual template selection..."
            echo "Available templates:"
            echo "1. Next.js + Firebase"
            echo "2. Next.js + Supabase" 
            echo "3. Flutter + Supabase"
            echo "4. Global Multi-Project Workspace"
            echo "5. Generic (Context Engineering only)"
            echo "6. Custom setup"
            echo ""
            read -p "Choose template (1-6): " template_choice
            
            case $template_choice in
                1) bash "$SOURCE_DIR/templates/next-firebase/setup.sh" ;;
                2) bash "$SOURCE_DIR/templates/next-supabase/setup.sh" ;;
                3) bash "$SOURCE_DIR/templates/flutter-supabase/setup.sh" ;;
                4) bash "$SOURCE_DIR/templates/global-multi-project/setup.sh" ;;
                5) bash "$SOURCE_DIR/templates/generic/setup.sh" ;;
                6) 
                    echo "📋 Custom setup:"
                    echo "Copy files manually from $SOURCE_DIR/templates/"
                    ;;
                *) echo "❌ Invalid choice"; exit 1 ;;
            esac
            ;;
        *)
            echo "❓ Unknown project type. Using manual selection..."
            setup_project "$target_dir" "manual"
            ;;
    esac
}

# Main script logic
if [ $# -eq 0 ]; then
    # Interactive mode
    echo "🎯 Interactive Setup Mode"
    echo ""
    
    read -p "Enter the path to your project directory: " target_dir
    
    if [ ! -d "$target_dir" ]; then
        echo "❌ Directory $target_dir does not exist"
        exit 1
    fi
    
    # Auto-detect project type
    project_type=$(detect_project_type "$target_dir")
    echo "🔍 Detected project type: $project_type"
    
    if [ "$project_type" = "unknown" ]; then
        echo "❓ Could not auto-detect project type"
        setup_project "$target_dir" "manual"
    else
        echo ""
        read -p "Use detected template? (y/n): " use_detected
        if [[ $use_detected =~ ^[Yy]$ ]]; then
            setup_project "$target_dir" "$project_type"
        else
            setup_project "$target_dir" "manual"
        fi
    fi
    
else
    # Command line mode
    target_dir="$1"
    template_type="${2:-auto}"
    
    if [ ! -d "$target_dir" ]; then
        echo "❌ Directory $target_dir does not exist"
        exit 1
    fi
    
    if [ "$template_type" = "auto" ]; then
        template_type=$(detect_project_type "$target_dir")
    fi
    
    setup_project "$target_dir" "$template_type"
fi

echo ""
echo "✅ Context Engineering setup complete!"
echo ""
echo "📖 Documentation created in your project:"
echo "   • CONTEXT_ENGINEERING_README.md - Usage guide"
echo "   • context-engineering/CLAUDE.md - AI assistant rules"
echo "   • context-engineering/PLANNING.md - Project architecture"
echo "   • context-engineering/TASK.md - Task tracking"
echo "   • context-engineering/INITIAL_EXAMPLE.md - Example feature request"
echo ""
echo "🤖 Your project is ready for AI-assisted development!"