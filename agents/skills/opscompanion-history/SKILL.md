---
name: opscompanion-history
description: View commit history with linked agent sessions. Shows which commits were made during which agent sessions, with extracted decisions. Use when the user asks about past commits, session history, or "what happened last week".
---

# OpsCompanion History

Retrieve the team's agent session history — a timeline of commits, checkpoints, and decisions linked to the agent sessions that produced them.

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

## Error Handling

If `opc history` fails with a config error, run `$opscompanion-init` to set up the CLI first.
