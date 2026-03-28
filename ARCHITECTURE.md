# Architecture

> How the AI COO system is structured, why it's structured this way, and where every piece runs.

---

## The Core Idea

An always-on AI Chief Operating Officer that monitors every business system, takes action when needed, and reports to the CEO from any device. One agent, one brain, one conversation -- accessible from phone, desktop, and dashboard simultaneously.

The COO (named AG) runs on Claude Code with three tool layers, four scheduled heartbeats, and 52 production-tested rules embedded in its identity. It manages a distributed workforce of SDR agents running on DigitalOcean and coordinates everything through MCP-first integrations.

---

## System Architecture

```
                         YOU (Justin, CEO)
                              |
           +------------------+------------------+
           |                  |                  |
      [Dispatch]        [Telegram]         [Paperclip]
      iPhone app       ClaudeClaw bot       Web dashboard
      task-based       conversational       visual overview
           |                  |                  |
           +------------------+------------------+
                              |
                              v
 +================================================================+
 |  MAC MINI (always on) -- The COO's Brain                       |
 |                                                                |
 |  +----------------------------------------------------------+ |
 |  |  PAPERCLIP -- Orchestration Dashboard                    | |
 |  |  Org chart | Task tickets | Budgets | Heartbeat status   | |
 |  |  Web UI at localhost:3100 (Tailscale for remote)         | |
 |  +----------------------------------------------------------+ |
 |                                                                |
 |  +----------------------------------------------------------+ |
 |  |  COO AGENT (Claude Code + CLAUDE.md + 52 Rules)          | |
 |  |                                                          | |
 |  |  Layer 1: MCP Tools (fast, cheap, structured)            | |
 |  |  ClickUp | Gmail | Calendar | GitHub | Slack | Notion    | |
 |  |  Google Drive | Vercel | GoHighLevel | Composio (982+)   | |
 |  |                                                          | |
 |  |  Layer 2: Computer Use (GUI fallback)                    | |
 |  |  Smartlead | Kit | DigitalOcean UI | LinkedIn | Any web  | |
 |  |                                                          | |
 |  |  Layer 3: Claude Code (files, code, git, deployments)    | |
 |  |  Navigate projects | Edit code | Commit | Deploy | SSH   | |
 |  +----------------------------------------------------------+ |
 |                                                                |
 |  +----------------------------------------------------------+ |
 |  |  CLAUDECLAW -- Telegram Bridge                           | |
 |  |  Same memory, same tools, conversational access          | |
 |  +----------------------------------------------------------+ |
 |                                                                |
 +==========================+=====================================+
                            | monitors via SSH/rsync/MCP
                            v
 +================================================================+
 |  DIGITALOCEAN (worker agents) -- The Workforce                 |
 |                                                                |
 |  Droplet 1: OpenClaw SDR Team (5 agents)                      |
 |  +-- Prospector -------> Airtop AI, Apollo                    |
 |  +-- Email SDR --------> Smartlead MCP                        |
 |  +-- Phone SDR --------> Retell AI / CallHub                  |
 |  +-- Text SDR ---------> CallHub + Sendblue                   |
 |  +-- Sequence Manager --> GHL CRM                             |
 |                                                                |
 |  Droplet 2: Cold Email System (Smartlead campaigns)           |
 |  Droplet 3+: Future project-specific agents                   |
 +================================================================+
                            |
                      [Tailscale Mesh]
                    Encrypted private network
                 connects Mac Mini <-> DO <-> Phone
```

---

## Why Mac Mini + DigitalOcean

The split exists for one practical reason: Computer Use requires macOS with a display. Everything else is headless.

| Dimension | Mac Mini | DigitalOcean |
|-----------|----------|--------------|
| **Role** | COO brain, orchestration, Computer Use | Worker agents, cron-driven SDR |
| **Why here** | Computer Use needs macOS + screen | Cheap, scalable, always-on cloud |
| **Cost** | $0 (owned hardware) + ~$5/mo electricity | ~$37/mo per droplet |
| **Access** | GUI + terminal + Paperclip dashboard | SSH, cron, autonomous |
| **Deploy** | This repo (coo-agent) | OpenClaw one-click deploy |

**Why not all on DigitalOcean?** Computer Use is macOS-only. There is no workaround.

**Why not all on Mac Mini?** OpenClaw agents are cheaper on DO and benefit from cloud uptime guarantees. The Mac Mini is the brain, not the muscle.

---

## The 3-Layer Tool Hierarchy

Every COO action follows a strict priority order. This is Rule 14-17 in the 52 Rules.

### Layer 1: MCP Tools (Priority -- fast, cheap, structured)

