# Computer Use Guide — When and How

## What It Is
Computer Use lets Claude autonomously control your Mac — opening apps, clicking buttons, filling forms, extracting data from screenshots. It runs a continuous loop: screenshot → analyze → act → repeat.

## When to Use It

**Use Computer Use when:**
- The tool has NO API or MCP server (Kit, legacy dashboards, proprietary portals)
- You need visual data from a web dashboard (Smartlead campaign stats, analytics)
- You need to interact with a GUI app (desktop apps, web forms)
- You need to click through a multi-step web workflow

**DON'T use Computer Use when:**
- An MCP tool exists (ClickUp, Gmail, Calendar, GitHub, Slack, Notion, GHL) — use MCP instead
- A CLI/API exists — use that instead (faster, cheaper)
- The data is in a file — just read the file

**Why this matters:** Computer Use costs more tokens (screenshots = large input). MCP calls are instant and cheap. Always prefer MCP.

## How It Works

1. Claude takes a screenshot of the screen
2. Vision model identifies UI elements at pixel-precise coordinates
3. Claude returns a tool call: `mouse_move`, `key`, or `type`
4. Local engine executes the action on your Mac
5. Repeat until task is done

### Zoom Action (New)
`enable_zoom: true` lets Claude zoom into specific screen regions before interacting. Improves accuracy on small buttons or dense UIs.

## Requirements
- macOS only (no Windows/Linux support yet)
- Claude Pro ($20/mo) or Max ($100-200/mo)
- Mac must be awake with screen active (display emulator dongle for headless)
- Computer Use enabled in Claude Code settings

## COO Use Cases

### Smartlead Dashboard
```
Prompt: "Open Safari, go to app.smartlead.ai, log in, and screenshot the campaign dashboard. Extract: total emails sent this week, open rate, reply rate, bounce rate."
```

### Kit Newsletter Metrics
```
Prompt: "Open Safari, go to app.kit.com, check the analytics dashboard. Extract: total subscribers, last email open rate, click rate, unsubscribes this week."
```

### DigitalOcean Console
```
Prompt: "Open Safari, go to cloud.digitalocean.com, check the droplets page. Screenshot and tell me the health status of all droplets — CPU, memory, disk usage."
```

### LinkedIn
```
Prompt: "Open Safari, go to linkedin.com. Check notifications and any new messages. Summarize what needs attention."
```

## Cost Optimization Tips
1. **Batch GUI tasks.** Don't use Computer Use for one metric — have it check multiple dashboards in one session.
2. **Cache screenshots.** If you just need the same data again, reference the last screenshot instead of taking a new one.
3. **Extract to JSON.** Have Computer Use extract structured data and save it to a file. Future checks can read the file (cheaper than re-screenshotting).
4. **Set resolution.** Lower resolution = fewer tokens per screenshot.

## Dispatch Integration
Computer Use + Dispatch is the killer combo for phone access:
1. You send a Dispatch prompt from your iPhone: "Check Smartlead and Kit metrics"
2. Your Mac Mini wakes Claude Code with Computer Use
3. Claude opens browsers, screenshots dashboards, extracts data
4. Results appear in your Dispatch thread when ready
5. You read the results on your phone

All of this happens while you're away from the Mac.
