#!/usr/bin/env bash
# Usage: find-skill.sh <skill-name> [--plugin-dir <dir>]
# Searches for a SKILL.md with matching `name:` frontmatter.
# Outputs the full path(s) found, one per line.
#
# Search order:
#   1. ~/.claude/skills
#   2. Project .claude/skills
#   3. Project plugins/
#   4. --plugin-dir <dir> (if specified)

SKILL_NAME="$1"
PLUGIN_DIR=""

if [[ -z "$SKILL_NAME" ]]; then
  echo "Usage: find-skill.sh <skill-name> [--plugin-dir <dir>]" >&2
  exit 1
fi

shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --plugin-dir) PLUGIN_DIR="$2"; shift 2 ;;
    *) shift ;;
  esac
done

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"

search() {
  local dir="$1"
  [[ -d "$dir" ]] || return
  find "$dir" -name "SKILL.md" 2>/dev/null | while read -r file; do
    if grep -q "^name: ${SKILL_NAME}$" "$file" 2>/dev/null; then
      echo "$file"
    fi
  done
}

search "$HOME/.claude/skills"

if [[ -n "$PROJECT_ROOT" ]]; then
  search "$PROJECT_ROOT/.claude/skills"
  search "$PROJECT_ROOT/plugins"
fi

if [[ -n "$PLUGIN_DIR" ]]; then
  search "$PLUGIN_DIR"
fi
