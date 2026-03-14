---
name: opscompanion-context
description: Load org, team, user, and environment memory to ground the conversation. Use at session start or when the user asks about their org/team/environment context.
user_invocable: true
tools:
  - name: Bash
    allowed_commands:
      - opc
---

# OpsCompanion Context

You are loading organizational context from OpsCompanion to ground this conversation with team knowledge.

## Action

Run:
```bash
opc context
```

## What This Returns

The context command returns structured markdown with four sections:

| Section | Contains |
|---------|----------|
| **Org** | Cloud provider, IaC tool, CI/CD pipeline, observability stack, secrets management, incident process |
| **Team** | Owned services, on-call rotation, deployment cadence, active projects |
| **User** | Role, preferences, recent work, editor, shell |
| **Workspace** | Current branch, working directory |

## How to Use the Context

After loading context, use it to:
- **Tailor suggestions** to the team's stack (e.g., suggest Terraform not Pulumi if that's the org standard)
- **Reference active projects** when the user's request relates to ongoing work
- **Respect deployment cadence** when suggesting deploy-related actions
- **Know the incident process** if something goes wrong

## Error Handling

If `opc context` fails with a config error, invoke the `opscompanion-init` skill to set up the CLI first.

## Response Format

Present the context as a brief summary, not a raw dump. Highlight what's most relevant to the current conversation. Example:

> You're on **platform-eng** at **acme-corp**. Your team owns api-gateway, auth-service, config-service, and internal-tools. Active projects include the JWT→PASETO migration and K8s 1.28→1.30 upgrade.
