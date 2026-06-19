#!/usr/bin/env bash
# Cortex maintainer hook (source repo only).
#
# Fires automatically (wired as a Stop hook in .claude/settings.json) so the maintainer never
# forgets to consider a migration. It is deliberately QUIET: it only speaks up when there are
# *structural* template changes (deletes/renames) that don't yet have a migration staged.
# Purely additive template edits produce no noise.
#
# Exit 0 always (non-blocking reminder). Output is surfaced to the session.

# Run from the project root (Claude Code invokes hooks there); fall back to CLAUDE_PROJECT_DIR.
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
command -v git >/dev/null 2>&1 || exit 0

# Nothing to do unless templates/ has uncommitted changes.
[ -n "$(git status --porcelain -- templates/ 2>/dev/null)" ] || exit 0

# Look for structural signals (Deletes / Renames) under templates/ vs HEAD.
namestatus="$(git diff --name-status --find-renames HEAD -- templates/ 2>/dev/null)"
if echo "$namestatus" | grep -qE '^(D|R)'; then
  # If a migration file is already being added/edited, assume it's handled — stay quiet.
  if git status --porcelain -- migrations/ 2>/dev/null | grep -qE '^(\?\?| ?A| ?M)'; then
    exit 0
  fi
  echo "Cortex maintainer check: templates/ has STRUCTURAL changes (deletes/renames) but no migration is staged."
  echo "  -> Run /migration-check to classify them and scaffold migrations/NNN-*.md,"
  echo "     and bump .template-version (MAJOR for breaking changes) in both templates."
fi
exit 0
