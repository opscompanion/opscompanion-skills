# OpsCompanion Skills

Claude Code plugin that connects to the [OpsCompanion](https://github.com/opscompanion/opc) CLI — persistent team memory across agent sessions.

## Quick Start

```bash
# Install the skills plugin (installs opc via Homebrew automatically if needed)
bash scripts/install.sh
```

Or install the CLI separately first:
```bash
brew install opscompanion/opc/opc
```

The install script auto-configures mock mode if no API key exists, so you can demo immediately.

## Skills

| Skill | Trigger | What it does |
|-------|---------|-------------|
| `/opscompanion-init` | "set up opscompanion" | Configure API key, install hooks |
| `/opscompanion-context` | "show my org context" | Load org/team/user context |
| `/opscompanion-recall` | "what did we decide about..." | Search team knowledge base |
| `/opscompanion-remember` | "remember this decision" | Save decisions for future recall |
| `/opscompanion-history` | "what happened last session" | View session timeline + decisions |

## Mock Mode

Set `api_key` to `mock-key` in `~/.config/opscompanion/config.json` (or set `OPSCOMPANION_MOCK=true`) to use realistic mock responses without a backend. The install script does this automatically if no config exists.

## Using with Codex

Codex uses a different plugin model. To use OpsCompanion with Codex:

```bash
# Add to your codex instructions or system prompt:
# "Use `opc` CLI for team context and memory. Run `opc context` at start,
#  `opc recall <query>` to search decisions, `opc remember <text>` to save."

# Or set up as a Codex agent instruction file:
cp plugins/opscompanion/skills/opscompanion-context/SKILL.md .codex/agents/opscompanion.md
```

## Structure

```
opscompanion-skills/
├── .claude-plugin/
│   └── marketplace.json          # Plugin registry
├── plugins/opscompanion/
│   ├── .claude-plugin/
│   │   └── plugin.json           # Plugin metadata
│   ├── hooks/
│   │   ├── hooks.json            # Auto-approve opc commands
│   │   └── auto-approve-opc.sh   # Hook script
│   └── skills/
│       ├── opscompanion-init/    # Setup skill
│       ├── opscompanion-context/ # Org context skill
│       ├── opscompanion-recall/  # Memory search skill
│       ├── opscompanion-remember/# Memory save skill
│       └── opscompanion-history/ # Session history skill
├── scripts/
│   └── install.sh                # One-command install
└── README.md
```
