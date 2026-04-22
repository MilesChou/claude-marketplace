#!/usr/bin/env bash
# Usage: find-skill.sh <skill-name>
# Searches for a SKILL.md with matching `name:` frontmatter.
# Outputs the full path(s) found, one per line.
#
# Search order:
#   1. ~/.claude/skills
#   2. Project .claude/skills
#   3. Project plugins/

SKILL_NAME="$1"

if [[ -z "$SKILL_NAME" ]]; then
  echo "Usage: find-skill.sh <skill-name>" >&2
  exit 1
fi

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
search "$PWD"
