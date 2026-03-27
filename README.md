# AI Chief Operating Officer

> Your always-on AI COO that sees everything, manages everything, and reports to you on any device. Built on Claude Code + Computer Use + Paperclip + OpenClaw.

## Quick Start

```bash
git clone https://github.com/jbellsolutions/coo-agent.git
cd coo-agent
./setup.sh
```

The setup script walks you through everything interactively — prerequisites, workspace creation, Paperclip dashboard, Tailscale, ClaudeClaw/Telegram, always-on config, and MCP connections. Takes about 30 minutes.

---

## What This Is

A single AI agent that acts as your Chief Operating Officer. It monitors all your tools, projects, and systems. It takes action when needed. You talk to it from your phone (Dispatch), your desktop (Claude Code), or a dashboard (Paperclip). Same agent, same memory, same conversation.

**It does three things:**
1. **Sees everything** — pulls updates from ClickUp, Gmail, Calendar, GitHub, Slack, Smartlead, Kit, DigitalOcean, GoHighLevel, and any web dashboard
2. **Manages everything** — deduplicates work, flags blockers, monitors agent teams, tracks costs
3. **Takes action** — makes changes to projects, sends messages, books meetings, spins up servers, updates CRM

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  MAC MINI (always on) — The COO's Brain                     │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  PAPERCLIP — Orchestration Dashboard                   │ │
│  │  Org chart, task tickets, budgets, governance          │ │
│  │  Web UI accessible from any device via Tailscale       │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  COO AGENT (Claude Code)                               │ │
│  │                                                        │ │
│  │  Layer 1: MCP Tools (fast, cheap, structured)          │ │
│  │  ClickUp │ Gmail │ Calendar │ GitHub │ Slack │ Notion  │ │
│  │  Google Drive │ Vercel │ GoHighLevel │ Composio        │ │
│  │                                                        │ │
│  │  Layer 2: Computer Use (GUI — anything without an API) │ │
│  │  Smartlead │ Kit │ DigitalOcean UI │ LinkedIn │ Any    │ │
│  │                                                        │ │
│  │  Layer 3: Claude Code (files, code, git, deployments)  │ │
│  │  Navigate projects │ Edit code │ Commit │ Deploy       │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ACCESS:                                                     │
│  Phone  → Dispatch (assign tasks from iPhone)                │
│  Phone  → Telegram (ClaudeClaw bridge — conversational)      │
│  Desktop → Claude Code terminal                              │
│  Browser → Paperclip UI (localhost or Tailscale)             │
└──────────────────────────┬──────────────────────────────────┘
                           │ monitors
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  DIGITALOCEAN (worker agents) — The Workforce               │
│                                                              │
│  Droplet 1: OpenClaw SDR Team (5 agents)                    │
│  ├── Prospector → Airtop AI, Apollo                         │
│  ├── Email SDR → Smartlead MCP                              │
│  ├── Phone SDR → Retell AI / CallHub                        │
│  ├── Text SDR → CallHub + Sendblue                          │
│  └── Sequence Manager → GHL CRM                             │
│                                                              │
│  Droplet 2: Cold Email System (Smartlead campaigns)         │
│  Droplet 3+: Other project-specific agents                  │
└─────────────────────────────────────────────────────────────┘
```

### Why This Split?

| | Mac Mini | DigitalOcean |
|---|---|---|
| **What** | COO brain + Computer Use | OpenClaw worker agents |
| **Why** | Computer Use requires macOS + screen | Cheap, scalable, headless |
| **Cost** | $0 (you own it) | ~$37/mo per droplet |
| **Access** | GUI + terminal + dashboard | Cron-driven, autonomous |
| **Deploy** | This repo | OpenClaw one-click deploy |

---

## The Three Access Points

### 1. Dispatch (Phone — iOS)

Assign tasks from your iPhone. Come back to completed work.

```
You (driving): "Pull my morning briefing"
COO (Mac Mini): checks 8 tools, compiles report
You (at gym): open Dispatch, read briefing
```

- Built into Claude iOS app
- Requires Claude Pro ($20/mo) or Max ($100-200/mo)
- Tasks queue and execute on your Mac Mini

### 2. Telegram (Phone — ClaudeClaw)

Conversational chat with your COO from anywhere.

```
You: "How's the SDR pipeline today?"
COO: "14 emails sent, 3 opens, 1 hot lead from Acme Corp. Phone SDR calling now."
You: "Book a call with their VP for tomorrow 2pm"
COO: "Done. Calendar event created, confirmation email sent."
```

- Uses [ClaudeClaw](https://github.com/earlyaidopters/claudeclaw) — Telegram bridge to Claude
- Runs on the Mac Mini alongside the COO
- Same memory, same tools, same agent

### 3. Paperclip Dashboard (Browser — Any Device)

Visual overview of all projects, agents, and costs.

- Org chart with agent roles and reporting lines
- Task tickets with conversation history
- Budget tracking per agent
- Heartbeat status (which agents ran, what they found)
- Accessible from any browser via Tailscale

---

## What the COO Does

### Daily Heartbeats

| Time | Heartbeat | What It Does |
|------|-----------|-------------|
| **7:00 AM** | Morning Briefing | Pull ClickUp tasks due today, check Gmail for urgent emails, review calendar, check GitHub activity, pull Smartlead stats (Computer Use), check Kit metrics (Computer Use), verify DO droplet health, compile briefing → post to Slack + Telegram |
| **9:00 AM** | SDR Check | Read SDR pipeline JSON files, check for hot leads, verify all agents ran on schedule |
| **11:00 AM** | Mid-Morning | Check email for replies, update ClickUp task statuses, flag anything that needs attention |
| **1:00 PM** | Afternoon | SDR mid-day check, review call/SMS activity, check for new leads |
| **3:00 PM** | Systems | Verify all DO droplets healthy, check server costs, flag any issues |
| **5:00 PM** | Daily Report | Full daily summary — SDR metrics, email campaigns, tasks completed, tasks blocked, costs, what needs you tomorrow → post to Slack + Telegram |
| **Fri 6 PM** | Weekly Review | SDR self-improvement loop, weekly metrics, cost analysis, recommendations |

### On-Demand (You Ask)

Anything you can say in natural language:

- "What's on my calendar today?"
- "Check the SDR pipeline — any hot leads?"
- "How's the cold email campaign performing?"
- "Create a ClickUp task for [thing]"
- "Draft a follow-up email to [person]"
- "What are my DO server costs this month?"
- "Push the latest changes to the staging branch"
- "Check if Kit newsletter went out — what were the open rates?"
- "Book a call with [person] for Tuesday at 2pm"
- "Give me a full operations report"

### When to Use MCP vs Computer Use

| Tool | Has MCP/API? | COO Uses |
|------|-------------|----------|
| ClickUp | Yes (MCP) | MCP — instant, structured |
| Gmail | Yes (MCP) | MCP — instant |
| Google Calendar | Yes (MCP) | MCP — instant |
| GitHub | Yes (gh CLI) | CLI — instant |
| Slack | Yes (MCP) | MCP — instant |
| Notion | Yes (MCP) | MCP — instant |
| Google Drive | Yes (MCP) | MCP — instant |
| Vercel | Yes (MCP) | MCP — instant |
| GoHighLevel | Yes (MCP) | MCP — instant |
| Composio | Yes (MCP) | MCP — 982+ tools |
| Smartlead | Partial (MCP) | MCP for API calls, Computer Use for dashboard stats |
| Kit (newsletter) | No | **Computer Use** — screenshot dashboard |
| DigitalOcean UI | No MCP | **Computer Use** for console, SSH for CLI |
| LinkedIn | No | **Computer Use** — browser automation |
| Any web portal | No | **Computer Use** — universal fallback |

**Rule**: MCP first (fast + cheap). Computer Use only when no API exists.

---

## File Structure

```
coo-agent/
├── README.md                          # This file
├── CLAUDE.md                          # COO personality, rules, governance (52 Rules)
├── agents/
│   └── coo/
│       └── SOUL.md                    # COO agent identity + capabilities
├── heartbeats/
│   ├── morning-briefing.md            # 7 AM heartbeat instructions
│   ├── sdr-check.md                   # SDR pipeline monitoring
│   ├── daily-report.md                # 5 PM daily summary
│   └── weekly-review.md              # Friday weekly analysis
├── rules/
│   └── RULES.md                       # The 52 Rules — operational governance
├── infrastructure/
│   ├── mac-mini-setup.md              # Mac Mini always-on setup guide
│   ├── paperclip-setup.md             # Paperclip installation + config
│   ├── claudeclaw-setup.md            # Telegram bridge setup
│   ├── tailscale-setup.md             # Remote access from phone/other devices
│   ├── mcp-connections.md             # All MCP server configurations
│   └── digitalocean-openclaw.md       # OpenClaw one-click deploy to DO
├── templates/
│   ├── morning-briefing-template.md   # Morning report format
│   ├── daily-report-template.md       # Daily report format
│   └── self-healing-pipeline.md       # Pipeline error handling
├── docs/
│   ├── architecture-decisions.md      # Why this architecture
│   ├── computer-use-guide.md          # When and how to use Computer Use
│   └── conversation-history.md        # Full conversation that built this
└── .gitignore
```

---

## Setup Guide

### Prerequisites

- Mac Mini (or any Mac) that can stay always-on
- Claude Pro ($20/mo) or Max ($100-200/mo) subscription
- DigitalOcean account (for OpenClaw worker agents)
- API keys for your tools (ClickUp, Gmail, etc.)

### Step 1: Mac Mini Setup (20 min)

```bash
# 1. Clone this repo
git clone https://github.com/jbellsolutions/coo-agent.git
cd coo-agent

