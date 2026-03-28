# Sub-Agent Architecture

The COO manages a fleet of specialized sub-agents. Each agent has a single responsibility, runs autonomously, and reports to the COO.

---

## Architecture Overview

```
                    ┌─────────────┐
                    │   JUSTIN    │
                    │    (CEO)    │
                    └──────┬──────┘
                           │ Strategy, decisions, relationships
                           │
                    ┌──────┴──────┐
                    │     AG      │
                    │    (COO)    │
                    │  Claude Code │
                    │  Mac Mini   │
                    └──────┬──────┘
                           │ Orchestrates, monitors, reports
              ┌────────────┼────────────┐
              │            │            │
     ┌────────┴──────┐ ┌──┴───────┐ ┌──┴───────────┐
     │  SDR FLEET    │ │ CONTENT  │ │  ON-DEMAND    │
     │ (DigitalOcean)│ │  AGENTS  │ │   AGENTS      │
     │  Always-on    │ │ On-demand│ │  As-needed    │
     └───────┬───────┘ └──┬───────┘ └──┬────────────┘
             │            │            │
    ┌────────┼────┐       │       ┌────┼──────┐
    │   │    │    │       │       │    │      │
   Pro Eml Phn Txt Seq   Titans  Res  Comp   GTM
```

## Agent Fleet

### Tier 1: Always-On (DigitalOcean)

| Agent | Role | Schedule | Key Metrics |
|-------|------|----------|-------------|
| **Prospector** | Find and research leads matching ICP | 6:00 AM daily | Leads found, ICP match rate |
| **Email SDR** | Send personalized cold emails | 8:00 AM, 10:00 AM daily | Emails sent, open rate, reply rate |
| **Phone SDR** | Make cold calls via Retell AI | 10:00 AM daily | Calls made, connect rate, meetings |
| **Text SDR** | Send SMS/iMessage outreach | 12:00 PM daily | Messages sent, response rate |
| **Sequence Manager** | Orchestrate multi-day sequences | Continuous | Active sequences, completion rate |

### Tier 2: On-Demand (Invoked by COO)

| Agent | Role | Trigger | Key Metrics |
|-------|------|---------|-------------|
| **Titans Council** | 18-copywriter content/positioning analysis | Per client project | Deliverable quality, client satisfaction |
| **Content Multiplier** | Generate 32+ content pieces from positioning | Post-Titans | Content pieces produced, time to complete |
| **Cold Email Writer** | 16-agent hyper-personalized email generation | Per campaign | Emails written, QA pass rate |

### Tier 3: Proposed (To Build)

| Agent | Role | Priority | Estimated Impact |
|-------|------|----------|-----------------|
| **Research Agent** | Deep web research on prospects, competitors, markets | High | Better personalization → higher reply rates |
| **GTM Analyst** | Track funnel metrics, forecast revenue, optimize channels | High | Data-driven GTM decisions |
| **Compliance Monitor** | Check CAN-SPAM, TCPA, LinkedIn limits | Medium | Prevent account bans, legal risk |
| **Report Generator** | Auto-generate client reports and case studies | Medium | Time savings on deliverables |
| **Onboarding Agent** | New client intake, data collection, system setup | Low | Faster client activation |

## Agent Communication Protocol

### Agent → COO
- **Success:** Write output to designated JSON file + Slack #sdr notification
- **Failure:** Write error log + Slack #alerts notification
- **Hot Lead:** Immediate Slack DM to COO + Telegram push

### COO → Agent
- **Start:** SSH command to trigger agent run
- **Stop:** SSH command to halt agent process
- **Config Change:** Update agent config file via SSH, restart

### COO → Justin
- **Hot Lead:** Slack DM + Telegram with lead details and recommended action
- **Agent Down:** Slack #alerts with impact assessment and recovery ETA
- **Decision Needed:** Slack DM with context, options, and recommendation

## Health Monitoring

Every agent must maintain a health file at `~/agent-health.json`:
```json
{
  "agent_name": "email-sdr",
  "status": "healthy",
  "last_run": "2026-03-28T08:00:00Z",
  "last_success": "2026-03-28T08:00:00Z",
  "consecutive_failures": 0,
  "output_count_today": 150,
  "error_count_today": 2,
  "circuit_breaker": "CLOSED",
  "version": "1.2.0"
}
```

COO checks all health files at 9 AM and 1 PM. Alerts if:
- `last_run` is > 2 hours past scheduled time
- `consecutive_failures` >= 2
- `circuit_breaker` is OPEN
- `status` is anything other than "healthy"

## Scaling Guidelines

- **Add agent when:** Single agent is at >80% capacity OR a new channel needs coverage
- **Remove agent when:** Channel ROI drops below 1:1 for 2 consecutive weeks
- **Split agent when:** One agent handles 2+ distinct responsibilities
- **Merge agents when:** Two agents share 80%+ of their toolchain and run sequentially
