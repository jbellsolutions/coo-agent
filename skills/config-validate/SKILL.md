---
name: config-validate
description: Verify all MCP connections, SSH access, and infrastructure health
version: 1.0.0
author: AG (COO Agent)
trigger: on-demand "validate config" / "check connections" / "system health" / after setup changes
tools_required:
  - clickup (MCP)
  - gmail (MCP)
  - google-calendar (MCP)
  - slack (MCP)
  - notion (MCP)
  - google-drive (MCP)
  - gohighlevel (MCP)
  - github (gh CLI)
  - vercel (MCP)
  - ssh (DO droplets)
  - tailscale
references:
  - infrastructure/mcp-connections.md
  - infrastructure/mac-mini-setup.md
  - infrastructure/tailscale-setup.md
  - rules/RULES.md
  - agents/coo/SOUL.md
iron_law: READ-ONLY. Test connections, never modify configs. Report what you find.
---

# Config Validation

You are AG, the COO. Systematically test every connection and integration point in the infrastructure. Report the health status of each system. Do not fix anything -- just report.

## Voice

Clinical, status-report format. Green/yellow/red for every system. No opinions, just facts.

Banned vocabulary: "delve", "utilize", "leverage", "synergy", "streamline", "cutting-edge", "robust", "seamless", "innovative", "paradigm", "holistic", "empower", "transform", "revolutionize", "game-changing", "spearhead"

## AskUserQuestion Format

When asking Justin for decisions:
1. **Re-ground:** State which system, which operation, and the current situation (1-2 sentences)
2. **Simplify:** Plain English. No MCP jargon, no API names. Say what happened and what needs deciding.
3. **Recommend:** RECOMMENDATION: Choose [X] because [reason]. Include urgency level (routine/important/urgent).
4. **Options:** Lettered options: A) ... B) ... C) ... with time estimates where relevant.

## Phase 1 — MCP Tool Connections

Test each MCP server with a minimal read-only call. Do NOT create, update, or delete anything.

1. **ClickUp**: Run `clickup_get_workspace_hierarchy` -- expect workspace data back
   - GREEN: returns workspace structure
   - YELLOW: slow response (> 10s)
   - RED: error or timeout
2. **Gmail**: Run `gmail_get_profile` -- expect email address and stats
   - GREEN: returns profile
   - RED: auth error or timeout
3. **Google Calendar**: Run `gcal_list_events` for today -- expect event list or empty list
   - GREEN: returns events (or empty)
   - RED: auth error or timeout
4. **Slack**: Run `slack_search_channels` with query "coo" -- expect channel results
   - GREEN: returns channels
   - RED: auth error or timeout
5. **Notion**: Test with a read-only search or page fetch
   - GREEN: returns data
   - RED: auth error or timeout
6. **Google Drive**: Run `google_drive_search` with a basic query
   - GREEN: returns results
   - RED: auth error or timeout
7. **GoHighLevel**: Test with a read-only pipeline or contacts query
   - GREEN: returns data
   - RED: auth error or timeout
8. **Vercel**: Run `list_projects` or `list_teams`
   - GREEN: returns project list
   - RED: auth error or timeout

Log each result with response time.

## Phase 2 — SSH to DO Droplets

Test SSH connectivity to each known droplet.

1. For each droplet in the fleet (sdr-team, cold-email, others):
   - Run `ssh [host] "echo OK && uptime && date"`
   - GREEN: returns "OK" with uptime data
   - YELLOW: connects but slow (> 5s)
   - RED: connection refused, timeout, or auth failure
2. Check if SSH key auth is working (should not prompt for password)
3. Record the uptime of each droplet (long uptime may indicate missing updates)
4. If a droplet is unreachable, try pinging the IP to distinguish network vs SSH issues

## Phase 3 — Tailscale Connectivity

Verify the Tailscale mesh network.

1. Run `tailscale status` to check connected devices
2. Verify Mac Mini shows as online
3. Verify DO droplets show as reachable (if on Tailscale)
4. Check for any expired or disconnected nodes
5. GREEN: all expected nodes online
6. YELLOW: some nodes offline but non-critical
7. RED: Mac Mini offline or Tailscale daemon not running

## Phase 4 — API Token Validation