# 2. Install Claude Code (if not already)
# Download from claude.ai/code

# 3. Prevent sleep (Mac Mini must stay awake)
sudo pmset -a sleep 0
sudo pmset -a disablesleep 1
sudo pmset -a displaysleep 0

# 4. Enable Computer Use in Claude Code
# Settings > Features > Computer Use > Enable

# 5. Set up the COO workspace
mkdir -p ~/coo-workspace/{logs,reports,cache}
cp CLAUDE.md ~/coo-workspace/CLAUDE.md
cp -r agents/ ~/coo-workspace/agents/
cp -r heartbeats/ ~/coo-workspace/heartbeats/
```

### Step 2: Paperclip Dashboard (15 min)

```bash
# 1. Install Paperclip
npx paperclipai onboard --yes
# OR manually:
git clone https://github.com/paperclipai/paperclip.git ~/paperclip
cd ~/paperclip && pnpm install && pnpm dev

# 2. Access at http://localhost:3100

# 3. Create your company
# - Company name: "JBell Solutions"
# - Add COO agent role
# - Set budget limits

# 4. Configure heartbeats in Paperclip
# - Morning Briefing: 7:00 AM ET
# - SDR Check: 9:00 AM, 1:00 PM ET
# - Daily Report: 5:00 PM ET
# - Weekly Review: Friday 6:00 PM ET
```

### Step 3: Connect MCP Tools (15 min)

Your MCP tools connect through Claude Code's settings. Add these to your `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "clickup": { "command": "npx", "args": ["@anthropic/mcp-clickup"] },
    "gmail": { "command": "npx", "args": ["@anthropic/mcp-gmail"] },
    "google-calendar": { "command": "npx", "args": ["@anthropic/mcp-google-calendar"] },
    "slack": { "command": "npx", "args": ["@anthropic/mcp-slack"] },
    "notion": { "command": "npx", "args": ["@anthropic/mcp-notion"] },
    "google-drive": { "command": "npx", "args": ["@anthropic/mcp-google-drive"] },
    "gohighlevel": { "command": "node", "args": ["path/to/ghl-mcp/index.js"] }
  }
}
```

See `infrastructure/mcp-connections.md` for detailed setup per tool.

### Step 4: Tailscale (5 min)

```bash
# 1. Install Tailscale on Mac Mini
brew install tailscale
# OR download from tailscale.com

