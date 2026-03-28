# Incident Response Runbook

How the COO handles failures, outages, and unexpected events. Every incident follows this lifecycle.

---

## Incident Severity Levels

| Level | Description | Response Time | Escalation |
|-------|-------------|---------------|------------|
| **SEV-1 Critical** | Revenue-impacting: CRM down, email domain blacklisted, all agents offline | <5 minutes | Immediate DM to Justin + Slack #alerts |
| **SEV-2 High** | Degraded operations: 1+ agents down, API failures, data loss risk | <15 minutes | Slack #alerts, Telegram push |
| **SEV-3 Medium** | Reduced efficiency: slow responses, partial data, one channel down | <1 hour | Slack #coo, fix autonomously |
| **SEV-4 Low** | Cosmetic/minor: formatting issues, non-critical warnings | Next heartbeat | Log and fix in batch |

## Incident Lifecycle

```
DETECT → CLASSIFY → CONTAIN → INVESTIGATE → RESOLVE → POSTMORTEM → PREVENT
```

### 1. Detect
Sources of incident detection:
- Circuit breaker state change (CLOSED → OPEN)
- Heartbeat health check failure
- Agent health file shows consecutive_failures >= 2
- Slack alert from sub-agent
- Justin reports an issue
- Cost spike detected (>150% of daily average)
- External monitoring (Smartlead bounce rate, domain reputation)

### 2. Classify
Assign severity using the table above. When in doubt, classify UP (treat SEV-3 as SEV-2).

### 3. Contain
Stop the bleeding before investigating:
- **Agent failure:** Pause the failing agent's cron schedule
- **API failure:** Open circuit breaker, switch to fallback
- **Data issue:** Quarantine affected records, pause pipelines consuming that data
- **Cost spike:** Pause non-critical agents, alert Justin
- **Email deliverability:** Pause all email sends immediately

### 4. Investigate
Follow the systematic debugging protocol (CLAUDE.md Rule 13):
1. Reproduce — can you trigger the error on demand?
2. Compare — what changed since it last worked?
3. Hypothesize — single hypothesis, smallest test
4. Verify — confirm root cause before fixing

### 5. Resolve
Apply the fix. Verify the fix with the anti-hallucination protocol (Rule 12).

### 6. Postmortem
After every SEV-1 or SEV-2 incident, write:
```
INCIDENT POSTMORTEM — [Date]
━━━━━━━━━━━━━━━━━━━━━━━━━
Severity: SEV-[X]
Duration: [start time] → [resolved time] = [total minutes]
Impact: [what was affected, what was lost]
Root Cause: [what actually broke and why]
Detection: [how it was found — auto vs manual]
Timeline:
  [HH:MM] — [event]
  [HH:MM] — [event]
  [HH:MM] — [event]
What Went Well: [what worked in the response]
What Went Wrong: [what delayed resolution]
Action Items:
  - [ ] [Prevention measure] — Owner: [who] — Due: [when]
  - [ ] [Monitoring improvement] — Owner: [who] — Due: [when]
```

### 7. Prevent
- Add the failure pattern to `improvements/patterns-losing.md`
- Update monitoring to catch this class of error earlier
- Add a preflight check if applicable
- Schedule a drill to verify the fix works under similar conditions

---

## Top 10 Critical Failure Scenarios

### 1. All SDR Agents Down
**Detect:** Health check shows all 5 agents with last_run >2 hours stale
**Contain:** Log the outage start time
**Investigate:** SSH into DO droplet → check system resources, cron status, error logs
**Resolve:** Restart agents, verify output, confirm cron schedules
**Escalate if:** Droplet itself is unreachable → SEV-1, contact DO support

### 2. Email Domain Blacklisted
**Detect:** Smartlead bounce rate >10% OR delivery rate drops below 80%
**Contain:** PAUSE ALL EMAIL SENDS immediately
**Investigate:** Check blacklist services (MXToolBox), review recent email content, check SPF/DKIM/DMARC
**Resolve:** Submit delisting requests, switch to backup domain, review email hygiene
**Escalate:** Always SEV-1 — revenue impact is immediate

