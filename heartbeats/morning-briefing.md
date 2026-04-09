# Morning Briefing — 7:00 AM ET

## Purpose
Give Justin a clear picture of the day ahead before he starts working. Delivered to Slack #coo + Telegram.

## Data Sources

### Via MCP (fast)
1. **ClickUp** → `clickup_filter_tasks` with due date = today + overdue
2. **Gmail** → `gmail_search_messages` for unread, is:important, from key contacts
3. **Google Calendar** → `gcal_list_events` for today
4. **GitHub** → `gh pr list --state open` + `gh issue list` across repos
5. **Slack** → `slack_search_public` for unread in #general, #sdr, #alerts

### Via Computer Use (GUI — only if needed)
6. **Smartlead** → Open app.smartlead.ai → screenshot campaign dashboard → extract: emails sent yesterday, open rate, reply rate, bounce rate
7. **Kit** → Open app.kit.com → screenshot analytics → extract: subscriber count, last email open rate, click rate
8. **DigitalOcean** → Open cloud.digitalocean.com → screenshot droplet status → extract: CPU/memory/disk for all droplets

### Via SSH
9. **DO SDR Droplet** → `ssh sdr-team "cat ~/sdr-workspace/crm/metrics.json"` → extract: yesterday's SDR metrics

## Output Format

```
Good morning, Justin. Here's your briefing for [Day, Date].

CALENDAR (X events today)
━━━━━━━━━━━━━━━━━━━━━━━━━
• 9:00 AM — [Meeting name] with [Attendees]
• 2:00 PM — [Meeting name] with [Attendees]

EMAIL (X unread, Y urgent)
━━━━━━━━━━━━━━━━━━━━━━━━━
• [Sender] — [Subject] (urgent/flagged)
• [Sender] — [Subject]
• [X] other unread

TASKS DUE TODAY (X items)
━━━━━━━━━━━━━━━━━━━━━━━━━
• [Task name] — [List/Project] — [Status]
• [Task name] — [List/Project] — [Status]
Overdue: [N] tasks

SDR PIPELINE (yesterday)
━━━━━━━━━━━━━━━━━━━━━━━━━
• Prospected: [N] | Emailed: [N] | Called: [N] | Texted: [N]
• Opens: [N] | Replies: [N] | Meetings booked: [N]
• Hot leads: [N] — [names if any]

GITHUB
━━━━━━━━━━━━━━━━━━━━━━━━━
• Open PRs: [N] across [repos]
• New issues: [N]

SYSTEMS
━━━━━━━━━━━━━━━━━━━━━━━━━
• All DO droplets: [healthy/issues]
• Newsletter (Kit): [subscriber count], last email [open rate]%
• Cold email (Smartlead): [campaign status]

ACTION NEEDED
━━━━━━━━━━━━━━━━━━━━━━━━━
• [Thing that needs Justin's decision or attention]
• [Thing that needs Justin's decision or attention]
```

## Rules
- Be concise. Justin reads this while commuting.
- Lead with what needs action. Push FYI stuff to the bottom.
- If a system is down or unreachable, say so — don't skip it.
- If nothing needs attention, say "All clear — no action needed today."
