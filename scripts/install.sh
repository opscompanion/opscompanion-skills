#!/usr/bin/env bash
# Install OpsCompanion skills plugin for Claude Code.
# Usage: bash scripts/install.sh

set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "$0")/.." && pwd)/plugins/opscompanion"

echo "Installing OpsCompanion skills plugin..."
echo "  Plugin: $PLUGIN_DIR"

# 1. Install opc CLI via Homebrew if not present
if ! command -v opc &>/dev/null; then
  echo ""
  echo "opc CLI not found. Installing via Homebrew..."
  brew install opscompanion/opc/opc
fi

echo "  opc:    $(command -v opc)"
echo "  ver:    $(opc version 2>/dev/null || echo 'unknown')"

# 2. Enable mock mode if no real config exists
CONFIG_FILE="$HOME/.config/opscompanion/config.json"
if [ ! -f "$CONFIG_FILE" ]; then
  echo ""
  echo "No config found. Setting up mock mode..."
  mkdir -p "$(dirname "$CONFIG_FILE")"
  cat > "$CONFIG_FILE" <<'EOF'
{
  "api_url": "https://api.opscompanion.dev/v1",
  "api_key": "mock-key"
}
EOF
  echo "  Config: $CONFIG_FILE (mock mode)"
else
  echo "  Config: $CONFIG_FILE (exists)"
fi

# 3. Install plugin for Claude Code
CLAUDE_PLUGINS_DIR="$HOME/.claude/plugins"
mkdir -p "$CLAUDE_PLUGINS_DIR"

LINK="$CLAUDE_PLUGINS_DIR/opscompanion"
if [ -L "$LINK" ] || [ -d "$LINK" ]; then
  rm -rf "$LINK"
fi
ln -s "$PLUGIN_DIR" "$LINK"
echo "  Linked: $LINK -> $PLUGIN_DIR"

# 4. Verify
echo ""
echo "Verifying..."
opc context >/dev/null 2>&1 && echo "  opc context: OK" || echo "  opc context: failed (run 'opc init' to configure)"

echo ""
echo "Done. Skills available in Claude Code:"
echo "  /opscompanion-init      Set up OpsCompanion"
echo "  /opscompanion-context   Load org/team/user context"
echo "  /opscompanion-recall    Search team memories"
echo "  /opscompanion-remember  Save a decision"
echo "  /opscompanion-history   View session history"
echo ""
echo "Restart Claude Code for the plugin to take effect."
