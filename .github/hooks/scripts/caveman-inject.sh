#!/usr/bin/env bash
# Injects caveman skill instructions as a system message at session start.
# Reads the skill from the workspace and outputs a JSON systemMessage.

SKILL_FILE="${PWD}/skills/caveman/SKILL.md"

if [[ ! -f "$SKILL_FILE" ]]; then
  # Fallback: skill not found, do not block
  exit 0
fi

# Strip YAML frontmatter (--- ... ---) and output the body
SKILL_BODY=$(awk '/^---/{if(++n==2){found=1;next}} found' "$SKILL_FILE")

SYSTEM_MSG="[CAVEMAN SKILL ACTIVE]\n${SKILL_BODY}"

# Escape the message for JSON
ESCAPED=$(printf '%s' "$SYSTEM_MSG" | python3 -c "import json,sys; print(json.dumps(sys.stdin.read()))")

printf '{"systemMessage": %s}\n' "$ESCAPED"