### 3. GoHighLevel CRM Unreachable
**Detect:** MCP connection fails 3 times → circuit breaker opens
**Contain:** Cache last known pipeline state, continue operations with cached data
**Investigate:** Check GHL status page, verify API key validity, test manual API call
**Resolve:** Wait for GHL recovery OR rotate API key if expired

### 4. Cost Spike (>200% Daily Average)
**Detect:** Cost tracking shows anomalous spend
**Contain:** Pause non-critical agents, identify the expensive operation
**Investigate:** Check token usage per agent, look for infinite loops or retry storms
**Resolve:** Fix the runaway process, implement cost cap
**Escalate:** SEV-2, DM Justin with spend amount and cause

### 5. Hot Lead Notification Failure
**Detect:** Hot lead detected but Slack/Telegram notification fails
**Contain:** Retry via alternate channel (if Slack fails, try Telegram and vice versa)
**Investigate:** Check Slack/Telegram API status, verify bot tokens
**Resolve:** Fix the failing channel, send delayed notification with apology
**Escalate:** Always SEV-2 — missed revenue opportunity

### 6. Data Loss on DO Droplet
**Detect:** Expected JSON files missing or corrupted
**Contain:** Stop all write operations to affected directories
**Investigate:** Check disk space, recent deployments, file permissions
**Resolve:** Restore from backup (if available) or regenerate from source data
**Escalate:** SEV-1 if pipeline data is unrecoverable

### 7. Mac Mini Goes Offline
**Detect:** Telegram bot stops responding, Paperclip dashboard unreachable
**Contain:** Nothing can be done remotely if Mac is truly offline
**Investigate:** Check if Tailscale shows the device, try remote wake
**Resolve:** Physical access required — restart Mac, check power/network
**Escalate:** Always SEV-1 — all COO functions are offline

### 8. LinkedIn Account Restricted
**Detect:** Computer Use fails on LinkedIn, restriction notice visible
**Contain:** Stop ALL LinkedIn automation immediately
**Investigate:** Review recent activity volume, check LinkedIn's stated reason
**Resolve:** Wait out restriction period, reduce automation volume
**Prevent:** Enforce stricter daily limits (see compliance playbook)

### 9. Smartlead Campaign Stuck
**Detect:** Email send count drops to 0 for >4 hours during active campaign
**Contain:** Check if intentional pause, log the stuck state
**Investigate:** Via Computer Use — check campaign status, any error messages
**Resolve:** Restart campaign or fix the blocking issue
**Escalate:** SEV-3 unless it's been >24 hours

### 10. Memory/Disk Full on Any System
**Detect:** Commands fail with "no space left on device" or similar
**Contain:** Identify the system, stop writes
**Investigate:** Find the space consumer (logs, temp files, old data)
**Resolve:** Clean up, implement retention policies
**Prevent:** Add disk space monitoring to preflight checks

---

## Disaster Recovery

### Backup Strategy
| What | Where | Frequency | Retention |
|------|-------|-----------|-----------|
| COO configs (CLAUDE.md, SOUL.md, heartbeats) | GitHub repo | On change (git push) | Forever |
| SDR agent configs | GitHub repo | On change | Forever |
| Pipeline data (leads, metrics) | DO automated backups | Daily | 7 days |
| CRM data | GHL built-in backups | Auto | Per GHL plan |
| Email campaign data | Smartlead cloud | Auto | Per plan |
| Improvement logs | GitHub repo | Weekly push | Forever |

### Recovery Priority Order
If everything goes down simultaneously, restore in this order:
1. Mac Mini (COO brain — everything depends on this)
2. MCP connections (Gmail, ClickUp, Slack — communication first)
3. DO droplets (SDR agents — revenue generation)
4. Paperclip + ClaudeClaw (access layer — nice to have)

### Quarterly Drills
Schedule: First Monday of each quarter
- [ ] Q1: Simulate SDR agent fleet failure and recovery
- [ ] Q2: Simulate Mac Mini offline scenario
- [ ] Q3: Simulate email domain blacklist response
- [ ] Q4: Full disaster recovery drill (all systems)

Each drill produces a report: what worked, what was slow, what needs improvement.
