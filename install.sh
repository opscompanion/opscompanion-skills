#!/usr/bin/env bash
# OpsCompanion skills installer.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/opscompanion/opscompanion-skills/main/install.sh | bash -s claude
#   curl -fsSL https://raw.githubusercontent.com/opscompanion/opscompanion-skills/main/install.sh | bash -s codex

set -euo pipefail

REPO="https://github.com/opscompanion/opscompanion-skills.git"
INSTALL_DIR="$HOME/.opscompanion/skills"
TARGET="${1:-}"

echo ""
echo "  opscompanion skills installer"
echo ""

# ── Install opc CLI ─────────────────────────────────────────────────────────

if command -v opc &>/dev/null; then
  echo "  opc: $(command -v opc)"
else
  echo "  Installing opc via Homebrew..."
  brew install opscompanion/opc/opc
fi

# ── Download skills ─────────────────────────────────────────────────────────

if [ -d "$INSTALL_DIR/.git" ]; then
  echo "  Updating skills..."
  git -C "$INSTALL_DIR" pull --quiet
else
  echo "  Downloading skills..."
  rm -rf "$INSTALL_DIR"
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --quiet "$REPO" "$INSTALL_DIR"
fi

PLUGIN_DIR="$INSTALL_DIR/plugins/opscompanion"

# ── Mock config if needed ───────────────────────────────────────────────────

CONFIG_FILE="$HOME/.config/opscompanion/config.json"
if [ ! -f "$CONFIG_FILE" ]; then
  mkdir -p "$(dirname "$CONFIG_FILE")"
  cat > "$CONFIG_FILE" <<'EOF'
{
  "api_url": "https://api.opscompanion.dev/v1",
  "api_key": "mock-key"
}
EOF
  echo "  config: mock mode"
fi

# ── Detect or use specified target ──────────────────────────────────────────

if [ -z "$TARGET" ]; then
  if command -v claude &>/dev/null; then
    TARGET="claude"
  elif command -v codex &>/dev/null; then
    TARGET="codex"
  else
    echo "  No agent found. Usage: curl ... | bash -s [claude|codex]"
    exit 1
  fi
fi

# ── Claude Code ─────────────────────────────────────────────────────────────

if [ "$TARGET" = "claude" ]; then
  MARKETPLACE_URL="https://github.com/opscompanion/opscompanion-skills"

  echo "  Registering marketplace..."
  claude plugin marketplace add "$MARKETPLACE_URL" 2>/dev/null || true

  echo "  Installing plugin..."
  claude plugin install opscompanion 2>/dev/null || true

  echo ""
  echo "  Installed for Claude Code."
  echo ""
  echo "  Skills:"
  echo "    /opscompanion-init       Set up OpsCompanion"
  echo "    /opscompanion-context    Load org/team/user context"
  echo "    /opscompanion-recall     Search team memories"
  echo "    /opscompanion-remember   Save a decision"
  echo "    /opscompanion-history    View session history"
fi

# ── Codex ───────────────────────────────────────────────────────────────────

if [ "$TARGET" = "codex" ]; then
  CODEX_DIR="$HOME/.codex"
  mkdir -p "$CODEX_DIR"
  CODEX_INSTRUCTIONS="$CODEX_DIR/instructions.md"

  if [ -f "$CODEX_INSTRUCTIONS" ] && grep -q "# OpsCompanion" "$CODEX_INSTRUCTIONS"; then
    echo "  Codex instructions already configured."
  else
    [ -f "$CODEX_INSTRUCTIONS" ] && echo "" >> "$CODEX_INSTRUCTIONS"
    cat "$PLUGIN_DIR/agents/codex.md" >> "$CODEX_INSTRUCTIONS"
  fi

  echo ""
  echo "  Installed for Codex."
  echo "  Instructions added to ~/.codex/instructions.md"
fi

echo ""
echo "  Restart your agent for changes to take effect."
echo ""