# 2. Login
tailscale up

# 3. Install Tailscale on your phone + other devices
# Now access Paperclip from anywhere: http://mac-mini:3100
```

### Step 5: ClaudeClaw — Telegram Bridge (10 min)

```bash
# 1. Clone ClaudeClaw
git clone https://github.com/earlyaidopters/claudeclaw.git ~/claudeclaw
cd ~/claudeclaw

# 2. Configure (add Telegram bot token + Claude API key)
cp .env.example .env
# Edit .env with your keys

# 3. Start
npm install && npm start

# 4. Message your Telegram bot — it's connected to the COO
```

### Step 6: OpenClaw Workers on DigitalOcean (10 min)

```bash
# Option A: One-click deploy (recommended)
# Go to marketplace.digitalocean.com → search "OpenClaw"
# Click "Create Droplet" → select 8GB RAM → deploy

# Option B: Manual
doctl compute droplet create sdr-team \
  --image ubuntu-24-04-x64 \
  --size s-4vcpu-8gb \
  --region nyc1

# SSH in and install OpenClaw
ssh root@your-droplet-ip
curl -fsSL https://openclaw.com/install.sh | bash

# Deploy SDR agents
git clone https://github.com/jbellsolutions/openclaw-sdr-agent.git
cp -r openclaw-sdr-agent/v2-full/agents/ ~/openclaw-workspace/agents/
crontab openclaw-sdr-agent/v2-full/cron/crontab.txt
```

### Step 7: Test End-to-End (10 min)

```bash
# From your Mac Mini terminal:
cd ~/coo-workspace

