# ClaudeClaw Setup — Telegram Bridge

## What It Does
ClaudeClaw bridges Telegram to Claude Code. Message your COO from your phone via Telegram — same agent, same tools, same memory.

## Prerequisites
- Telegram account
- Telegram Bot (create via @BotFather)
- Claude API key
- Mac Mini running 24/7

## Setup

### 1. Create Telegram Bot
1. Open Telegram, search for @BotFather
2. Send `/newbot`
3. Name: "AG COO" (or whatever you want)
4. Username: `jbell_coo_bot` (must be unique)
5. Save the API token BotFather gives you

### 2. Install ClaudeClaw

```bash
git clone https://github.com/earlyaidopters/claudeclaw.git ~/claudeclaw
cd ~/claudeclaw
npm install

# Configure
cp .env.example .env
```

### 3. Configure .env

```env
TELEGRAM_BOT_TOKEN=your-telegram-bot-token
ANTHROPIC_API_KEY=your-claude-api-key
ALLOWED_USERS=your-telegram-user-id
```

To find your Telegram user ID: message @userinfobot on Telegram.

### 4. Start

```bash
cd ~/claudeclaw
npm start
```

### 5. Test
Open Telegram → find your bot → send "What time is it?"

### 6. Auto-Start on Boot
See `mac-mini-setup.md` for LaunchAgent configuration.

## Usage Examples

```
You: "Good morning AG, what's on my plate today?"
AG: [Pulls from ClickUp, Gmail, Calendar, GitHub] "Here's your briefing..."

You: "Any hot leads from the SDR team?"
AG: [Checks SDR pipeline] "One hot lead — Jane at Acme Corp replied to email..."

You: "Book a call with her tomorrow at 2pm"
AG: [Creates Google Calendar event] "Done. Sent confirmation."

You: "How much are we spending on the SDR this month?"
AG: [Pulls cost data] "Total this month: $312. Breakdown: ..."
```

## Security Notes
- Only your Telegram user ID can interact with the bot (ALLOWED_USERS)
- API keys stay on the Mac Mini — never transmitted to Telegram
- Conversations happen through the Telegram API → your Mac Mini → Claude
