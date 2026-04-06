# Logging Examples

Use the examples below when the user wants copy-paste starter code.

## Next.js Logs

Set the API key in `.env.local`:

```bash
OPSCOMPANION_API_KEY=your_api_key_here
```

Create `src/instrumentation.ts`:

```ts
import { logs } from "@opentelemetry/api-logs"
import { OTLPLogExporter } from "@opentelemetry/exporter-logs-otlp-http"
import {
  BatchLogRecordProcessor,
  LoggerProvider,
} from "@opentelemetry/sdk-logs"
import { resourceFromAttributes } from "@opentelemetry/resources"

const loggerProvider = new LoggerProvider({
  resource: resourceFromAttributes({
    "service.name": "my-nextjs-app",
    "deployment.environment": process.env.VERCEL_ENV ?? "local",
  }),
  processors: [
    new BatchLogRecordProcessor(
      new OTLPLogExporter({
        url: "https://otel.opscompanion.ai/v1/logs",
        headers: {
          Authorization: `Bearer ${process.env.OPSCOMPANION_API_KEY}`,
          "Content-Type": "application/json",
        },
      }),
    ),
  ],
})

export function register() {
  if (process.env.NEXT_RUNTIME !== "nodejs") return
  logs.setGlobalLoggerProvider(loggerProvider)
}
```

Emit a server-side log:

```ts
import { logs, SeverityNumber } from "@opentelemetry/api-logs"

const logger = logs.getLogger("my-nextjs-app")

logger.emit({
  eventName: "checkout.completed",
  severityNumber: SeverityNumber.INFO,
  body: {
    orderId: "ord_123",
    amount: 4200,
  },
  attributes: {
    workspace: "production",
    route: "/api/checkout",
  },
})
```

## Next.js Traces

Set the API key in `.env.local`:

```bash
OPSCOMPANION_API_KEY=your_api_key_here
```

Send a trace from server-only code such as `app/api/checkout/route.ts`:

```ts
import { randomBytes } from "node:crypto"

function hex(bytes: number) {
  return randomBytes(bytes).toString("hex")
}

export async function POST() {
  const startTimeUnixNano = (BigInt(Date.now()) * 1000000n).toString()
  const endTimeUnixNano = (BigInt(Date.now() + 42) * 1000000n).toString()

  await fetch("https://otel.opscompanion.ai/v1/traces", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.OPSCOMPANION_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      resourceSpans: [
        {
          resource: {
            attributes: [
              {
                key: "service.name",
                value: { stringValue: "my-nextjs-app" },
              },
              {
                key: "deployment.environment",
                value: {
                  stringValue: process.env.VERCEL_ENV ?? "local",
                },
              },
            ],
          },
          scopeSpans: [
            {
              scope: { name: "checkout" },
              spans: [
                {
                  traceId: hex(16),
                  spanId: hex(8),
                  name: "POST /api/checkout",
                  kind: 2,
                  startTimeUnixNano,
                  endTimeUnixNano,
                  attributes: [
                    {
                      key: "http.method",
                      value: { stringValue: "POST" },
                    },
                    {
                      key: "http.route",
                      value: { stringValue: "/api/checkout" },
                    },
                  ],
                  status: { code: 1 },
                },
              ],
            },
          ],
        },
      ],
    }),
  })

  return Response.json({ ok: true })
}
```

## Node.js Traces

```ts
import { randomBytes } from "node:crypto"

const payload = {
  resourceSpans: [
    {
      resource: {
        attributes: [
          { key: "service.name", value: { stringValue: "my-node-api" } },
          {
            key: "deployment.environment",
            value: { stringValue: "production" },
          },
        ],
      },
      scopeSpans: [
        {
          scope: { name: "custom" },
          spans: [
            {
              traceId: randomBytes(16).toString("hex"),
              spanId: randomBytes(8).toString("hex"),
              name: "POST /checkout",
              kind: 2,
              startTimeUnixNano: (BigInt(Date.now()) * 1000000n).toString(),
              endTimeUnixNano: (BigInt(Date.now() + 87) * 1000000n).toString(),
              attributes: [
                { key: "http.method", value: { stringValue: "POST" } },
                { key: "http.route", value: { stringValue: "/checkout" } },
              ],
              status: { code: 1 },
            },
          ],
        },
      ],
    },
  ],
}

await fetch("https://otel.opscompanion.ai/v1/traces", {
  method: "POST",
  headers: {
    Authorization: `Bearer ${process.env.OPSCOMPANION_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify(payload),
})
```

## Python Traces

```py
import os
import time
import secrets
import requests

start_ns = time.time_ns()
end_ns = start_ns + 52_000_000

