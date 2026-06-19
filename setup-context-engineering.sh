#!/bin/bash

# Cortex Setup Script
# Copies the appropriate Cortex template into your project or workspace

set -e

echo "Cortex - The Thinking Layer Around Your Codebase"
echo "================================================="
echo ""

# Get the directory where this script is located (the source repo)
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to copy template files (excluding .git)
copy_template() {
    local template_dir="$1"
    local target_dir="$2"

    if [ ! -d "$template_dir" ]; then
        echo "Error: Template directory not found: $template_dir"
        exit 1
    fi

    # Copy all files from template to target, preserving structure.
    # Use rsync when available, but if either path still contains a drive-letter
    # colon (cygpath unavailable on this Windows shell), fall back to cp so
    # rsync doesn't misread it as a remote SSH target.
    if command -v rsync &> /dev/null \
        && [[ "$template_dir" != ?:* ]] \
        && [[ "$target_dir" != ?:* ]]; then
        rsync -a --exclude='.git' "$template_dir/" "$target_dir/"
    else
        cp -r "$template_dir/." "$target_dir/"
    fi
}

# Main script logic
echo "Choose a template:"
echo ""
echo "  1. Single Project (generic)"
echo "     For individual repositories. Adds context engineering,"
echo "     knowledge base, and PRP workflow to one project."
echo ""
echo "  2. Multi-Project Workspace (global)"
echo "     For workspaces managing multiple projects. Includes"
echo "     shared resources, project templates, and cross-project"
echo "     knowledge base."
echo ""

read -p "Choose template (1 or 2): " template_choice

case $template_choice in
    1)
        template_name="generic"
        template_dir="$SOURCE_DIR/templates/generic"
        setup_command="/setup-project"
        ;;
    2)
        template_name="global-multi-project"
        template_dir="$SOURCE_DIR/templates/global-multi-project"
        setup_command="/setup-workspace"
        ;;
    *)
        echo "Error: Invalid choice. Please enter 1 or 2."
        exit 1
        ;;
esac

echo ""

# Get target directory
if [ $# -ge 1 ]; then
    target_dir="$1"
else
    read -p "Enter the path to your target directory: " target_dir
fi

# Expand ~ to home directory
target_dir="${target_dir/#\~/$HOME}"

# On Windows shells (Git Bash / MSYS / Cygwin), rsync treats "C:/foo" as a
# remote SSH target because of the colon. Normalize Windows-style paths to
# MSYS form (e.g. "C:/Users/x" -> "/c/Users/x") so rsync works correctly.
case "$(uname -s 2>/dev/null)" in
    MINGW*|MSYS*|CYGWIN*)
        if command -v cygpath &> /dev/null; then
            target_dir="$(cygpath -u "$target_dir")"
            template_dir="$(cygpath -u "$template_dir")"
        fi
        ;;
esac

# Create target directory if it doesn't exist
if [ ! -d "$target_dir" ]; then
    read -p "Directory $target_dir does not exist. Create it? (y/n): " create_dir
    if [[ $create_dir =~ ^[Yy]$ ]]; then
        mkdir -p "$target_dir"
    else
        echo "Aborted."
        exit 1
    fi
fi

echo ""
echo "Setting up Cortex ($template_name) in: $target_dir"
echo ""

# Copy template
copy_template "$template_dir" "$target_dir"

echo "Done! Cortex files have been copied to: $target_dir"
echo ""
echo "Files created:"
echo "  AGENTS.md              - Agent instructions: navigation, architecture, coding standards"
echo "  CLAUDE.md              - Thin Claude Code entry point (imports AGENTS.md)"
echo "  CONFIG.md              - Commands and skills reference"
echo "  README.md              - Quick start guide"
echo "  .template-version      - Template version (for updates)"
echo "  context-engineering/   - Feature management (PRPs, feature inputs)"
echo "  knowledge-base/        - Concept-centric knowledge base"
echo "  .claude/skills/        - 14 slash commands + 2 built-in skills"

if [ "$template_name" = "global-multi-project" ]; then
    echo "  active-projects/       - Your project repositories"
    echo "  shared/                - Shared resources and templates"
    echo "  docs location:         shared/docs/"
else
    echo "  docs/                  - Documentation guides"
fi

echo ""
echo "Next steps:"
echo "  1. cd $target_dir"

if [ "$template_name" = "global-multi-project" ]; then
    echo "  2. Place your projects in active-projects/"
    echo "  3. Run: $setup_command"
else
    echo "  2. Run: $setup_command"
fi

echo ""
echo "Available commands (run inside your project with Claude Code):"
echo "  $setup_command              - Initial setup (populates docs from your code)"
echo "  /generate-requirements     - Transform feature ideas into requirements"
echo "  /generate-prp              - Generate implementation plan from requirements"
echo "  /execute-prp               - Execute PRP implementation"
echo "  /continue-prp              - Continue phased PRP (Phase 1+)"
echo "  /update-knowledge-base     - Extract knowledge into KB"
echo "  /audit-context             - Project health check"
echo "  /update-template           - Pull latest Cortex updates"
echo ""
echo "See CONFIG.md for the full command reference."
