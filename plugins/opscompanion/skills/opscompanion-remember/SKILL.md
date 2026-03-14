---
name: opscompanion-remember
description: Store new decisions, discoveries, or knowledge for future recall. Use when the user asks to remember something or when significant decisions emerge during a conversation.
user_invocable: true
tools:
  - name: Bash
    allowed_commands:
      - opc
---

# OpsCompanion Remember

You are saving a decision, discovery, or piece of context to the team's shared knowledge base so it can be recalled in future sessions — by this user or any teammate.

## Action

Run:
```bash
opc remember "<content>" --tags "<tag1>,<tag2>,<tag3>"
```

### Crafting Good Memories

**Content** should be:
- Self-contained — readable without surrounding context
- Specific — include the "what" and the "why"
- Actionable — someone finding this later should know what to do

| Bad | Good |
|-----|------|
| "use Redis" | "Use Redis for rate limiter shared state — in-memory counters don't work across multiple gateway pods" |
| "PASETO is better" | "Migrating auth-service from JWT to PASETO v4. PASETO chosen for mandatory encryption and no algorithm confusion attacks" |

**Tags** should include:
- The service name (e.g., `api-gateway`, `auth-service`)
- The topic area (e.g., `rate-limiting`, `security`, `architecture`)
- The type of knowledge (e.g., `debugging`, `migration`, `config`)

## When to Proactively Remember

Save a memory when you observe:
- A significant architectural decision being made
- A non-obvious discovery during debugging
- A decision with context that would be lost after the session
- Something the user explicitly says "remember this" or "we should document this"

Always confirm with the user before proactively saving.

## Response Format

After saving:
- Confirm what was saved (paraphrase, don't repeat verbatim)
- Show the tags assigned
- Mention that teammates can find this with `opc recall`

## Error Handling

If `opc remember` fails with a config error, invoke the `opscompanion-init` skill to set up the CLI first.
