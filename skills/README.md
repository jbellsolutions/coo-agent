# COO Skills

Custom skills that extend the COO's capabilities. Each skill is a self-contained module that can be invoked by the COO or triggered by events.

---

## Installed Skills

### Operational
| Skill | Description | Trigger |
|-------|------------|---------|
| `morning-briefing` | Compile and deliver daily briefing | 7 AM ET (heartbeat) |
| `sdr-check` | Monitor SDR pipeline and flag issues | 9 AM, 1 PM ET (heartbeat) |
| `daily-report` | Generate end-of-day summary | 5 PM ET (heartbeat) |
| `weekly-review` | Full week analysis with recommendations | Friday 6 PM ET (heartbeat) |
| `monthly-strategy` | Strategic review with forecasting | 1st of month (heartbeat) |
| `system-health` | Full infrastructure health check | On demand ("status" command) |

### GTM & Revenue
| Skill | Description | Trigger |
|-------|------------|---------|
| `pipeline-snapshot` | Real-time pipeline stage counts | On demand ("pipeline" command) |
| `channel-roi` | Compare ROI across outreach channels | Weekly review |
| `competitor-scan` | Research competitor changes | Monthly review |
| `revenue-forecast` | 30/60/90 day projection | On demand or monthly |

### Agent Management
| Skill | Description | Trigger |
|-------|------------|---------|
| `agent-health-check` | Verify all agents are running | 9 AM, 1 PM ET |
| `circuit-breaker-scan` | Check all circuit breaker states | Every heartbeat |
| `agent-restart` | Restart a failed agent on DO | On demand or auto-recovery |

### Self-Improvement
| Skill | Description | Trigger |
|-------|------------|---------|
| `experiment-evaluate` | Evaluate A/B test results | Weekly review |
| `pattern-update` | Update winning/losing pattern libraries | Post-evaluation |
| `self-score` | COO scores own performance against metrics | Weekly review |

### Research & Intelligence
| Skill | Description | Trigger |
|-------|------------|---------|
| `company-research` | Deep research on a prospect or competitor | On demand |
| `market-scan` | Industry trends and news | Monthly review |

## Adding New Skills

1. Create a markdown file in `skills/` with the skill name
2. Define: trigger, data sources, output format, success criteria
3. Add to the skills table above
4. Test with a dry run before activating

## Skill Design Rules

- Each skill does ONE thing well
- Every skill has a clear trigger (time-based, event-based, or on-demand)
- Every skill produces a measurable output
- Skills can chain: one skill's output can trigger another
- Skills respect the tool priority: MCP → Computer Use → Claude Code
