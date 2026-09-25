#!/bin/sh
# PreToolUse hook — blocks write_file / apply_diff / search_and_replace / insert_content
# calls targeting paths outside the allowed zones in this project.
#
# Allowed paths:
#   retail-banking/src/**
#   retail-banking/pom.xml
#   retail-banking/src/main/resources/db/changelog/changes/**
#   AGENTS.md
#   .bob/**
#
# Exit 2  → blocks the tool call (Bob shows the stderr reason).
# Exit 0  → allows the tool call through.

# Read stdin into a variable
INPUT=$(cat)

# Extract the path field from the JSON payload using only POSIX tools
# Matches: "path": "some/value" or "path":"some/value"
PATH_VAL=$(printf '%s' "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)"/\1/')

# If no path found, allow through
if [ -z "$PATH_VAL" ]; then
  exit 0
fi

# Check against the allowed patterns
case "$PATH_VAL" in
  retail-banking/src/*)
    exit 0 ;;
  retail-banking/pom.xml)
    exit 0 ;;
  AGENTS.md)
    exit 0 ;;
  .bob/*)
    exit 0 ;;
  *)
    printf 'Blocked: writes to "%s" are not allowed.\nOnly retail-banking/src/, retail-banking/pom.xml, AGENTS.md, and .bob/ are permitted.\n' "$PATH_VAL" >&2
    exit 2 ;;
esac
