# Knowledge Base & Institutional Memory

The COO's long-term memory architecture. Not just daily logs — structured knowledge that gets smarter over time.

---

## Architecture

```
RAW DATA → DAILY LOGS → PATTERN EXTRACTION → KNOWLEDGE BASE → DECISION SUPPORT
```

### Layer 1: Daily Logs (Ephemeral)
What happened today. Expires after 30 days.
- Daily reports (5 PM)
- Error logs
- Agent outputs
- Cost logs

### Layer 2: Weekly/Monthly Summaries (Semi-Permanent)
Aggregated patterns. Retained for 1 year.
- Weekly reviews
- Monthly strategy reviews
- A/B test results
- Incident postmortems

### Layer 3: Knowledge Base (Permanent)
Proven knowledge that should persist forever.
- Winning patterns (`improvements/patterns-winning.md`)
- Anti-patterns (`improvements/patterns-losing.md`)
- Crash patterns (`improvements/crash-patterns.md`)
- Client playbooks
- Vendor evaluations
- Compliance requirements

### Layer 4: Identity & Rules (Immutable unless explicitly changed)
- CLAUDE.md (operational rules)
- SOUL.md (agent identity)
- RULES.md (governance framework)

## Knowledge Categories

### Operational Knowledge
| Topic | Location | Update Frequency |
|-------|----------|-----------------|
| What works in email outreach | patterns-winning.md | Weekly |
| What doesn't work | patterns-losing.md | Weekly |
| Common errors and fixes | crash-patterns.md | Per incident |
| ICP characteristics that convert | knowledge/icp-insights.md | Monthly |
| Best times to send | knowledge/timing-insights.md | Monthly |
| Optimal sequence lengths | knowledge/sequence-insights.md | Monthly |

### Business Knowledge
| Topic | Location | Update Frequency |
|-------|----------|-----------------|
| Client preferences and history | knowledge/clients/ | Per project |
| Vendor capabilities and costs | knowledge/vendors/ | Quarterly |
| Competitor intelligence | knowledge/competitors/ | Monthly |
| Industry trends | knowledge/market/ | Monthly |

### Technical Knowledge
| Topic | Location | Update Frequency |
|-------|----------|-----------------|
| Tool configurations | infrastructure/ | On change |
| Integration patterns | knowledge/integrations/ | On discovery |
| Performance baselines | knowledge/baselines.md | Weekly |
| Deployment procedures | agents/sub-agents/ | On change |

## How the COO Learns

### After Every Incident
1. Log the incident in crash-patterns.md
2. Extract the lesson: what would have prevented this?
3. Update preflight checks or monitoring to catch it next time
4. If applicable, add to patterns-losing.md

### After Every Weekly Review
1. Extract top patterns from the week's data
2. Update patterns-winning.md with confirmed wins
3. Update patterns-losing.md with confirmed failures
4. Adjust monitoring thresholds based on new baselines

### After Every A/B Test
1. Log the full result (hypothesis, control, variant, data, outcome)
2. If winner: add to patterns-winning.md, apply broadly
3. If loser: add to patterns-losing.md, document WHY

### After Every Client Project
1. Extract reusable processes
2. Document what the client valued most
3. Note any new tools or techniques discovered
4. Update intake checklist with new requirements discovered

## Retrieval Protocol

Before making decisions, the COO checks relevant knowledge:

1. **Before writing outreach:** Check patterns-winning.md for proven templates
2. **Before debugging:** Check crash-patterns.md for known issues
3. **Before proposing a tool:** Check vendor evaluations
4. **Before scaling a channel:** Check channel ROI history
5. **Before starting a new experiment:** Check patterns-losing.md to avoid repeating failures

## Memory Hygiene

### What Goes in Long-Term Memory
- Proven patterns (validated with data)
- Root cause analyses
- Compliance requirements
- Tool configurations
- Client relationship context
- Business rules and constraints

### What Does NOT Go in Long-Term Memory
- Daily metrics (they live in daily reports)
- In-progress experiments (they live in experiment log)
- Temporary workarounds (they get proper fixes)
- Speculation without evidence
- Justin's schedule (it changes daily)

### Cleanup Schedule
- **Monthly:** Archive daily logs older than 30 days
- **Quarterly:** Review knowledge base for stale entries
- **Annual:** Full knowledge audit — what's still relevant?

## Audit Trail

Every action the COO takes is logged for accountability:

```json
{
  "timestamp": "2026-03-28T10:30:00Z",
  "actor": "AG (COO)",
  "action": "updated_task_status",
  "target": "clickup_task_abc123",
  "details": "Changed status from 'in progress' to 'done'",
  "reason": "Deliverable verified complete via anti-hallucination protocol",
  "evidence": "Screenshot of passing test at screenshots/2026-03-28/task_abc123.png"
}
```

The audit trail answers: WHO did WHAT, WHEN, WHY, and with WHAT EVIDENCE.
This is critical for:
- Justin reviewing COO decisions
- Debugging when something goes wrong
- Compliance audits
- Continuous improvement (what decisions led to good/bad outcomes)
