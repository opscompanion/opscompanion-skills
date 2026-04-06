---
name: logging
description: Set up OpenTelemetry logs and traces for OpsCompanion when the user asks about logging, tracing, OTLP, instrumentation.ts, Supabase log drains, or sending telemetry from Next.js, Node.js, Python, or cURL.
---

# Logging

Use this skill when the user wants to instrument an app so logs or traces are sent to OpsCompanion.

This skill is for:
- setting up OpenTelemetry logs
- setting up OpenTelemetry traces
- wiring `instrumentation.ts` in Next.js
- sending OTLP/HTTP JSON payloads to OpsCompanion
- configuring Supabase log drains
- explaining which endpoint, headers, env vars, and attributes to use

## Before You Start

Tell the user to create an OpsCompanion API key in the dashboard:

1. Open OpsCompanion.
2. Click the profile photo in the top-right.
3. Click `Manage Account`.
4. Open the `API Keys` tab.
5. Choose `Organization API Keys`.
6. Create a key and select the scopes they need.

Store the key as:

```bash
OPSCOMPANION_API_KEY=your_api_key_here
```

## Endpoints

| Signal | Endpoint |
|--------|----------|
| Logs | `https://otel.opscompanion.ai/v1/logs` |
| Traces | `https://otel.opscompanion.ai/v1/traces` |

Always send:
- `Authorization: Bearer $OPSCOMPANION_API_KEY`
- `Content-Type: application/json`

## Guidance

- Prefer OpenTelemetry naming such as `service.name`, `deployment.environment`, `http.method`, and `http.route`.
- Include a stable service name and environment on every payload.
- For logs, include useful attributes like workspace, route, order ID, database system, or request metadata.
- For traces, use valid hex `traceId` and `spanId` values and send `startTimeUnixNano` plus `endTimeUnixNano`.
- In Next.js, keep server-side instrumentation in `src/instrumentation.ts` and guard it with `process.env.NEXT_RUNTIME === "nodejs"`.
- If the user is on Supabase, recommend a log drain for platform logs and OTLP instrumentation for app-specific logs and traces.

## Next.js

For Next.js logs, create a server-only `src/instrumentation.ts` that registers an OpenTelemetry logger provider and OTLP HTTP exporter. Follow the official Next.js instrumentation pattern and only register on the Node.js runtime.

For Next.js traces, send OTLP JSON from server-only code such as route handlers or server actions.

## Supabase

For Supabase platform logs, use Supabase Log Drains with:
- Endpoint: `https://otel.opscompanion.ai/v1/logs`
- Authorization header: `Bearer <your OpsCompanion API key>`

This covers Postgres, Auth, Storage, Realtime, and Edge Functions.

## Success Responses

Logs requests return:

```json
{
  "partialSuccess": {
    "rejectedLogRecords": 0,
    "errorMessage": ""
  }
}
```

Traces requests return:

```json
{
  "partialSuccess": {
    "rejectedSpans": 0,
    "errorMessage": ""
  }
}
```

## Examples

Read [references/examples.md](references/examples.md) when the user needs ready-to-paste examples for:
- Next.js logs
- Next.js traces
- Node.js logs
- Node.js traces
- Python logs
- Python traces
- cURL logs
- cURL traces

## How To Help

- If the user names a framework, give the most direct example for that stack first.
- If they want implementation help, edit the project and wire the environment variable plus server-side instrumentation.
- If they want a quick connectivity test, prefer the cURL example.
- If they only need platform logs from Supabase, recommend the log drain path instead of app code changes.
