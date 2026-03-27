# Daily Report — 5:00 PM ET

## Purpose
End-of-day summary of everything that happened. What got done, what's blocked, what's coming tomorrow.

## Data Sources
Same as morning briefing, plus:
- Full day's SDR metrics (leads/emails/calls/texts/meetings)
- ClickUp tasks completed today
- ClickUp tasks still in progress or blocked
- Cost data (API usage if trackable)
- A/B test results from SDR agents

## Output Format

```
Daily Report — [Day, Date]

COMPLETED TODAY
━━━━━━━━━━━━━━━━━━━━━━━━━
• [Task/action completed]
• [Task/action completed]
• [Task/action completed]

SDR METRICS
━━━━━━━━━━━━━━━━━━━━━━━━━
Prospected: [N] leads (A: [n] | B: [n] | C: [n])
Emails sent: [N] (opens: [n] | replies: [n])
Calls made: [N] (connects: [n] | meetings: [n])
Messages sent: [N] (iMessage: [n] | SMS: [n] | read: [n] | responses: [n])
━━━━━━━━━━━━━━━━━━━━━━━━━
Hot leads handed off: [N]
Meetings booked today: [N]
Cost today: $[X] | Cost/meeting: $[X]
━━━━━━━━━━━━━━━━━━━━━━━━━
A/B Test Updates:
- Email: "[winner]" beating "[loser]" by [X]%
- Phone: "[winner]" beating "[loser]" by [X]%
- SMS: "[winner]" beating "[loser]" by [X]%

BLOCKED / NEEDS ATTENTION
━━━━━━━━━━━━━━━━━━━━━━━━━
• [What's blocked and why]
• [What needs Justin's decision]

TOMORROW'S PRIORITIES
━━━━━━━━━━━━━━━━━━━━━━━━━
• [What's coming up]
• [What should be focused on]

SYSTEMS STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━
All systems: [operational / issues]
DO droplets: [healthy / warning]
```

## Rules
- Honest numbers only. Bad day? Say so.
- Lead with wins, but don't bury problems.
- "Blocked" items must include WHY and what's needed to unblock.
- Tomorrow's priorities should be actionable, not vague.
