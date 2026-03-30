# AI Chief Operating Officer — Setup Walkthrough

> **To install:** Open Claude Code in this folder and type `set this up for me` or `/walkthrough`

Claude Code will read this repo's actual files and walk you through every step interactively — Mac Mini always-on setup, Paperclip dashboard, Tailscale remote access, Telegram/ClaudeClaw bridge, and all MCP tool connections.

---

## What This Repo Does

A single AI agent that acts as your Chief Operating Officer. It monitors ClickUp, Gmail, Calendar, GitHub, Slack, Smartlead, Kit, DigitalOcean, and GoHighLevel — then takes action: deduplicates work, flags blockers, monitors your agent teams, tracks costs, books meetings, updates your CRM, and reports to you on your phone. Three tool layers: MCP (fast, structured), Computer Use (GUI automation), and Claude Code (files, code, git). Talk to it from Telegram, Claude Code, or the Paperclip dashboard.

---

## Prerequisites

- **Mac Mini** (always-on preferred) — this is the COO's brain
- **Claude Code** — Anthropic's CLI (`claude` command)
- **Python 3.10+** — `python3 --version`
- **Tailscale** — for remote phone access (free tier works)
- **Telegram account** — for mobile interface via ClaudeClaw
- **Paperclip** — orchestration dashboard (paperclip.ing)
- **Accounts required:** ClickUp, GitHub, Gmail, Slack, Smartlead, DigitalOcean (connect what you use)

---

## Environment Variables

The COO agent reads credentials from MCP server configs. Key connections to configure:

| Integration | Type | Setup Location |
|-------------|------|---------------|
| ClickUp | MCP | docs/mcp-connections.md |
| Gmail + Calendar | MCP | docs/mcp-connections.md |
| GitHub | MCP | docs/mcp-connections.md |
| Slack | MCP | docs/mcp-connections.md |
| Telegram (ClaudeClaw) | Bridge | docs/claudeclaw-setup.md |
| Tailscale | VPN | docs/tailscale-setup.md |
| Paperclip | Dashboard | docs/paperclip-setup.md |
| DigitalOcean | MCP/Computer Use | docs/mcp-connections.md |

---

## Quick Setup (30 Minutes)

```bash
# 1. Run the interactive setup wizard
bash setup.sh
```

The setup script walks through everything in order:
1. Prerequisites check
2. Workspace creation
3. Paperclip dashboard installation
4. Tailscale setup (remote phone access)
5. ClaudeClaw/Telegram bridge
6. Always-on config (launchd on Mac)
7. MCP server connections

For a step-by-step guided walkthrough, open Claude Code and type `/walkthrough`.

---

## Setup Guide Files

The `docs/` folder has detailed guides for each component:

| File | Covers |
|------|--------|
| `docs/mac-mini-setup.md` | Mac Mini always-on configuration |
| `docs/paperclip-setup.md` | Paperclip installation and configuration |
| `docs/claudeclaw-setup.md` | Telegram bridge for mobile commands |
| `docs/tailscale-setup.md` | Remote access from phone and other devices |
| `docs/mcp-connections.md` | All MCP server configurations |

---

## The Three Access Modes

Once set up, you can interact with your COO from:

1. **Claude Code** (desktop) — Full capabilities, file access, code changes
2. **Telegram** (mobile) — 20+ quick commands: `status`, `pipeline`, `hot leads`, `costs`
3. **Paperclip** (web dashboard) — Org chart, task tickets, governance, accessible from any device via Tailscale

---

## Key Commands (After Setup)

| Command | What It Does |
|---------|-------------|
| `bash setup.sh` | Full interactive setup wizard |
| `claude` | Open Claude Code (COO interface) |
| Telegram: `status` | Get a system-wide status report |
| Telegram: `pipeline` | View current sales pipeline |
| Telegram: `hot leads` | List top-priority leads |
| Telegram: `costs` | Current agent spend across all tools |
| Telegram: `blockers` | List flagged blockers needing attention |

---

## What the COO Does Automatically

- Pulls updates from all connected tools every session
- Deduplicates tasks across ClickUp, Gmail, and Slack
- Flags blockers without waiting to be asked
- Monitors agent team health and restarts failures
- Tracks full funnel: lead → meeting → close → revenue
- Generates monthly strategic reviews with 90-day forecasts
- Runs Karpathy-pattern A/B tests on outreach and reporting

---

*This file was deployed by [AGI-1](https://github.com/jbellsolutions/agi-1) — the self-healing, self-learning AI development framework.*
