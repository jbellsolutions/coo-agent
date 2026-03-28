# Contributing

How to extend the COO Agent system. Four common operations.

---

## Add a New Heartbeat

Heartbeats are scheduled checks the COO runs at fixed times. Each heartbeat is a markdown file the COO reads and executes.

**1. Create the heartbeat file.**

```bash
touch heartbeats/your-heartbeat-name.md
```

**2. Write the instructions.** Follow this structure:

```markdown
# Heartbeat Name

## Schedule
When this runs (e.g., "Daily at 10:00 AM ET").

## Sources
Which systems to pull from:
- Tool 1 (MCP) -- what to check
- Tool 2 (Computer Use) -- what to screenshot
- Tool 3 (SSH) -- what files to read

## Checks
Specific things to verify, in order:
1. Check X -- expected state, what counts as a problem
2. Check Y -- expected state, what counts as a problem

## Output
Where to post results:
- Slack channel
- Telegram
- Log file location

## Escalation
When to alert immediately vs include in next report.
```

**3. Create a report template** (optional). If the heartbeat produces a formatted report, add a template in `templates/your-heartbeat-template.md`.

**4. Register in Paperclip.** Add the heartbeat schedule to the Paperclip dashboard so it triggers at the configured time.

**5. Update SOUL.md.** Add the new heartbeat to `agents/coo/SOUL.md` under the Daily Schedule section with its time, sources, and output channels.

**6. Test it.** Run the heartbeat manually from the terminal:

```bash
claude "Run the [heartbeat name] heartbeat now and show me the output."
```

Verify the output matches the template and posts to the correct channels.

---

## Add a New MCP Tool

MCP tools are the fastest and cheapest way for the COO to interact with external services.

**1. Find or build the MCP server.** Check if one exists at `npmjs.com` (search `@anthropic/mcp-*` or `mcp-*`). If not, build one or use Composio (982+ tools).

**2. Add to Claude Code settings.** Edit `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "your-tool": {
      "command": "npx",
      "args": ["@scope/mcp-your-tool"],
      "env": {
        "API_KEY": "your-key-here"
      }
    }
  }
}
```

**3. Document the connection.** Add an entry in `infrastructure/mcp-connections.md` with:
- Tool name and purpose
- MCP server package name
- Required environment variables or API keys
- How to verify the connection works
- Common operations the COO will use it for

**4. Update CLAUDE.md.** Add the tool to the "Direct (MCP Tools)" list under Project Awareness so the COO knows it has access.

**5. Update SOUL.md.** Add the tool to the Layer 1 MCP tools list in `agents/coo/SOUL.md`.

**6. Test the connection.**

```bash
claude "Test the [tool name] MCP connection. List available operations and run a simple read query."
```

**7. Update the config validation script** (if it exists in `scripts/`). Add a health check for the new MCP connection.

---

## Add a New Rule

Rules are hard constraints that govern COO behavior. Every rule should trace back to a real failure.

**1. Identify the failure.** What broke? What was the consequence? What behavior would have prevented it?

**2. Pick the next rule number.** Rules are numbered sequentially. The current highest is Rule 52. Your new rule is Rule 53.

**3. Add to RULES.md.** Open `rules/RULES.md` and add the rule under the appropriate section (Execution, Verification, Security, Architecture, Communication, Memory, Business, or Platform). Follow the format:

```markdown
**Rule 53 -- Rule Name**
Clear, imperative statement of what to do or not do. One to three sentences. No ambiguity. If the rule has sub-steps, list them.
```

**4. Add to CLAUDE.md.** The rule must also be reflected in `CLAUDE.md` so it loads into every session. Add it under the appropriate behavioral section (Core Behavior, Verification, Tool Priority, Security, Architecture, Honesty, Memory, or Cost).

**5. Sync.** Rule 48 (Global Rules Sync) requires syncing to all machines and instances. If the COO runs on multiple machines, copy the updated files to all of them.

**6. Log the rule origin.** In `docs/architecture-decisions.md` or a dedicated rule history file, note: the date, what broke, and why this rule prevents it from happening again.

---

## Add a New Worker Agent

Worker agents run on DigitalOcean via OpenClaw. They are headless, cron-driven, and autonomous.

**1. Define the agent's identity.** Create a SOUL.md for the agent:

```markdown
# Agent Name -- SOUL.md

## Identity
What this agent is and what it does.

## Mission
The single sentence that defines success.

## Tools
What APIs, services, or data sources the agent uses.

## Schedule
When it runs (cron expression).

## Inputs
What data it reads and from where.

## Outputs
What files it produces and where they go.

## Escalation
When it alerts the COO vs handles silently.
```

**2. Build the agent.** Follow OpenClaw's agent structure. Place agent files in the OpenClaw workspace on the DO droplet.

**3. Set up the cron schedule.** Add to the crontab on the DO droplet:

```bash
ssh root@your-droplet-ip
crontab -e
# Add: schedule /path/to/agent/run.sh
```

**4. Define output files.** The COO monitors worker agents by reading their JSON output files. Define a consistent output location and schema:

```
~/openclaw-workspace/output/agent-name/
  |- status.json      # Agent health and last run time
  |- results.json     # Agent output data
  |- errors.json      # Any errors from last run
```

**5. Add COO monitoring.** Update the relevant heartbeat (usually `heartbeats/sdr-check.md` or create a new one) to include checks for the new agent's output files and error states.

**6. Update the architecture.** Add the agent to:
- `README.md` architecture diagram
- `ARCHITECTURE.md` worker agent section
- `agents/coo/SOUL.md` SDR Team Monitoring section (or equivalent)

**7. Register in Paperclip.** Add the agent to the Paperclip org chart with its role, reporting line (reports to COO), and budget allocation.

**8. Test end-to-end.** Run the agent manually, verify it produces the expected output files, then verify the COO can read and report on those files during its next heartbeat.