# Test: Ask the COO for a morning briefing
claude "Run the morning briefing heartbeat — check ClickUp, email, calendar, GitHub, and Slack. Summarize what needs my attention today."

# Test: Computer Use (GUI)
claude "Use Computer Use to open Safari, go to app.smartlead.ai, and screenshot my campaign dashboard"

# Test: Dispatch (from iPhone)
# Open Claude app → send: "What's on my calendar today and any urgent emails?"

# Test: Telegram
# Message your ClaudeClaw bot: "SDR pipeline status?"

# Test: Paperclip
# Open http://localhost:3100 → verify COO agent is registered
```

---

## Mac Mini vs DigitalOcean — Decision Guide

| Question | Mac Mini | DigitalOcean |
|----------|----------|-------------|
| Needs a screen/GUI? | Yes → Mac Mini | No → DO |
| Needs Computer Use? | Yes → Mac Mini | No → DO |
| Needs to click through web apps? | Yes → Mac Mini | No → DO |
| Is it a headless cron agent? | No → wrong choice | Yes → DO |
| Needs macOS? | Yes → Mac Mini | No → DO |
| Cost-sensitive? | No (you own it) | Yes (~$37/mo) |

**Your COO** = Mac Mini (needs Computer Use for dashboards)
**Your SDR team** = DigitalOcean (headless, cron-driven, no GUI needed)

---

## OpenClaw's Role

OpenClaw is NOT replaced — it runs the worker agents:

| Component | Tool | Where |
|-----------|------|-------|
| **COO (brain)** | Claude Code + Computer Use + Paperclip | Mac Mini |
| **SDR Prospector** | OpenClaw agent | DigitalOcean |
| **SDR Email** | OpenClaw agent | DigitalOcean |
| **SDR Phone** | OpenClaw agent | DigitalOcean |
| **SDR Text** | OpenClaw agent | DigitalOcean |
| **SDR Sequence Manager** | OpenClaw agent | DigitalOcean |
| **Future agents** | OpenClaw agents | DigitalOcean |

The COO monitors the OpenClaw agents by:
1. Reading their JSON output files (via SSH/rsync from DO droplet)
2. Checking tool dashboards via Computer Use (Smartlead, GHL)
3. Receiving Slack notifications from the Sequence Manager
4. Pulling metrics via MCP tools (Composio, GHL)

---

## Cost Summary

| Item | Monthly |
|------|---------|
| Claude Pro/Max (COO + Computer Use + Dispatch) | $20-200 |
| Mac Mini electricity | ~$5 |
| DigitalOcean SDR droplet | ~$37 |
| Tailscale (free tier) | $0 |
| ClaudeClaw (self-hosted) | $0 |
| Paperclip (self-hosted) | $0 |
| MCP tools (free/included) | $0 |
| SDR tool stack (Smartlead, Retell, etc.) | ~$250-400 |
| **Total** | **~$312-642/mo** |

---

## Built With

| Tool | Purpose | Layer |
|------|---------|-------|
| [Claude Code](https://claude.ai/code) | COO agent runtime | Core |
| [Computer Use](https://docs.anthropic.com/en/docs/agents-and-tools/computer-use) | GUI automation for any app | Core |
| [Dispatch](https://claude.ai) | Phone access (iOS) | Access |
| [Paperclip](https://github.com/paperclipai/paperclip) | Orchestration dashboard | Dashboard |
| [ClaudeClaw](https://github.com/earlyaidopters/claudeclaw) | Telegram chat bridge | Access |
| [OpenClaw](https://github.com/open-claw/open-claw) | Worker agent framework (SDR team) | Workers |
| [Tailscale](https://tailscale.com) | Remote access mesh | Network |
| [Composio](https://composio.dev) | 982+ tool integrations via MCP | Integration |
| [ClickUp](https://clickup.com) | Task/project management | MCP |
| [GoHighLevel](https://gohighlevel.com) | CRM + pipeline | MCP |

## License

MIT
