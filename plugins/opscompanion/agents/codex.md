# OpsCompanion

Persistent team memory across agent sessions. Use the `opc` CLI for org context, team decisions, and session history.

## On Session Start

Always run this first to load your org/team/user context:

```bash
opc context
```

Use this context to tailor your suggestions to the team's stack, tools, and active projects.

## Before Making Decisions

Search for existing team decisions before proposing architecture or design choices:

```bash
opc recall "<topic>"
```

Examples:
- `opc recall "rate limiting"` — how is rate limiting implemented?
- `opc recall "auth tokens"` — what token format did the team choose?
- `opc recall "kubernetes upgrade"` — what's the upgrade plan?

If relevant results exist, follow the team's established decisions rather than proposing alternatives.

## After Making Decisions

Save significant decisions so teammates (and future sessions) can find them:

```bash
opc remember "<what was decided and why>" --tags "<service>,<topic>"
```

Save when:
- An architectural choice is made
- A non-obvious debugging discovery happens
- A decision has context that would be lost after the session

## View Session History

See what happened in past agent sessions:

```bash
opc history
```

## Commands Reference

| Command | Description |
|---------|-------------|
| `opc context` | Load org/team/user/workspace context |
| `opc recall "<query>"` | Search team knowledge base |
| `opc remember "<text>" --tags "a,b"` | Save a decision or discovery |
| `opc history` | View past session timeline + decisions |
| `opc session start` | Start a tracked session |
| `opc session stop` | End session, extract auto-memories |