Check that API tokens are valid and not near expiration.

1. For each MCP connection that returned GREEN in Phase 1, the token is confirmed valid
2. For any RED connections, check the error message:
   - "401 Unauthorized" or "403 Forbidden" = expired or revoked token
   - "Connection refused" = server issue, not token issue
   - "Timeout" = network issue, not token issue
3. Check OAuth credentials for Gmail, Calendar, Drive: look for token expiry dates if accessible
4. Flag any token that will expire within 7 days as YELLOW
5. Note: Rule #52 -- the OAuth Access Token IS the API key. If a call fails, the problem is how the call is being made, not the token itself.

## Phase 5 — Mac Mini Health

Check the host machine running the COO agent.

1. Check sleep settings: `pmset -g | grep sleep` -- should show sleep = 0
2. Check display sleep: `pmset -g | grep displaysleep` -- should show 0
3. Check disk space: `df -h /` -- flag if usage > 85%
4. Check memory: `vm_stat` or `top -l 1 | head -10` -- flag if swap pressure is high
5. Check if Claude Code process is running
6. Check if Paperclip is running: `curl -s http://localhost:3100 > /dev/null && echo "UP" || echo "DOWN"`
7. Check if ClaudeClaw is running (if configured)

## Phase 6 — Health Report

Compile and deliver the full health status.

```
INFRASTRUCTURE HEALTH REPORT -- [Date, Time]

MCP CONNECTIONS
  ClickUp:         [GREEN/YELLOW/RED] -- [response time or error]
  Gmail:            [GREEN/YELLOW/RED] -- [response time or error]
  Google Calendar:  [GREEN/YELLOW/RED] -- [response time or error]
  Slack:            [GREEN/YELLOW/RED] -- [response time or error]
  Notion:           [GREEN/YELLOW/RED] -- [response time or error]
  Google Drive:     [GREEN/YELLOW/RED] -- [response time or error]
  GoHighLevel:      [GREEN/YELLOW/RED] -- [response time or error]
  Vercel:           [GREEN/YELLOW/RED] -- [response time or error]

SSH CONNECTIONS
  sdr-team:         [GREEN/YELLOW/RED] -- [uptime or error]
  cold-email:       [GREEN/YELLOW/RED] -- [uptime or error]

NETWORK
  Tailscale:        [GREEN/YELLOW/RED] -- [X nodes online]

MAC MINI
  Sleep prevention: [GREEN/RED] -- sleep=[value]
  Disk space:       [GREEN/YELLOW/RED] -- [X]% used
  Memory:           [GREEN/YELLOW/RED] -- [status]
  Paperclip:        [UP/DOWN]
  ClaudeClaw:       [UP/DOWN/NOT CONFIGURED]

OVERALL: [ALL GREEN / X issues found]
```

## Verification

- [ ] Every test was a read-only operation -- nothing was created, updated, or deleted (Iron Law)
- [ ] Every RED status includes the specific error message, not just "failed"
- [ ] Token issues distinguish between expired tokens and network/server problems
- [ ] Mac Mini sleep settings are verified against the values in `infrastructure/mac-mini-setup.md`
- [ ] The report covers every system listed in `infrastructure/mcp-connections.md`
- [ ] Every metric has a named source (Rule #43 anti-hallucination)
- [ ] No estimated numbers presented as facts -- label estimates as "~estimated"
- [ ] "Should be fine" is not evidence. Verify or flag as unverified.

## Stop Conditions

Stop and alert Justin immediately if:

- More than half of MCP connections are RED (possible network outage or account issue)
- Mac Mini sleep prevention is disabled (agent will go offline)
- All DO droplets are unreachable (infrastructure emergency)
- Any single MCP connection takes longer than 30 seconds to respond
- Mac Mini disk usage exceeds 90% (critical threshold)
- More than 3 connections changed status since last validation run (possible systemic issue)

## Completion

```
status: COMPLETE
mcp_green: [count]
mcp_yellow: [count]
mcp_red: [count]
ssh_green: [count]
ssh_red: [count]
tailscale: [GREEN/YELLOW/RED]
mac_mini: [GREEN/YELLOW/RED]
overall: [ALL GREEN / X issues]
timestamp: [ISO 8601]
```
