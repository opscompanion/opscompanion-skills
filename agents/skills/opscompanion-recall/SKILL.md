---
name: opscompanion-recall
description: Search stored memories for specific knowledge, decisions, or past context. Use when the user asks "what did we decide about...", "do you remember...", or needs to look up a past decision.
---

# OpsCompanion Recall

Search the team's shared knowledge base for past decisions, discoveries, and context.

## Action

Run:
```bash
opc --agent codex recall "<query>"
```

Where `<query>` is the user's search terms. Extract the core topic from the user's question.

### Query Strategy

| User says | Query to use |
|-----------|-------------|
| "what did we decide about rate limiting?" | `"rate limiting"` |
| "do you remember the auth migration?" | `"auth migration tokens"` |
| "how are we doing the k8s upgrade?" | `"kubernetes cluster upgrade"` |
| "why did we pick Redis?" | `"Redis decision"` |

Use specific, topic-focused queries. Include related terms to improve semantic matching.

## Understanding Results

Each result includes:
- **Type**: Decision, Discovery, or Context
- **Content**: The actual knowledge
- **Relevance**: 0.0–1.0 confidence score
- **Tags**: Topic categories
- **Author**: Who captured this
- **Date**: When it was captured

## How to Present Results

1. Lead with the most relevant result (highest relevance score)
2. Synthesize related results into a coherent answer
3. Cite the source: who captured it and when
4. Flag if results are stale (more than 30 days old)
5. If no results found, say so clearly and suggest the user save the decision with `opc --agent codex remember`

## Error Handling

If `opc --agent codex recall` fails with a config error, run `$opscompanion-init` to set up the CLI first.
