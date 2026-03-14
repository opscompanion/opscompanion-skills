---
name: opscompanion-history
description: View commit history with linked agent sessions. Shows which commits were made during which agent sessions, with extracted decisions. Use when the user asks about past commits, session history, or "what happened last week".
user_invocable: true
tools:
  - name: Bash
    allowed_commands:
      - opc
---

# OpsCompanion History

You are retrieving the team's agent session history — a timeline of commits, checkpoints, and decisions linked to the agent sessions that produced them.

## Action

Run:
```bash
opc history
```

## Understanding the Output

The history command returns two sections:

### Session Table
A table with columns:
- **Trigger**: What caused the checkpoint (`git_commit`, `periodic`, `session_stop`)
- **Summary**: What happened in that session
- **Agent**: Which agent was used (Claude Code, Cursor, Codex)
- **Session**: Session ID for cross-reference

### Recent Decisions
Decisions extracted from each session, grouped by session ID.

## How to Present Results

1. **Summarize the timeline** — don't just dump the table
2. **Highlight decisions** — these are the most valuable part
3. **Group by theme** if the user is asking about a specific topic
4. **Link to context** — if a decision relates to an active project, mention it

### Example Response

> Over the last few sessions, the main work has been on the rate-limiter middleware:
> - Webhook retry logic was added with exponential backoff (max 3 retries, 30s cap)
> - A flaky test was fixed by increasing the timeout from 5s to 15s
> - config-service was migrated to a Postgres adapter
>
> Key decisions: sliding-window rate limiting with Redis, PASETO v4 with 1h expiry for auth tokens.

## Error Handling

If `opc history` fails with a config error, invoke the `opscompanion-init` skill to set up the CLI first.
