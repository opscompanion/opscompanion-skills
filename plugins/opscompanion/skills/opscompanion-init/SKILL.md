---
name: opscompanion-init
description: Set up OpsCompanion with your API key and org configuration. Use when the user says "set up opscompanion", "configure opscompanion", or when any other opscompanion skill reports it's not configured.
user_invocable: true
tools:
  - name: Bash
    allowed_commands:
      - opc
      - which
      - command
      - brew
---

# OpsCompanion Setup

You are helping the user configure OpsCompanion (`opc`) for their Claude Code environment.

## Preflight

1. Check that `opc` is installed:
   ```bash
   command -v opc || which opc
   ```
2. If not installed, install via Homebrew:
   ```bash
   brew install opscompanion/opc/opc
   ```
   Do NOT suggest building from source. Always use Homebrew.

## Configuration

Run the interactive init to configure API key and endpoint:

```bash
opc init
```

This writes config to `~/.config/opscompanion/config.json`.

For development/demo mode, the user can use `mock-key` as the API key — this enables full mock responses without a real backend.

## Install for Claude Code

After init succeeds, run the installer to set up skills, hooks, and plugin registration in one step:

```bash
opc install --agent claude
```

This will:
- Download/update the OpsCompanion skills repository
- Register the plugin marketplace and install the plugin
- Write `.claude/settings.local.json` with hooks for:
  - **PreToolUse** — captures every tool invocation before execution
  - **PostToolUse** — captures every tool result
  - **SessionStart** — loads org/team/user context on startup
  - **Stop** — creates final checkpoint and extracts memories on session end

All generated hooks include `--agent claude` so opc knows which runtime is calling it.

## Verification

Verify the setup by loading context:

```bash
opc --agent claude context
```

If this prints org/team/user details, the setup is complete.

## Response Format

After completing setup:
- Confirm which config file was written
- Confirm hooks and plugin were installed
- Show the org name from `opc --agent claude context` to prove it works
- Remind the user to restart their Claude Code session for hooks to take effect
