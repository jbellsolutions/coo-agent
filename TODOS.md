# TODOs

Prioritized backlog for the COO Agent system. P0 = do now, P4 = someday.

---

## P0 -- Critical Path

### Add SKILL.md files for heartbeats and common operations
Each heartbeat in `heartbeats/` needs a corresponding SKILL.md so Claude Code can discover and invoke them as skills. Create SKILL.md files for: morning-briefing, sdr-check, daily-report, weekly-review. Also create SKILL.md files for common on-demand operations: "pull SDR pipeline status," "check DO droplet health," "compile cost report."

### Add config validation script
Build a preflight script (`scripts/validate-config.sh`) that verifies all MCP connections are active and responding. Should test: ClickUp MCP, Gmail MCP, Calendar MCP, Slack MCP, Notion MCP, Google Drive MCP, GoHighLevel MCP, Vercel MCP, Composio MCP. Also verify: SSH access to DO droplets, Tailscale mesh connectivity, ClaudeClaw process running, Paperclip process running. Output: PASS/FAIL per connection with plain-English summary.

---

## P1 -- High Priority

### Add error recovery playbooks
Document step-by-step recovery procedures for the three most likely infrastructure failures:
1. **Mac Mini down** -- How to restart COO services, verify heartbeats resume, check for missed reports
2. **DO droplet down** -- How to verify SDR agents, restart OpenClaw, check for data gaps in JSON outputs
3. **API token expired** -- Which tokens expire, how to refresh each one (OAuth flow, manual reissue), how to verify the token works post-refresh

Store in `infrastructure/recovery-playbooks/` as individual markdown files the COO can read and follow.

### Add cost tracking implementation
Build a daily cost aggregation script that pulls: Claude API token usage (from billing or logs), DigitalOcean droplet costs (via DO API), Smartlead/Retell/CallHub API costs (from respective dashboards via Computer Use or API). Aggregate into a daily cost JSON file. Include in the 5 PM daily report. Alert if daily spend exceeds configurable threshold.

### Implement memory manager
Build the auto-logging system required by Rules 15, 16, 40, and 41:
- **Daily memory files** -- Auto-log work type (BUILD, BUGFIX, DEBUG, AUDIT, RESEARCH), time spent, key decisions
- **Error fix log** -- Date, issue, what did not work, final fix (Rule 15)
- **Crash patterns doc** -- Pattern, Trigger, Symptom, Root Cause, Prevention, First Seen (Rule 41)
- **Long-term memory** -- Architecture facts, tool rules, identity only (Rule 40)

Store in `~/coo-workspace/memory/` with daily, error, crash-patterns, and permanent subdirectories.

---

## P2 -- Medium Priority

### Add backup and redundancy strategy
Define and implement:
- S3 (or DO Spaces) backup of COO state: daily memory files, crash patterns, error logs, SDR JSON outputs
- Backup schedule (nightly) with retention (30 days)
- Failover instructions: if Mac Mini dies, how to spin up a temporary COO on another Mac or cloud instance
- Document in `infrastructure/backup-strategy.md`

### Add Computer Use cost monitor
Track Computer Use token consumption separately from MCP operations. Log each Computer Use session: which tool (Smartlead, Kit, LinkedIn, etc.), number of screenshots taken, estimated token cost. Include in daily cost report. Flag if Computer Use spend exceeds 30% of total token budget (it should stay around 10%).

### Add A/B testing infrastructure for SDR campaigns
Build a framework for the SDR team to run A/B tests on:
- Email subject lines (Smartlead)
- Call scripts (Retell AI)
- SMS templates (CallHub/Sendblue)
Track results in structured JSON. Include winning variant and statistical significance in weekly review. The COO should recommend the winner and auto-promote it (with approval).

---

## P3 -- Low Priority

### Add Paperclip integration docs
Document the full integration between the COO agent and Paperclip:
- How heartbeat schedules are configured in Paperclip
- How task tickets flow from Paperclip to COO execution
- How budget tracking syncs between COO cost reports and Paperclip dashboards
- How the org chart reflects the COO + SDR team hierarchy
Store in `docs/paperclip-integration.md`.

### Add conversation history capture
Build a system to capture and store conversation history across all access points:
- Dispatch tasks and results
- Telegram (ClaudeClaw) conversations
- Claude Code terminal sessions
- Paperclip task ticket conversations
Store in structured format for context retrieval. The COO should be able to recall "what did we discuss about X last Tuesday?"

---

## P4 -- Someday

### Weekly self-improvement loop
Implement a Karpathy-style autoresearch loop for SDR performance optimization:
1. Pull weekly SDR metrics (emails sent, open rates, reply rates, meetings booked)
2. Generate hypotheses for improvement (subject line changes, send time optimization, sequence adjustments)
3. Propose A/B tests based on hypotheses
4. Run tests, measure results
5. Keep winners, discard losers, generate new hypotheses
6. Present findings in the Friday weekly review with confidence levels

This is the COO getting smarter at its job over time, not just reporting metrics but actively optimizing them.
