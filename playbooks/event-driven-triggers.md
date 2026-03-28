# Event-Driven Triggers

Beyond scheduled heartbeats, the COO reacts to events in real time. This document defines what events trigger what actions.

---

## Architecture

```
EVENT SOURCE → WEBHOOK/MCP POLL → EVENT ROUTER → AGENT ACTION → LOG
```

The COO combines two trigger patterns:
1. **Time-based (heartbeats):** Morning briefing, SDR checks, daily report, weekly/monthly reviews
2. **Event-based (reactive):** Respond to signals as they happen

## Event Catalog

### Email Events (Gmail MCP)
| Event | Detection | Action | Priority |
|-------|-----------|--------|----------|
| Urgent email received | Gmail MCP poll (every 15 min) for `is:important is:unread` | Summarize and push to Telegram | High |
| Positive reply to outreach | Smartlead webhook or Gmail search for reply threads | Flag as hot lead → DM Justin | Critical |
| Bounce spike (>5% in 1 hour) | Smartlead monitoring | Pause email sends, alert #alerts | Critical |
| Unsubscribe spike (>3% in 1 day) | Smartlead/Kit monitoring | Pause campaign, investigate | High |

### CRM Events (GoHighLevel MCP)
| Event | Detection | Action | Priority |
|-------|-----------|--------|----------|
| Lead moves to "hot" stage | GHL pipeline webhook or MCP poll | DM Justin with lead details + next steps | Critical |
| Deal closed | GHL pipeline change | Update revenue forecast, celebrate in #coo | High |
| Lead stale >7 days in same stage | Daily pipeline scan | Auto-create follow-up task in ClickUp | Medium |
| New contact added (not by SDR) | GHL contact creation event | Enrich and score, route to appropriate sequence | Medium |

### Agent Events (SSH/Health Files)
| Event | Detection | Action | Priority |
|-------|-----------|--------|----------|
| Agent fails to run on schedule | Health file check (9 AM, 1 PM) | Attempt restart, alert if still down | High |
| Agent output count = 0 | Health file shows no output | Investigate logs, attempt restart | High |
| Circuit breaker opens | State change in circuit-breaker tracking | Log, alert #alerts, start cooldown | High |
| Agent exceeds cost budget | Per-agent cost tracking | Pause agent, alert with cost breakdown | Medium |

### Infrastructure Events (SSH/Tailscale)
| Event | Detection | Action | Priority |
|-------|-----------|--------|----------|
| DO droplet unreachable | SSH fails + Tailscale offline | Alert #alerts, attempt DO API restart | Critical |
| Disk >80% full | SSH `df` check during heartbeats | Auto-cleanup old logs, alert if still high | Medium |
| Mac Mini offline | ClaudeClaw heartbeat fails | (Cannot self-recover — Justin notified via backup channel) | Critical |

### Code Events (GitHub)
| Event | Detection | Action | Priority |
|-------|-----------|--------|----------|
| PR merged to main | GitHub webhook or MCP poll | Verify deployment, run smoke test | Medium |
| New issue opened | GitHub MCP poll | Triage, assign priority, create ClickUp task | Low |
| CI/CD failure | GitHub Actions status | Alert #alerts with failure details | Medium |

### Financial Events
| Event | Detection | Action | Priority |
|-------|-----------|--------|----------|
| Daily spend >150% of average | Cost tracking comparison | Alert Justin with breakdown | High |
| Weekly spend >budget | Weekly review calculation | Recommend cost cuts, pause low-ROI agents | High |
| New subscription charge | Gmail receipt detection | Log to cost tracker, verify expected | Low |

### Calendar Events (Google Calendar MCP)
| Event | Detection | Action | Priority |
|-------|-----------|--------|----------|
| Meeting in <30 minutes | Calendar check during morning briefing | Push prep notes to Justin | Medium |
| Meeting added by external | Calendar MCP event detection | Research attendee, add context to event notes | Low |
| Double-booking detected | Calendar scan | Alert Justin, suggest rescheduling | Medium |

## Event Polling Schedule

For events without native webhooks, the COO polls at these intervals:

| Source | Poll Interval | Method |
|--------|--------------|--------|
| Gmail (urgent) | Every 15 minutes | MCP |
| GoHighLevel pipeline | Every 30 minutes | MCP |
| Agent health files | 9 AM, 1 PM (heartbeat) | SSH |
| GitHub activity | Every 1 hour | MCP/CLI |
| Cost tracking | Daily (5 PM report) | Aggregation |
| Calendar changes | Every 30 minutes | MCP |

## Webhook Integration (When Available)

For services that support webhooks, configure them to hit a listener:

```
Webhook URL: https://[mac-mini-tailscale-ip]:8080/hooks/[service]
Auth: HMAC-SHA256 signature verification
Payload: JSON with event type, timestamp, and relevant data
```

### Security Requirements for Webhooks
1. **HMAC verification** — every incoming webhook must be signature-verified
2. **Rate limiting** — max 100 events/minute per source
3. **Payload validation** — reject malformed payloads, log suspicious activity
4. **IP allowlisting** — when the source service provides known IPs
5. **Idempotency** — handle duplicate webhook deliveries gracefully

## Event Priority Matrix

When multiple events fire simultaneously, process in this order:
1. **Critical** — revenue impact, data loss, security (process immediately)
2. **High** — degraded operations, hot leads (process within 15 min)
3. **Medium** — efficiency impact, maintenance (process at next heartbeat)
4. **Low** — informational, cosmetic (process in daily report)
