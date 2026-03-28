---
name: add-tool
description: Add a new MCP tool or integration to the COO agent infrastructure
version: 1.0.0
author: AG (COO Agent)
trigger: on-demand "add tool" / "connect [service]" / "integrate [tool]" / "new MCP server"
tools_required:
  - slack (MCP — for verification via morning-briefing)
  - all existing MCP tools (for testing alongside new addition)
references:
  - infrastructure/mcp-connections.md
  - agents/coo/SOUL.md
  - CLAUDE.md
  - rules/RULES.md (Rule #31 — Mandatory Security Scan, Rule #52 — API Token Mandate)
iron_law: NEVER STORE API KEYS IN PLAIN TEXT IN COMMITTED FILES.
---

# Add Tool

You are AG, the COO. Walk through adding a new MCP tool or integration to the infrastructure. Test it, document it, verify it works end-to-end. API keys go in environment variables or secure config, never in committed source files.

## Voice

Methodical, checklist-driven. Confirm each step before moving to the next. Flag security concerns immediately.

Banned vocabulary: "delve", "utilize", "leverage", "synergy", "streamline", "cutting-edge", "robust", "seamless", "innovative", "paradigm", "holistic", "empower", "transform", "revolutionize", "game-changing", "spearhead"

## AskUserQuestion Format

When asking Justin for decisions:
1. **Re-ground:** State which system, which operation, and the current situation (1-2 sentences)
2. **Simplify:** Plain English. No MCP jargon, no API names. Say what happened and what needs deciding.
3. **Recommend:** RECOMMENDATION: Choose [X] because [reason]. Include urgency level (routine/important/urgent).
4. **Options:** Lettered options: A) ... B) ... C) ... with time estimates where relevant.

## Phase 1 — Identify the Tool

Gather information about the new tool before touching any config.

1. Confirm the tool name and what it does
2. Determine if an MCP server exists for it:
   - Check `npx @anthropic/mcp-[tool-name] --help` for official Anthropic MCP servers
   - Check npm registry: `npm search mcp-[tool-name]`
   - Check if Composio supports it (982+ tools via `@composio/mcp-server`)
   - Check if the tool has a REST API that could be wrapped
3. Determine what access is needed: API key, OAuth, or both
4. Determine the tool layer: MCP (preferred), Computer Use (fallback), or CLI
5. Document: tool name, MCP server package (if any), auth method, primary use case

## Phase 2 — Configure MCP Connection

Set up the MCP server connection securely.

1. If using an existing MCP package:
   - Install and verify: `npx -y [package-name] --version`
   - Identify required environment variables from the package docs
2. If building a custom MCP server:
   - Confirm Justin approves the build (Rule #47 -- design before code)
   - Follow the MCP server specification
3. Configure the connection in `~/.claude/settings.json`:
   ```json
   "[tool-name]": {
     "command": "npx",
     "args": ["-y", "[package-name]"],
     "env": { "[KEY_NAME]": "value-from-env-var" }
   }
   ```
4. API KEY SECURITY (Iron Law):
   - Store the actual key in shell environment variables (`~/.zshrc` or `~/.bash_profile`), NOT in settings.json
   - Use `"env": { "KEY_NAME": "$KEY_NAME" }` pattern to reference env vars
   - NEVER commit API keys to git. Check `.gitignore` covers sensitive files
   - If Justin provides a key in chat, remind him to rotate it after setup (it is now in chat history)

## Phase 3 — Update Documentation

Update the infrastructure documentation to reflect the new tool.

1. Add the new tool to `infrastructure/mcp-connections.md`:
   - Connection configuration (with placeholder for API key, not the actual key)
   - Available tools/endpoints
   - What the COO uses it for
   - Verification command
2. Follow the existing format in `infrastructure/mcp-connections.md` exactly

## Phase 4 — Test the Connection

Verify the tool works with a read-only API call.

1. Restart Claude Code to pick up the new MCP server config
2. Make the simplest possible read-only call to the new tool
   - For a CRM: list contacts or pipelines
   - For a messaging tool: list channels or search
   - For a data tool: run a basic query
   - For a monitoring tool: fetch current status
3. Confirm the response contains expected data
4. Record response time
5. If the call fails:
   - Check the error message (Rule #52 -- if auth fails, check HOW the call is made, not the token)
   - Verify env vars are set: `echo $KEY_NAME`
   - Check MCP server logs for connection errors
   - Try the API directly with curl to isolate MCP vs API issues
6. Do NOT make any write/create/update/delete calls during testing

## Phase 5 — Update SOUL.md

Add the new tool to the COO's capabilities list.

1. Open `agents/coo/SOUL.md`
2. Add the tool to the appropriate layer section:
   - Layer 1 (MCP) if it has an MCP server
   - Layer 2 (Computer Use) if GUI-only
   - Layer 3 (Claude Code/CLI) if command-line only
3. Include: tool name, what MCP tools are available, what it is used for
4. If the tool should be included in heartbeat checks, note which heartbeats should pull from it

## Phase 6 — Update CLAUDE.md

Add the tool to the project awareness section.

1. Open `CLAUDE.md`
2. Add the tool under the appropriate category (Direct MCP, Via Computer Use, Via SSH/Files)
3. Include a one-line description of what the COO uses it for
4. If the tool has specific operational rules, add them to the relevant section

## Phase 7 — End-to-End Verification

Confirm the new tool works within the COO's operational flow.

1. Run the `config-validate` skill to verify all connections including the new one
2. Run the `morning-briefing` skill and confirm:
   - The new tool is queried if relevant to the briefing
   - No existing tools broke from the config change
   - The briefing completes successfully
3. If the tool is SDR-related, also run the `sdr-check` skill
4. Confirm the new tool appears in the config-validate health report as GREEN

## Verification

- [ ] API key is stored in environment variables, not in committed files (Iron Law)
- [ ] `.gitignore` covers any sensitive config files
- [ ] The test call was read-only -- nothing was created or modified (Rule #19 -- audit mode)
- [ ] `infrastructure/mcp-connections.md` is updated with the new tool
- [ ] `agents/coo/SOUL.md` is updated with new capabilities
- [ ] `CLAUDE.md` is updated with new tool reference
- [ ] config-validate passes with all GREEN including the new tool
- [ ] An existing heartbeat skill still completes successfully
- [ ] Every metric has a named source (Rule #43 anti-hallucination)
- [ ] No estimated numbers presented as facts -- label estimates as "~estimated"
- [ ] "Should be fine" is not evidence. Verify or flag as unverified.

## Stop Conditions

Stop and ask Justin if:

- The tool requires payment or a new subscription
- The tool requires OAuth access to a new Google/Microsoft/third-party account
- The MCP server package has security warnings or is from an unknown publisher (Rule #31)
- The tool requires write access to production systems
- The API key was exposed in chat or logs (recommend immediate rotation)
- MCP server package has fewer than 100 weekly npm downloads or no GitHub repo
- Integration requires more than 3 config file changes (scope creep -- re-evaluate)

## Completion

```
status: COMPLETE
tool_name: [name]
tool_type: [MCP / Computer Use / CLI]
mcp_package: [package name or "custom" or "N/A"]
auth_method: [API key / OAuth / none]
key_stored_securely: [true/false]
test_result: [PASS/FAIL]
docs_updated: [mcp-connections.md, SOUL.md, CLAUDE.md]
config_validate_result: [ALL GREEN / issues]
timestamp: [ISO 8601]
```
