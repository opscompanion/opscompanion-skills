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
  SKILLS_SRC="$INSTALL_DIR/agents/skills"
  SKILLS_DST="$HOME/.agents/skills"
  mkdir -p "$SKILLS_DST"

  for skill in opscompanion-init opscompanion-context opscompanion-recall opscompanion-remember opscompanion-history; do
    LINK="$SKILLS_DST/$skill"
    [ -L "$LINK" ] || [ -d "$LINK" ] && rm -rf "$LINK"
    ln -s "$SKILLS_SRC/$skill" "$LINK"
  done

  echo ""
  echo "  Installed for Codex."
  echo ""
  echo "  Skills (in ~/.agents/skills/):"
  echo "    \$opscompanion-init       Set up OpsCompanion"
  echo "    \$opscompanion-context    Load org/team/user context"
  echo "    \$opscompanion-recall     Search team memories"
  echo "    \$opscompanion-remember   Save a decision"
  echo "    \$opscompanion-history    View session history"
fi

echo ""
echo "  Restart your agent for changes to take effect."
echo ""
