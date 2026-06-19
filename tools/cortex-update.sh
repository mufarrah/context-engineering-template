#!/usr/bin/env bash
# Cortex first-run bootstrap (macOS/Linux/Git-Bash).
#
# Installs the latest migration runner (the `/update-template` skill) into an existing,
# older Cortex repo so you can then run it from Claude Code. This solves the chicken-and-egg
# of the very first upgrade (an old repo's own update logic can't migrate itself).
#
# Usage:
#   tools/cortex-update.sh [target-dir] [template-repo-url]
#   CORTEX_TEMPLATE_REPO=https://github.com/<you>/context-engineering-template tools/cortex-update.sh ../my-project
#
# After it runs: open the target repo in Claude Code and run  /update-template
set -euo pipefail

TARGET="${1:-.}"
REPO="${2:-${CORTEX_TEMPLATE_REPO:-}}"

if [ -z "$REPO" ]; then
  echo "Provide your template repo URL:"
  echo "  tools/cortex-update.sh <target-dir> <template-repo-url>"
  echo "  (or export CORTEX_TEMPLATE_REPO=...)"
  exit 1
fi

if [ ! -d "$TARGET/context-engineering" ]; then
  echo "Error: '$TARGET' does not look like a Cortex repo (no context-engineering/)."
  exit 1
fi

# Detect template kind from the target's layout.
if [ -d "$TARGET/active-projects" ] || [ -d "$TARGET/shared" ]; then
  KIND="global-multi-project"
else
  KIND="generic"
fi
echo "Detected template kind: $KIND"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Fetching latest template from $REPO ..."
git clone --depth 1 "$REPO" "$TMP" >/dev/null 2>&1 || { echo "Error: git clone failed ($REPO)."; exit 1; }

SRC="$TMP/templates/$KIND/.claude/skills/update-template/SKILL.md"
if [ ! -f "$SRC" ]; then
  echo "Error: migration runner not found in template at $SRC"
  exit 1
fi

DEST="$TARGET/.claude/skills/update-template"
mkdir -p "$DEST"
cp -f "$SRC" "$DEST/SKILL.md"

# Bake the repo URL into the runner's CONFIG so it can fetch at run time.
sed -i.bak "s#{TEMPLATE_REPO_URL}#$REPO#g" "$DEST/SKILL.md" && rm -f "$DEST/SKILL.md.bak"

echo ""
echo "✓ Installed the Cortex migration runner -> $DEST/SKILL.md"
echo ""
echo "Next steps:"
echo "  1. Open '$TARGET' in Claude Code"
echo "  2. Run:  /update-template"
echo "     It will show a dry-run plan, back up your files, and migrate with your confirmation."