MCP tools make direct API calls. No screenshots, no GUI parsing, no wasted tokens. The COO uses MCP for approximately 90% of all tasks.

| Tool | MCP Server | What It Does |
|------|-----------|-------------|
| ClickUp | @anthropic/mcp-clickup | Tasks, lists, time tracking, docs |
| Gmail | @anthropic/mcp-gmail | Read, search, draft emails |
| Google Calendar | @anthropic/mcp-google-calendar | Events, availability, booking |
| Slack | @anthropic/mcp-slack | Messages, channels, search |
| Notion | @anthropic/mcp-notion | Pages, databases |
| Google Drive | @anthropic/mcp-google-drive | Files, search |
| GoHighLevel | Custom MCP | CRM contacts, pipeline, conversations |
| Vercel | @anthropic/mcp-vercel | Deployments, projects, logs |
| Composio | Composio MCP | 982+ additional tool integrations |

### Layer 2: Computer Use (Fallback -- GUI-only tools)

Computer Use takes a screenshot, analyzes the screen, and clicks through the GUI. It works for any application but costs more tokens (images) and runs slower (screenshot-analyze-click loop). Used only when no API or MCP server exists.

- Smartlead -- campaign dashboards, email stats
- Kit -- newsletter metrics, subscriber counts
- DigitalOcean console -- visual server management
- LinkedIn -- content, engagement, prospect research
- Any web portal -- universal fallback for anything with a browser

### Layer 3: Claude Code (Files, code, git)

Direct filesystem and shell access for development tasks.

- Navigate and read project folders
- Edit code and configuration files
- Git operations (commit, push, create PRs)
- Run scripts, tests, and builds
- SSH into remote servers (DO droplets)

**The rule is simple:** MCP first (instant, cheap). Computer Use only when no API exists. Claude Code for file and code operations.

---

## Heartbeat Architecture

The COO runs four scheduled checks daily. The design principle is silent success -- only report when something needs human attention.

| Time (ET) | Heartbeat | Sources | Output |
|-----------|-----------|---------|--------|
| 7:00 AM | Morning Briefing | ClickUp, Gmail, Calendar, GitHub, Slack, Smartlead (CU), Kit (CU), DO health | Formatted briefing to Slack #coo + Telegram |
| 9:00 AM / 1:00 PM | SDR Pipeline Check | SDR JSON files (SSH), GHL CRM (MCP), Slack #sdr, Smartlead (CU) | Flag hot leads, agent failures, metric anomalies |
| 5:00 PM | Daily Report | Full SDR metrics, ClickUp tasks, cost report, blockers | Summary to Slack #coo + Telegram |
| Friday 6:00 PM | Weekly Review | Week-over-week SDR metrics, cost trends, self-improvement loop | Strategic recommendations |

**Escalation protocol:**
1. Normal finding -- include in next scheduled report
2. Hot lead -- DM Justin on Slack + Telegram immediately
3. System failure -- post to Slack #alerts immediately
4. Budget exceeded -- post to Slack #alerts + DM Justin

Heartbeat instructions live in `heartbeats/` as individual markdown files. Report templates live in `templates/`.

---

## The 52 Rules Governance

The 52 Rules in `rules/RULES.md` are not documentation -- they are the COO's operational identity. They are embedded in CLAUDE.md so they load into every session automatically. Every rule exists because something broke in production.

The rules cover 10 domains:

1. **Execution and Autonomy** (Rules 1-4, 7, 9) -- Do the work, own the full task, admit when stuck
2. **Verification and Quality** (Rules 8, 11-12, 38, 43-44, 46) -- Mandatory testing, anti-hallucination, systematic debugging
3. **Security and Safety** (Rules 5-6, 13, 22-23, 26-27, 30-31) -- No unauthorized changes, asset locks, zero-delete
4. **Content and Publishing** (Rules 24-25, 51) -- No double posts, no test language in public
5. **Architecture and Engineering** (Rules 10, 14, 20-21, 28, 34-35, 42, 49-50) -- Root cause first, self-healing pipelines, lean deduplication
6. **Cost Optimization** (Rule 18) -- Token optimization, scripts over LLM when possible
7. **Communication and Honesty** (Rules 33, 36-37, 45, 47) -- No bullshit, cite sources, independent reasoning
8. **Memory and Documentation** (Rules 15-17, 19, 40-41, 48) -- Auto-log errors, crash pattern tracking
9. **Business and Contracts** (Rules 29, 32) -- No build before payment
10. **Platform and API** (Rules 39, 52) -- Research first, respect OAuth tokens

---

## Worker Agent Architecture

