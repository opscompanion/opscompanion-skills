---
name: opscompanion-context
description: Load org, user, integration, and workspace context to ground the conversation. Use at session start or when the user asks about their org/team/environment context.
---

# OpsCompanion Context

Load organizational context from OpsCompanion to ground this conversation with team knowledge.

## Action

Run:
```bash
opc --agent codex context
```

### Flags

| Flag | Description |
|------|-------------|
| `--full-memory` | Show full memory bodies instead of excerpts |
| `--computed-links` | Include computed workspace links |
| `-v, --verbose` | Show detailed nodes and integration entries |

For a deeper context load with full memory, run:
```bash
opc --agent codex context --full-memory
```

## What This Returns

| Section | Contains |
|---------|----------|
| **Identity** | Organization name, user name, email, public IDs |
| **Integrations** | Configured cloud providers and services |
| **Workspaces** | Workspace names, node counts, providers |
| **Memory** | Organization and user memory (excerpts by default, full with `--full-memory`) |

## How to Use the Context

After loading context, use it to:
- **Tailor suggestions** to the team's stack (e.g., suggest Terraform not Pulumi if that's the org standard)
- **Reference active projects** when the user's request relates to ongoing work
- **Respect deployment cadence** when suggesting deploy-related actions
- **Know the incident process** if something goes wrong

## Error Handling

If `opc --agent codex context` fails with a config error, run `$opscompanion-init` to set up the CLI first.

## Response Format

Present the context as a brief summary, not a raw dump. Highlight what's most relevant to the current conversation.
