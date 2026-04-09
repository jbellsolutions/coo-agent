# Architecture Decisions

## Why This Architecture?

### Decision 1: Mac Mini + DigitalOcean (not one or the other)

**Problem:** Computer Use requires macOS + a screen. Autonomous SDR agents are headless and don't need GUI.

**Decision:** Split the workload:
- Mac Mini = COO brain (Computer Use, Paperclip dashboard, ClaudeClaw)
- DigitalOcean = Worker agents (Autonomous SDR team, headless cron jobs)

**Why not all on DO?** Computer Use is macOS-only. No way around it.
**Why not all on Mac Mini?** Autonomous SDR agents are cheaper to run on DO ($37/mo) and benefit from always-on cloud uptime. Mac Mini is for the brain, not the muscle.

### Decision 2: MCP First, Computer Use Second

**Problem:** Computer Use is powerful but expensive (screenshot tokens) and slow (screenshot → analyze → click loop).

**Decision:** Use MCP tools for everything that has an API. Computer Use only for GUI-only tools.

**Result:** ~90% of COO tasks use MCP (instant, cheap). ~10% use Computer Use (necessary for Smartlead, Kit, LinkedIn, etc.).

### Decision 3: Paperclip for Orchestration

**Problem:** Need a visual dashboard to see all agents, tasks, and costs. Need scheduled heartbeats.

**Decision:** Paperclip — it's purpose-built for multi-agent orchestration with org charts, budgets, heartbeats, and a mobile-ready UI.

**Alternatives considered:**
- Custom dashboard → too much to build and maintain
- Just Slack → no visual overview, no agent management
- n8n/Make → workflow builder, not agent orchestrator

### Decision 4: Three Access Points (Dispatch + Telegram + Dashboard)

**Problem:** Need to reach the COO from phone (on the go), desktop (at work), and dashboard (for overview).

**Decision:**
- Dispatch (iPhone) → task-based, "do this and tell me when done"
- Telegram (ClaudeClaw) → conversational, "how's the pipeline?"
- Paperclip UI → visual dashboard, "show me everything"

**Why all three?** Different contexts need different interfaces. Driving? Dispatch. At gym? Telegram. At desk? Dashboard.

### Decision 5: Claude Code for Workers (headless), Claude Code for COO (Computer Use)

**Problem:** COO needs Computer Use and full system access. SDR agents need always-on cron scheduling and run headless.

**Decision:** Right tool for the job:
- Claude Code (headless + cron) = worker agents that run on schedules, handle outreach, follow SOUL.md instructions
- Claude Code (Computer Use) = COO agent that needs GUI automation, MCP tools, and full system access

### Decision 6: The 52 Rules as Governance

**Problem:** AI agents can hallucinate, take destructive actions, inflate metrics, or spend money without approval.

**Decision:** Embed the 52 Rules (battle-tested from real production failures) into the COO's CLAUDE.md. Every rule exists because something broke.

**Key rules that matter most for COO:**
- Anti-hallucination protocol (verify before claiming)
- No unauthorized destructive actions
- Honest reporting (even when numbers are bad)
- Design before code
- Root cause investigation before fixes
