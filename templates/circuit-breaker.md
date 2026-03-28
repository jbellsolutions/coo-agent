# Circuit Breaker Template

Use this template when integrating any external service, API, or agent into the COO system.

---

## States

```
CLOSED (Normal)     →  OPEN (Failing)      →  HALF_OPEN (Testing)
  ↑                      │                       │
  │                      │ after cooldown        │
  │                      └───────────────────────┘
  │                                               │
  └───────── if test succeeds ────────────────────┘
```

## Configuration Per Service

```
SERVICE NAME:          ___________________________________
FAILURE THRESHOLD:     3 consecutive failures (default)
COOLDOWN PERIOD:       5 minutes (default)
HALF_OPEN TEST COUNT:  1 call (default)
ALERT CHANNEL:         #alerts (Slack)
ESCALATION:            DM Justin after 3 circuit opens in 24h

Current State:         [ ] CLOSED  [ ] OPEN  [ ] HALF_OPEN
Last State Change:     ___________________________________
Consecutive Failures:  ___________________________________
```

## Transition Rules

### CLOSED → OPEN
Trigger: `consecutive_failures >= FAILURE_THRESHOLD`
Actions:
1. Stop calling the service
2. Log: `{timestamp, service, state: "OPEN", last_error}`
3. Send ONE alert to #alerts: `CIRCUIT OPEN — [Service] — [error summary]`
4. Start cooldown timer

### OPEN → HALF_OPEN
Trigger: `cooldown_period elapsed`
Actions:
1. Allow exactly ONE test call
2. Log: `{timestamp, service, state: "HALF_OPEN"}`

### HALF_OPEN → CLOSED
Trigger: `test call succeeds`
Actions:
1. Reset consecutive_failures to 0
2. Resume normal operations
3. Log: `{timestamp, service, state: "CLOSED", recovery_time}`
4. Send recovery notice to #alerts: `CIRCUIT CLOSED — [Service] recovered`

### HALF_OPEN → OPEN
Trigger: `test call fails`
Actions:
1. Return to OPEN state
2. Restart cooldown timer (with exponential backoff: 5m → 10m → 20m, max 1h)
3. Log: `{timestamp, service, state: "OPEN", backoff_period}`
4. Alert only if backoff increased

## Alert Rules
- ONE alert per state change. Never spam.
- Recovery alerts are green/positive — "Service X back online"
- If circuit opens 3+ times in 24 hours: escalate to DM Justin
- Weekly review includes circuit breaker event summary

## Active Circuit Breakers

Track all active circuits here:

| Service | State | Last Change | Failures | Cooldown |
|---------|-------|-------------|----------|----------|
| Smartlead API | CLOSED | - | 0 | 5m |
| GoHighLevel API | CLOSED | - | 0 | 5m |
| DigitalOcean SSH | CLOSED | - | 0 | 5m |
| Kit API | CLOSED | - | 0 | 5m |
| Gmail MCP | CLOSED | - | 0 | 5m |
| Slack MCP | CLOSED | - | 0 | 5m |
| ClickUp MCP | CLOSED | - | 0 | 5m |
| Vercel MCP | CLOSED | - | 0 | 5m |
| Composio MCP | CLOSED | - | 0 | 5m |