payload = {
    "resourceSpans": [
        {
            "resource": {
                "attributes": [
                    {"key": "service.name", "value": {"stringValue": "my-python-api"}},
                    {"key": "deployment.environment", "value": {"stringValue": "production"}},
                ]
            },
            "scopeSpans": [
                {
                    "scope": {"name": "custom"},
                    "spans": [
                        {
                            "traceId": secrets.token_hex(16),
                            "spanId": secrets.token_hex(8),
                            "name": "POST /checkout",
                            "kind": 2,
                            "startTimeUnixNano": str(start_ns),
                            "endTimeUnixNano": str(end_ns),
                            "attributes": [
                                {"key": "http.method", "value": {"stringValue": "POST"}},
                                {"key": "http.route", "value": {"stringValue": "/checkout"}},
                            ],
                            "status": {"code": 1},
                        }
                    ],
                }
            ],
        }
    ]
}

response = requests.post(
    "https://otel.opscompanion.ai/v1/traces",
    headers={
        "Authorization": f"Bearer {os.environ['OPSCOMPANION_API_KEY']}",
        "Content-Type": "application/json",
    },
    json=payload,
    timeout=10,
)

response.raise_for_status()
print(response.json())
```

## cURL Traces

```bash
curl -X POST https://otel.opscompanion.ai/v1/traces \
  -H "Authorization: Bearer $OPSCOMPANION_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resourceSpans": [
      {
        "resource": {
          "attributes": [
            { "key": "service.name", "value": { "stringValue": "curl-example" } },
            { "key": "deployment.environment", "value": { "stringValue": "local" } }
          ]
        },
        "scopeSpans": [
          {
            "scope": { "name": "manual" },
            "spans": [
              {
                "traceId": "0123456789abcdef0123456789abcdef",
                "spanId": "0123456789abcdef",
                "name": "GET /health",
                "kind": 2,
                "startTimeUnixNano": "1735689600000000000",
                "endTimeUnixNano": "1735689600100000000",
                "status": { "code": 1 }
              }
            ]
          }
        ]
      }
    ]
  }'
```

## Node.js Logs

```ts
const payload = {
  resourceLogs: [
    {
      resource: {
        attributes: [
          { key: "service.name", value: { stringValue: "my-node-api" } },
          {
            key: "deployment.environment",
            value: { stringValue: "production" },
          },
        ],
      },
      scopeLogs: [
        {
          scope: { name: "custom" },
          logRecords: [
            {
              timeUnixNano: Date.now().toString() + "000000",
              severityNumber: 9,
              severityText: "INFO",
              body: { stringValue: "Checkout completed" },
              attributes: [
                { key: "workspace", value: { stringValue: "production" } },
                { key: "order.id", value: { stringValue: "ord_123" } },
              ],
            },
          ],
        },
      ],
    },
  ],
}

await fetch("https://otel.opscompanion.ai/v1/logs", {
  method: "POST",
  headers: {
    Authorization: `Bearer ${process.env.OPSCOMPANION_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify(payload),
})
```

## Python Logs

```py
import os
import time
import requests

payload = {
    "resourceLogs": [
        {
            "resource": {
                "attributes": [
                    {"key": "service.name", "value": {"stringValue": "my-python-api"}},
                    {"key": "deployment.environment", "value": {"stringValue": "production"}},
                ]
            },
            "scopeLogs": [
                {
                    "scope": {"name": "custom"},
                    "logRecords": [
                        {
                            "timeUnixNano": str(int(time.time() * 1_000_000_000)),
                            "severityNumber": 17,
                            "severityText": "ERROR",
                            "body": {"stringValue": "Database timeout"},
                            "attributes": [
                                {"key": "workspace", "value": {"stringValue": "production"}},
                                {"key": "db.system", "value": {"stringValue": "postgres"}},
                            ],
                        }
                    ],
                }
            ],
        }
    ]
}

response = requests.post(
    "https://otel.opscompanion.ai/v1/logs",
    headers={
        "Authorization": f"Bearer {os.environ['OPSCOMPANION_API_KEY']}",
        "Content-Type": "application/json",
    },
    json=payload,
    timeout=10,
)

response.raise_for_status()
print(response.json())
```

## cURL Logs

```bash
curl -X POST https://otel.opscompanion.ai/v1/logs \
  -H "Authorization: Bearer $OPSCOMPANION_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "resourceLogs": [
      {
        "resource": {
          "attributes": [
            { "key": "service.name", "value": { "stringValue": "curl-example" } },
            { "key": "deployment.environment", "value": { "stringValue": "local" } }
          ]
        },
        "scopeLogs": [
          {
            "scope": { "name": "manual" },
            "logRecords": [
              {
                "timeUnixNano": "1735689600000000000",
                "severityNumber": 9,
                "severityText": "INFO",
                "body": { "stringValue": "Manual OTLP log test" },
                "attributes": [
                  { "key": "workspace", "value": { "stringValue": "docs-example" } }
                ]
              }
            ]
          }
        ]
      }
    ]
  }'
```
