# Paperclip Setup — Orchestration Dashboard

## What Paperclip Does for You
- Visual dashboard showing all agents, tasks, and costs
- Org chart with COO role and reporting lines
- Heartbeat scheduling (morning briefing, SDR checks, daily reports)
- Budget tracking per agent
- Task tickets with conversation history
- Mobile-ready UI (access from phone via Tailscale)

## Install

```bash
# Quick start (recommended)
npx paperclipai onboard --yes

# Manual
git clone https://github.com/paperclipai/paperclip.git ~/paperclip
cd ~/paperclip
pnpm install
pnpm dev
```

Access at: `http://localhost:3100`

## Initial Configuration

### 1. Create Your Company
- Name: "JBell Solutions"
- Goal: "Build and scale AI-powered businesses"

### 2. Add the COO Agent
- Name: AG (COO)
- Role: Chief Operating Officer
- Model: Claude Sonnet 4.6
- Budget: Set monthly token limit
- Heartbeats:
  - Morning Briefing: 7:00 AM ET (daily)
  - SDR Check: 9:00 AM, 1:00 PM ET (daily)
  - Daily Report: 5:00 PM ET (daily)
  - Weekly Review: Friday 6:00 PM ET (weekly)

### 3. Add SDR Team (as monitored agents)
These run on DigitalOcean, but Paperclip tracks them:
- Prospector (Haiku) — monitored
- Email SDR (Sonnet) — monitored
- Phone SDR (Retell AI) — monitored
- Text SDR (Sonnet) — monitored
- Sequence Manager (Sonnet) — monitored

### 4. Set Budgets
- COO agent: $X/month (Claude API tokens)
- SDR team: tracked via JSON files (not billed through Paperclip)

## Access from Phone
1. Install Tailscale on Mac Mini + phone
2. Access: `http://mac-mini-tailscale-name:3100`
3. Mobile-responsive — works in phone browser

## Auto-Start on Boot
See `mac-mini-setup.md` for LaunchAgent configuration.
