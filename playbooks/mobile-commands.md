# Mobile Quick Commands — Telegram + Dispatch

Justin can trigger any of these from his phone. The COO responds within the same channel.

---

## Quick Commands

### Status & Health
| Command | What It Does | Response Time |
|---------|-------------|---------------|
| `status` | Full system health check — all services, agents, circuits | <30 seconds |
| `systems` | Droplet health, MCP connections, circuit breaker states | <30 seconds |
| `agents` | Status of all sub-agents (last run, success/fail, output count) | <30 seconds |

### Pipeline & Sales
| Command | What It Does | Response Time |
|---------|-------------|---------------|
| `pipeline` | Current SDR pipeline snapshot — leads, stage counts, hot leads | <30 seconds |
| `hot leads` | All leads flagged hot in last 24h with details and next steps | <30 seconds |
| `meetings` | Today's calendar with prep notes for each meeting | <30 seconds |
| `funnel` | Full funnel conversion rates — this week vs last week | <1 minute |

### Financial
| Command | What It Does | Response Time |
|---------|-------------|---------------|
| `costs` | Current week operational spend breakdown | <30 seconds |
| `roi` | Channel ROI comparison table | <1 minute |
| `forecast` | 30/60/90 day revenue forecast from pipeline data | <1 minute |

### Actions
| Command | What It Does | Response Time |
|---------|-------------|---------------|
| `brief me` | Run morning briefing on demand | <2 minutes |
| `report` | Run daily report on demand | <2 minutes |
| `check sdr` | Run SDR pipeline check on demand | <1 minute |
| `restart [agent]` | Restart a specific agent on DO | <1 minute |

### Research
| Command | What It Does | Response Time |
|---------|-------------|---------------|
| `research [company]` | Quick company research — size, funding, tech stack, decision makers | <2 minutes |
| `competitor [name]` | Pull latest competitor intel | <2 minutes |

### Meta
| Command | What It Does | Response Time |
|---------|-------------|---------------|
| `help` | List all available commands | Instant |
| `what broke` | Summary of any errors, alerts, or circuit breaker events today | <30 seconds |
| `what's new` | Changes, deployments, or improvements made since last check-in | <30 seconds |

## Response Format Rules

1. **Phone-first.** All responses must be readable on a phone screen:
   - Short paragraphs (2-3 lines max)
   - Bold key numbers
   - Bullet points for lists
   - No tables wider than 4 columns
2. **Lead with the answer.** Don't build up to it.
3. **Include action items.** If something needs Justin's attention, say what he should do.
4. **Timestamp everything.** "As of 2:30 PM ET" so Justin knows how fresh the data is.
5. **Error gracefully.** If a system is unreachable, say "Unable to reach [service] — last known data from [time]" instead of failing silently.

## Implementation

### Telegram (ClaudeClaw)
- Bot receives message → parses command → executes → responds in same chat
- Supports follow-up: "tell me more about [hot lead name]"
- Supports threading: replies stay in context

### Dispatch (iPhone Claude App)
- Justin types command → Claude Code session runs → responds when done
- Better for longer tasks (research, full reports)
- Results persist in conversation history

### Slack (DM to AG)
- Same commands work in Slack DM
- Rich formatting (code blocks, attachments)
- Best for when Justin is at a computer
