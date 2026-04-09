# GEMINI.md — COO Agent (Google Gemini Context)

> Instructions for Google Gemini when working on this repository.

---

## Project Overview

This is the **COO Agent** — an always-on AI Chief Operating Officer for JBell Solutions. It runs on Claude Code with MCP integrations, monitors all business systems, and reports to the CEO (Justin).

## Key Files

- `CLAUDE.md` — Primary operational rules (45 rules, identity, protocols)
- `AGENTS.md` — Agent definitions and coordination protocols
- `ARCHITECTURE.md` — System architecture and deployment topology
- `ETHOS.md` — Operating philosophy and values
- `TODOS.md` — Current task backlog and priorities
- `setup.sh` — Interactive setup script for new deployments
- `heartbeats/` — Scheduled report templates (morning, SDR, daily, weekly)
- `infrastructure/` — Deployment guides (Mac Mini, DigitalOcean, Tailscale, MCP)
- `skills/` — Operational skill definitions (SKILL.md files)
- `rules/` — Extended rule documentation

## Architecture

- **Runtime**: Claude Code on a Mac Mini (always-on via Tailscale)
- **Tool layers**: MCP tools (primary), Computer Use (GUI), Claude Code (files)
- **Integrations**: ClickUp, Gmail, Calendar, GitHub, Slack, Notion, Google Drive, GHL, Vercel, Smartlead, Kit, DigitalOcean
- **SDR team**: Autonomous agents on DigitalOcean droplets via Claude Code + cron

## Conventions

- Shell scripts use `set -e` and explicit error handling
- All heartbeats follow templates in `templates/`
- Configuration is dynamic (no hardcoded timezones, paths, or credentials)
- Every pipeline must have preflight health checks and self-healing loops
- Testing is mandatory — no untested work ships

## What NOT to Do

- Do not modify CLAUDE.md without understanding all 45 rules
- Do not hardcode credentials, API keys, or secrets
- Do not delete production assets without explicit approval
- Do not create orphaned code — when replacing, delete the old version
- Do not skip verification steps — proof of fix is non-negotiable
