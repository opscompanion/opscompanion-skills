#!/usr/bin/env bash
# Auto-approve Bash commands that invoke the opc CLI.
# Called by Claude Code's PreToolUse hook system.
# Reads the tool input JSON from stdin, checks if the command starts with "opc".

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"command"[[:space:]]*:[[:space:]]*"//;s/"$//')

# Approve any command that starts with "opc " or is exactly "opc"
if echo "$COMMAND" | grep -qE '^(opc |opc$|/opt/homebrew/bin/opc |/usr/local/bin/opc )'; then
  echo '{"decision":"approve"}'
else
  echo '{"decision":"abstain"}'
fi
