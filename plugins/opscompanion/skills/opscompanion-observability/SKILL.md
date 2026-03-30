---
name: opscompanion-observability
description: Search logs and traces, or run a live tail, when the user asks about current system behavior, incidents, errors, or recent runtime activity.
---

# OpsCompanion Observability

Use OpsCompanion observability commands for live or recent runtime investigation.

This skill is for:
- current or recent errors
- runtime behavior in a service
- log inspection during debugging
- live tailing while the user works
- trace search for request paths or span names

Do not use `opc search` for this. `opc search` is for stored knowledge and memory, not live telemetry.

## Action

Choose the command that matches the user's intent:

### Search logs

```bash
opc --agent codex logs "<query>"
```

### Live tail logs

```bash
opc --agent codex logs tail "<query>" --tui
```

### Search traces

```bash
opc --agent codex traces "<query>"
```

## Flags

### `opc logs`

| Flag | Default | Description |
|------|---------|-------------|
| `--service` | none | Filter by service name; repeatable |
| `--severity` | none | Filter by severity; repeatable |
| `--since` | `24h` | Time range: `1h`, `6h`, `12h`, `24h`, `3d`, `7d`, `14d` |
| `--mode` | `keyword` | Search mode: `keyword` or `regex` |
| `--case-sensitive` | off | Enable case-sensitive search |
| `--limit` | `50` | Maximum number of results |
| `--json` | off | Output full API response as JSON |
| `--ndjson` | off | Output one result object per line |

### `opc logs tail`

| Flag | Default | Description |
|------|---------|-------------|
| `--service` | none | Filter by service name; repeatable |
| `--severity` | none | Filter by severity; repeatable |
| `--mode` | `keyword` | Search mode: `keyword` or `regex` |
| `--case-sensitive` | off | Enable case-sensitive search |
| `--limit` | `20` | Maximum number of results per poll |
| `--tui` | off | Launch the interactive Bubble Tea tail UI |

`opc logs tail` does not accept `--since`.

### `opc traces`

| Flag | Default | Description |
|------|---------|-------------|
| `--service` | none | Filter by service name; repeatable |
| `--since` | `24h` | Time range: `1h`, `6h`, `12h`, `24h`, `3d`, `7d`, `14d` |
| `--mode` | `keyword` | Search mode: `keyword` or `regex` |
| `--case-sensitive` | off | Enable case-sensitive search |
| `--limit` | `50` | Maximum number of results |
| `--json` | off | Output full API response as JSON |
| `--ndjson` | off | Output one result object per line |

## Query Strategy

| User says | Command to use |
|-----------|----------------|
| "what errors are we seeing in api?" | `opc --agent codex logs --service api --severity ERROR` |
| "tail vercel-app while I test this" | `opc --agent codex logs tail --service vercel-app --tui` |
| "search for timeout logs in the last hour" | `opc --agent codex logs "timeout" --since 1h` |
| "find checkout traces" | `opc --agent codex traces "checkout"` |
| "regex for connection reset" | `opc --agent codex logs "connection reset|broken pipe" --mode regex` |

Prefer the narrowest useful service and severity filters before broad free-text queries.

## TUI Guidance

When the user wants to watch a service live, prefer:

```bash
opc --agent codex logs tail --service "<service>" --tui
```

The TUI supports:
- `j` / `k` or arrow keys to scroll
- `pgup` / `pgdn` for page movement
- `g` / `G` for top and bottom
- `f` to toggle follow mode
- `q` or `Ctrl-C` to quit

## How to Present Results

- For logs or traces search, summarize the most relevant findings instead of dumping every line.
- Call out recurring services, severities, trace IDs, or obvious failure patterns.
- If the user wants raw machine output, rerun with `--json` or `--ndjson`.
- If the issue appears to be historical team knowledge rather than live telemetry, switch to `$opscompanion-search`.

## Error Handling

If an observability command fails with a config error, run `$opscompanion-init` first.