The OpenClaw SDR team runs on DigitalOcean as five autonomous agents, each with their own SOUL.md and cron schedule:

```
SDR Team (DO Droplet 1)
|
+-- Prospector
|   Sources: Airtop AI, Apollo
|   Output: leads/today.json
|   Schedule: Daily 6 AM ET
|
+-- Email SDR
|   Tool: Smartlead MCP
|   Output: sequences/email_status.json
|   Schedule: Hourly 8 AM - 6 PM ET
|
+-- Phone SDR
|   Tools: Retell AI, CallHub
|   Output: calls/call_log.json
|   Schedule: Business hours ET
|
+-- Text SDR
|   Tools: CallHub, Sendblue
|   Output: sms/sms_log.json
|   Schedule: Business hours ET
|
+-- Sequence Manager
|   Tool: GHL CRM
|   Output: crm/pipeline.json
|   Reports: Slack #sdr
|   Schedule: Every 2 hours
```

The COO monitors these agents by:
1. Reading their JSON output files via SSH/rsync
2. Checking tool dashboards via Computer Use (Smartlead, GHL)
3. Receiving Slack notifications from the Sequence Manager
4. Pulling CRM data via GoHighLevel MCP

---

## Access Points

### Dispatch (iPhone -- iOS Claude App)
Task-based. Send a prompt, come back to completed work. Best for on-the-go commands like "pull my morning briefing" or "check DO server costs." Requires Claude Pro ($20/mo) or Max ($100-200/mo).

### Telegram (ClaudeClaw Bridge)
Conversational. Ask follow-up questions, get real-time answers. Runs on the Mac Mini alongside the COO. Same memory, same tools, same agent. Self-hosted, no additional cost.

### Paperclip Dashboard (Browser -- Any Device)
Visual overview of all agents, tasks, budgets, and heartbeat statuses. Org chart with reporting lines. Accessible from any browser via Tailscale at `http://mac-mini:3100`.

### Claude Code Terminal (Desktop)
Direct terminal access on the Mac Mini. Full agent capabilities with no UI abstraction. Best for complex operations, debugging, and development work.

---

## Security Model

- **Tailscale mesh network** -- Encrypted private network connecting Mac Mini, DO droplets, and mobile devices. No public internet exposure for management interfaces.
- **MCP token authentication** -- Each MCP server authenticates via OAuth or API key. Tokens stored in Claude Code settings, not in code.
- **No unauthorized live tests** (Rule 13) -- Cron jobs and automated triggers require explicit approval before testing.
- **Zero-delete mandate** (Rule 23) -- No production assets deleted without explicit approval.
- **Asset lock before publish** (Rule 22) -- Lock specific assets before any publishing action.
- **OAuth by default** (Rule 26) -- All new account signups use OAuth, never manual passwords.
- **Dry-run before wiring** (Rule 27) -- Scripts tested with `--dry-run` before connecting to schedulers.
- **3-layer file protection** (Rule 30) -- Guard headers, protected registry, graceful degradation for shared files.

---

## What's Intentionally Not Here

- **No n8n/Make/Zapier** -- Workflow builders are for connecting triggers to actions. The COO reasons about what to do. Paperclip handles orchestration scheduling.
- **No web UI for the COO itself** -- The COO is a terminal agent with Computer Use. Paperclip provides the web UI layer.
- **No multi-tenant** -- This is a single-company COO. One agent, one CEO, one business.
- **No custom LLM hosting** -- Claude Code is the runtime. No self-hosted models, no fine-tuning.
- **No vector database or RAG** -- The COO reads files directly. Memory lives in markdown files and daily logs, not embeddings.

---

## Error Philosophy

Errors are governed by the 52 Rules, not ad-hoc patches:

- **Anti-hallucination protocol** (Rule 43) -- Before claiming any status, identify the proof command, run it fresh, read full output, verify it confirms the claim. Red flags: "should," "probably," "seems to."
- **Systematic debugging** (Rule 44) -- Phase 1: reproduce. Phase 2: compare working vs broken. Phase 3: single hypothesis, smallest change. Phase 4: implement only after verifying root cause.
- **Self-healing pipelines** (Rule 28) -- Every pipeline has preflight health checks and auto-fix loops. A pipeline without both layers is incomplete.
- **Error classification** (Rule 42) -- FATAL vs RETRYABLE, cooldown retries with backoff, circuit breakers after N failures, one alert (never spam).
- **Admit when stuck** (Rule 4) -- Stop and say so. Do not spin. Do not fabricate progress.
- **Cite everything** (Rule 36) -- No source means "this is my assumption." Never present assumptions as facts.
