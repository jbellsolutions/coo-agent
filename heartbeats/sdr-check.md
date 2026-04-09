# SDR Pipeline Check — 9:00 AM + 1:00 PM ET

## Purpose
Monitor the SDR team running on DigitalOcean. Flag hot leads immediately. Verify all agents ran on schedule.

## Data Sources

### Via SSH (DO Droplet)
1. `cat ~/sdr-workspace/leads/today.json` → new leads prospected
2. `cat ~/sdr-workspace/pipeline/status.json` → pipeline state
3. `cat ~/sdr-workspace/crm/prospects.json` → prospect statuses
4. `ls -la ~/sdr-workspace/calls/$(date +%Y-%m-%d)/` → calls made today
5. `ls -la ~/sdr-workspace/sms/$(date +%Y-%m-%d)/` → texts sent today

### Via MCP
6. **GoHighLevel** → check pipeline stages, new contacts, conversations
7. **Slack #sdr** → any alerts from Sequence Manager

### Via Computer Use (if needed)
8. **Smartlead** → check real-time email delivery/open stats

## Checks

### Agent Health
- Did Prospector run at 6 AM? (check `leads/today.json` timestamp)
- Did Email SDR run at 8 AM and 10 AM? (check `sequences/` directory)
- Did Phone SDR run at 10 AM? (check `calls/` directory)
- Did Text SDR run at 12 PM? (check `sms/` directory)
- Did Sequence Manager run? (check `pipeline/status.json` timestamp)

### Hot Lead Detection
- Any prospects with status "hot" or "handed_off"?
- Any positive email replies in Smartlead?
- Any positive SMS replies in Sendblue?
- Any qualified calls from Phone SDR?

### Anomaly Detection
- Is today's lead count significantly different from average?
- Is the open rate dropping? (possible deliverability issue)
- Are any agents producing no output? (possible crash)

## Output (only if action needed)

If hot lead detected → DM Justin on Slack + Telegram immediately:
```
HOT LEAD — [Name] at [Company]
ICP Score: [X]/100 (Tier [A/B])
What happened: [replied to email / engaged on SMS / qualified call]
Next step: [Call them / Send calendar link / Wait for callback]
```

If agent failure detected → Post to Slack #alerts:
```
SDR ALERT — [Agent name] did not run at [expected time]
Last successful run: [timestamp]
Action: investigating
```

If everything normal → no notification (silent success).
