---
name: opscompanion-search
description: Search stored organization knowledge or user memory. Use when the user asks "what did we decide about...", "do you remember...", or needs to look up a past decision.
---

# OpsCompanion Search

Search the team's shared knowledge base for past decisions, discoveries, and context.

## Action

Run:
```bash
opc --agent codex search "<query>"
```

Where `<query>` is the user's search terms. Extract the core topic from the user's question.

### Flags

| Flag | Default | Description |
|------|---------|-------------|
| `--scope` | `organization` | Search scope: `organization`, `user`, or `both` |
| `--mode` | `keyword` | Search mode: `keyword` or `regex` |
| `--limit` | `10` | Maximum number of results |
| `--include-content` | off | Include full matched content in results |
| `--case-sensitive` | off | Enable case-sensitive search |

### Query Strategy

| User says | Query to use |
|-----------|-------------|
| "what did we decide about rate limiting?" | `"rate limiting"` |
| "do you remember the auth migration?" | `"auth migration"` |
| "how are we doing the k8s upgrade?" | `"kubernetes upgrade"` |
| "why did we pick Redis?" | `"Redis"` |

Use specific, topic-focused queries. For broader searches, use `--scope both` to include user memory.

### Examples

```bash
# Basic keyword search
opc --agent codex search "rate limiting"

# Search both org and user memory with full content
opc --agent codex search "auth migration" --scope both --include-content

# Regex search for specific patterns
opc --agent codex search "redis.*connection" --mode regex
```

## Understanding Results

Each result includes:
- **Type**: Decision, Discovery, or Context
- **Content**: The actual knowledge
- **Tags**: Topic categories
- **Author**: Who captured this
- **Date**: When it was captured

## How to Present Results

1. Lead with the most relevant result
2. Synthesize related results into a coherent answer
3. Cite the source: who captured it and when
4. Flag if results are stale (more than 30 days old)
5. If no results found, say so clearly and suggest the user save the decision with `opc --agent codex remember`

## Error Handling

If `opc --agent codex search` fails with a config error, run `$opscompanion-init` to set up the CLI first.
