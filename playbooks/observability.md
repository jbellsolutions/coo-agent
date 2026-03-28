# Observability Playbook

How the COO maintains visibility across all agents, systems, and operations. Traditional monitoring (is it up?) is necessary but not sufficient. The COO needs observability (why is it behaving this way?).

---

## Three Pillars

### 1. Metrics (What happened?)
Quantitative measurements tracked over time.

### 2. Logs (Why did it happen?)
Structured event records with context.

### 3. Traces (How did it happen?)
End-to-end path of a request or workflow through the system.

## Agent Fleet Dashboard

The COO maintains a mental model of fleet health using these views:

### Fleet Summary (check at every heartbeat)
```
AGENT FLEET STATUS — [timestamp]
━━━━━━━━━━━━━━━━━━━━━━━━━
Agent           Ver    Status   Last Run    Output  Errors  Circuit   Cost
Prospector      1.0.2  OK       06:01 AM    42      0       CLOSED    $1.20
Email SDR       1.2.0  OK       08:03 AM    148     2       CLOSED    $2.50
Phone SDR       1.1.0  OK       10:00 AM    35      1       CLOSED    $3.20
Text SDR        1.0.1  WARN     12:02 PM    89      5       HALF_OPN  $1.50
Seq Manager     1.3.0  OK       continuous  --      0       CLOSED    $0.80
━━━━━━━━━━━━━━━━━━━━━━━━━
Fleet Total: 4/5 healthy | Daily cost: $9.20 | Meetings: 2
```

### Per-Agent Deep View (on demand or when investigating)
```
AGENT DETAIL — Email SDR v1.2.0
━━━━━━━━━━━━━━━━━━━━━━━━━
Host: sdr-droplet-01 (DO NYC1)
Schedule: 8:00 AM, 10:00 AM Mon-Fri
Last 7 days:
  Runs: 14 | Successes: 13 | Failures: 1
  Avg output: 146 emails/run
  Avg cost: $2.40/run
  Error types: {Transient: 1, Environmental: 0, Data: 0}

Metrics trend (7-day):
  Open rate:  45% → 43% → 47% → 44% → 46% → 45% → 44%  (stable)
  Reply rate: 5.1% → 4.8% → 5.3% → 5.0% → 4.9% → 5.2% → 5.0%  (stable)
  Bounce:     1.2% → 1.1% → 1.3% → 1.0% → 1.2% → 1.1% → 1.2%  (OK)

Active A/B tests: 1
  "Problem-first subject line" vs "Question subject line"
  Status: 87/100 sends complete, not yet significant
```

## Structured Logging Format

Every agent action must produce a structured log entry:

```json
{
  "timestamp": "2026-03-28T10:03:22Z",
  "agent": "email-sdr",
  "version": "1.2.0",
  "action": "send_email",
  "status": "success",
  "duration_ms": 1250,
  "tokens_used": 450,
  "cost_usd": 0.018,
  "details": {
    "recipient": "john@acme.com",
    "campaign_id": "camp_456",
    "template": "problem-first-v2",
    "personalization_score": 0.85
  },
  "compliance": {
    "can_spam": true,
    "dkim_valid": true,
    "not_on_suppress": true
  },
  "trace_id": "tr_abc123def456"
}
```

## Workflow Traces

For multi-step workflows, a trace connects all related actions:

```
TRACE: tr_abc123def456 — Lead Processing Pipeline
━━━━━━━━━━━━━━━━━━━━━━━━━
[06:01:22] Prospector     → found lead "John Smith, Acme Corp"    (420ms)
[06:01:25] Prospector     → enriched: email, phone, LinkedIn      (1200ms)
[06:01:27] Prospector     → ICP score: 87/100 (Tier A)            (80ms)
[08:03:15] Email SDR      → sent personalized cold email           (1250ms)
[08:03:16] Email SDR      → logged to sequences/today.json         (45ms)
[10:00:30] Phone SDR      → called +1-555-0123, no answer          (35000ms)
[10:00:31] Phone SDR      → scheduled callback for tomorrow        (120ms)
[12:02:00] Text SDR       → sent SMS follow-up                     (800ms)
━━━━━━━━━━━━━━━━━━━━━━━━━
Total pipeline time: 6h 0m 38s | Cost: $0.42 | Status: in-sequence
```

## Quality Scoring

Beyond uptime, the COO evaluates agent OUTPUT QUALITY:

| Agent | Quality Metric | How Measured | Target |
|-------|---------------|-------------|--------|
| Prospector | ICP match accuracy | % of leads that qualify after manual review | >80% |
| Email SDR | Personalization score | AI evaluation of email specificity (1-10) | >7/10 |
| Phone SDR | Call quality | Connect rate × meeting conversion rate | >2% overall |
| Text SDR | Response relevance | % of responses that are positive or neutral | >15% |
| Seq Manager | Sequence completion | % of leads that complete the full sequence | >70% |
| COO | Report action rate | % of report items Justin acts on | >50% |

### Quality Review Process
1. **Daily:** Spot-check 5 random outputs from each agent (automated sampling)
2. **Weekly:** Review quality scores in weekly report, identify declining agents
3. **Monthly:** Deep quality audit — manually review 20 outputs per agent

## Alerting Rules

### Alert Channels
| Severity | Channel | Method |
|----------|---------|--------|
| Critical | #alerts + DM Justin + Telegram | Immediate push |
| Warning | #alerts | Slack message |
| Info | Daily report | Included in 5 PM summary |

### Alert Fatigue Prevention
1. **Dedup:** Same alert within 15 minutes → suppress (log only)
2. **Batch:** Non-critical alerts → batch into next heartbeat
3. **Escalate:** If alert count >5 in 1 hour → single summary alert instead of individual ones
4. **Auto-resolve:** If condition clears before next check → log recovery, no alert
5. **Weekly noise audit:** Review which alerts were actionable vs noise, tune thresholds

## Health Check Script

The COO runs this checklist at every heartbeat:

```
SYSTEM HEALTH CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━
Infrastructure:
  [ ] Mac Mini responsive (Tailscale ping)
  [ ] DO droplets responsive (SSH test)
  [ ] Disk space <80% on all systems
  [ ] No zombie processes

MCP Connections:
  [ ] ClickUp: connected
  [ ] Gmail: connected
  [ ] Calendar: connected
  [ ] Slack: connected
  [ ] GHL: connected
  [ ] Notion: connected
  [ ] Vercel: connected

Agent Fleet:
  [ ] All agents ran within expected schedule
  [ ] No circuit breakers in OPEN state
  [ ] No agents with consecutive_failures >= 2
  [ ] Daily cost within budget

Data Integrity:
  [ ] SDR JSON files present and recent
  [ ] CRM data accessible
  [ ] No quarantined data pending review

Compliance:
  [ ] Email bounce rate <3%
  [ ] No DNC violations
  [ ] All platform limits within bounds
```
