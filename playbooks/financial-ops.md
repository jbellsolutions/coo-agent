# Financial Operations Playbook

The COO tracks every dollar in and out. This playbook defines how money is monitored, reported, and optimized.

---

## Budget Architecture

```
MONTHLY BUDGET → CATEGORY ALLOCATION → DAILY TRACKING → VARIANCE ALERTS → OPTIMIZATION
```

## Cost Categories

| Category | Components | Budget Range | Tracking Method |
|----------|-----------|--------------|-----------------|
| **Compute** | DO droplets, Mac Mini electricity | $40-50/mo | DO billing API + estimated |
| **LLM Tokens** | Claude API (COO + agents), OpenAI (if any) | $50-200/mo | API usage dashboards |
| **Outreach Tools** | Smartlead, Retell AI, Twilio/Sendblue | $150-300/mo | Subscription + usage APIs |
| **SaaS Stack** | ClickUp, GHL, Kit, Tailscale, etc. | $100-200/mo | Subscription tracking |
| **One-time** | Domain purchases, one-off tools | Variable | Per-event logging |

## Daily Cost Tracking

The COO logs daily costs in this format:

```json
{
  "date": "2026-03-28",
  "compute": {
    "digitalocean": 1.23,
    "mac_mini_electricity": 0.17
  },
  "llm_tokens": {
    "claude_coo": 2.50,
    "claude_sdr_agents": 1.80,
    "total_tokens_used": 45000
  },
  "outreach": {
    "smartlead": 0.00,
    "retell_ai_calls": 3.20,
    "twilio_sms": 1.50
  },
  "total_daily": 10.40,
  "7day_average": 11.20,
  "variance": "-7.1%",
  "meetings_booked": 2,
  "cost_per_meeting": 5.20
}
```

## Variance Alerts

| Condition | Alert Level | Action |
|-----------|------------|--------|
| Daily spend >150% of 7-day avg | Warning | Investigate, include in daily report |
| Daily spend >200% of 7-day avg | Critical | Pause non-critical agents, DM Justin |
| Weekly spend >budget allocation | High | Recommend cuts, identify low-ROI spending |
| Monthly on track to exceed budget by >20% | High | Forecast report, propose reallocation |
| Cost per meeting >2x target | Warning | Analyze channel efficiency, propose changes |
| Any single API call >$5 | Warning | Investigate, possible infinite loop or large batch |

## Key Financial Metrics

### Primary (Report Daily)
- **Total daily operational cost**
- **Cost per meeting booked** (north star efficiency metric)
- **ROAI** (Revenue from automation / AI inference costs)

### Secondary (Report Weekly)
- **Cost per channel** (email, phone, SMS, LinkedIn)
- **Cost per agent** (which agents are most/least cost-effective)
- **Token efficiency** (output quality per token spent)
- **Cost trend** (7-day, 30-day moving averages)

### Strategic (Report Monthly)
- **CAC** (Customer Acquisition Cost = total cost / customers acquired)
- **LTV:CAC ratio** (should be >3:1)
- **Burn rate** (how long can we operate at current spend?)
- **Break-even timeline** (when does revenue cover operational costs?)

## Revenue Tracking

Revenue data comes from GoHighLevel pipeline:
```
Pipeline Stage → Deal Value → Close Date → Revenue Logged
```

### Revenue Forecast Model
```
forecast_30d = (deals_in_proposal * close_rate * avg_deal_value)
             + (meetings_scheduled * meeting_to_proposal_rate * close_rate * avg_deal_value)
             + (hot_leads * lead_to_meeting_rate * meeting_to_proposal_rate * close_rate * avg_deal_value)
```

Update this forecast in every weekly and monthly review.

## Cost Optimization Playbook

### Quick Wins (Implement Immediately)
1. **MCP over Computer Use** — every Computer Use task that could be an MCP call wastes ~10x tokens
2. **Bash scripts over LLM** — data aggregation, file operations, simple transformations
3. **Cache screenshots** — don't re-screenshot dashboards that haven't changed
4. **Batch API calls** — combine multiple small calls into batch operations
5. **Right-size droplets** — monitor CPU/RAM utilization, downsize if <30% utilization

### Medium-Term (Evaluate Monthly)
1. **Consolidate overlapping tools** — do we need both X and Y if X does 80% of Y's job?
2. **Negotiate annual pricing** — most SaaS tools offer 20-40% discount for annual commitment
3. **Kill low-ROI channels** — if a channel's cost per meeting is >3x the average, shut it down
4. **Automate more** — every manual process Justin still does is a potential automation

### Audit Schedule
- **Daily:** Log costs, check for anomalies
- **Weekly:** Compare actuals to budget, update forecasts
- **Monthly:** Full cost audit, vendor evaluation, contract review
- **Quarterly:** Renegotiate contracts, evaluate tool stack

## Subscription Tracker

| Service | Monthly Cost | Annual Option | Contract End | Owner |
|---------|-------------|---------------|-------------|-------|
| Claude Pro/Max | $20-200 | N/A | Monthly | Justin |
| DigitalOcean | ~$37 | Pay as you go | N/A | AG |
| Smartlead | $[X] | Check annual | [Date] | AG |
| GoHighLevel | $[X] | Check annual | [Date] | Justin |
| Kit | $[X] | Check annual | [Date] | AG |
| Retell AI | $[X] usage | Pay as you go | N/A | AG |
| Twilio/Sendblue | $[X] usage | Pay as you go | N/A | AG |
| ClickUp | $[X] | Check annual | [Date] | Justin |
| Tailscale | $0 (free tier) | N/A | N/A | AG |

(COO fills in actual amounts during first monthly review)
