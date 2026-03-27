# MCP Server Connections

All MCP tools connect through Claude Code's settings. These give the COO instant, structured access to your tools — no screenshots needed.

## Configuration

Add to `~/.claude/settings.json` on the Mac Mini:

```json
{
  "mcpServers": {
    "clickup": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-clickup"],
      "env": { "CLICKUP_API_KEY": "your-key" }
    },
    "gmail": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-gmail"],
      "env": { "GMAIL_OAUTH_CREDENTIALS": "path/to/credentials.json" }
    },
    "google-calendar": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-google-calendar"],
      "env": { "GCAL_OAUTH_CREDENTIALS": "path/to/credentials.json" }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-slack"],
      "env": { "SLACK_BOT_TOKEN": "xoxb-your-token" }
    },
    "notion": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-notion"],
      "env": { "NOTION_API_KEY": "your-key" }
    },
    "google-drive": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-google-drive"],
      "env": { "GDRIVE_OAUTH_CREDENTIALS": "path/to/credentials.json" }
    },
    "gohighlevel": {
      "command": "node",
      "args": ["/path/to/GoHighLevel-MCP/index.js"],
      "env": { "GHL_API_KEY": "your-key" }
    },
    "composio": {
      "command": "npx",
      "args": ["-y", "@composio/mcp-server"],
      "env": { "COMPOSIO_API_KEY": "your-key" }
    }
  }
}
```

## Available Tools by Service

| Service | Key Tools | Used For |
|---------|-----------|----------|
| **ClickUp** | filter_tasks, create_task, update_task, get_workspace_hierarchy | Task management, daily tracking |
| **Gmail** | search_messages, read_message, create_draft | Email triage, drafting |
| **Google Calendar** | list_events, create_event, find_free_time | Schedule management |
| **Slack** | send_message, search_public, read_channel | Team communication, reports |
| **Notion** | search, create_page, update_page | Documentation |
| **Google Drive** | search, fetch | File access |
| **GoHighLevel** | 269+ tools — contacts, pipeline, conversations | CRM management |
| **Composio** | 982+ tools — calendar booking, enrichment, etc. | Universal integration |

## Verification

Test each connection:
```bash
# In Claude Code on the Mac Mini:
claude "List my ClickUp workspaces"
claude "Check my unread Gmail count"
claude "What's on my calendar today?"
claude "List Slack channels"
claude "Search Notion for 'COO'"
```

If a tool fails, check:
1. API key is correct and not expired
2. OAuth credentials are valid
3. MCP server is installed: `npx -y @anthropic/mcp-[tool] --version`
