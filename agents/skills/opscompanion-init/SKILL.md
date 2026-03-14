---
name: opscompanion-init
description: Set up OpsCompanion with your API key and org configuration. Use when the user says "set up opscompanion", "configure opscompanion", or when any other opscompanion skill reports it's not configured.
---

# OpsCompanion Setup

You are helping the user configure OpsCompanion (`opc`) for their Codex environment.

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

## Install for Codex

After init succeeds, run the installer to set up skills and hooks in one step:

```bash
opc install --agent codex
```

This will:
- Download/update the OpsCompanion skills repository
- Symlink skills into `~/.agents/skills/`
- Write `.codex/hooks.json` with hooks for session lifecycle and tool capture

All generated hooks include `--agent codex` so opc knows which runtime is calling it.

## Verification

Verify the setup by loading context:

```bash
opc --agent codex context
```

If this prints org/team/user details, the setup is complete.

## Response Format

After completing setup:
- Confirm which config file was written
- Confirm skills and hooks were installed
- Show the org name from `opc --agent codex context` to prove it works
