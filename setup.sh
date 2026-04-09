#!/bin/bash
# ═══════════════════════════════════════════════════════
#  COO Agent — Interactive Setup
#  Run: ./setup.sh
#  This script walks you through the full setup step by step.
# ═══════════════════════════════════════════════════════

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}[STEP $1]${NC} $2"
}

print_warn() {
    echo -e "${YELLOW}[NOTE]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_done() {
    echo -e "${GREEN}[DONE]${NC} $1"
}

wait_for_enter() {
    echo ""
    echo -e "${YELLOW}Press ENTER when ready to continue...${NC}"
    read -r
}

ask_yes_no() {
    echo -e "${BOLD}$1 (y/n):${NC} "
    read -r answer
    [[ "$answer" =~ ^[Yy] ]]
}

# ═══════════════════════════════════════════════════════
#  INTRO
# ═══════════════════════════════════════════════════════

clear
print_header "AI Chief Operating Officer — Setup"

echo "This script will set up your always-on AI COO."
echo ""
echo "What gets installed:"
echo "  1. COO workspace (files, configs, directories)"
echo "  2. Paperclip (orchestration dashboard)"
echo "  3. Tailscale (remote access from phone)"
echo "  4. ClaudeClaw (Telegram chat bridge)"
echo "  5. Mac Mini always-on configuration"
echo "  6. MCP tool connections"
echo ""
echo "Prerequisites:"
echo "  - macOS (Computer Use requires it)"
echo "  - Claude Code installed (claude.ai/code)"
echo "  - Claude Pro or Max subscription"
echo "  - Node.js 20+ and pnpm"
echo ""

if ! ask_yes_no "Ready to start?"; then
    echo "Setup cancelled."
    exit 0
fi

# ═══════════════════════════════════════════════════════
#  STEP 1: Check Prerequisites
# ═══════════════════════════════════════════════════════

print_header "Step 1/7 — Checking Prerequisites"

# Check macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This setup requires macOS. Computer Use is macOS-only."
    exit 1
fi
print_done "macOS detected: $(sw_vers -productVersion)"

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_done "Node.js found: $NODE_VERSION"
else
    print_warn "Node.js not found. Installing via fnm..."
    if command -v fnm &> /dev/null; then
        fnm install 20
        fnm use 20
    else
        echo "Installing fnm (Fast Node Manager)..."
        curl -fsSL https://fnm.vercel.app/install | bash
        export PATH="$HOME/.local/share/fnm:$PATH"
        eval "$(fnm env)"
        fnm install 20
        fnm use 20
    fi
    print_done "Node.js installed: $(node --version)"
fi

# Check pnpm
if command -v pnpm &> /dev/null; then
    print_done "pnpm found: $(pnpm --version)"
else
    print_warn "pnpm not found. Installing..."
    npm install -g pnpm
    print_done "pnpm installed: $(pnpm --version)"
fi

# Check Claude Code
if command -v claude &> /dev/null; then
    print_done "Claude Code found"
else
    print_warn "Claude Code not detected in PATH."
    echo "Download from: https://claude.ai/code"
    echo "Install it, then re-run this script."
    if ! ask_yes_no "Continue anyway?"; then
        exit 1
    fi
fi

# Check git
if command -v git &> /dev/null; then
    print_done "git found: $(git --version)"
else
    print_error "git not found. Install Xcode command line tools: xcode-select --install"
    exit 1
fi

# Check gh CLI
if command -v gh &> /dev/null; then
    print_done "GitHub CLI found: $(gh --version | head -1)"
else
    print_warn "GitHub CLI (gh) not found. Installing..."
    brew install gh 2>/dev/null || echo "Install manually: https://cli.github.com"
fi

echo ""
print_done "All prerequisites checked."

# ═══════════════════════════════════════════════════════
#  STEP 2: Create COO Workspace
# ═══════════════════════════════════════════════════════

print_header "Step 2/7 — Creating COO Workspace"

COO_HOME="$HOME/coo-workspace"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_step "2.1" "Creating workspace at $COO_HOME"
mkdir -p "$COO_HOME"/{logs,reports,cache,daily}
mkdir -p "$COO_HOME"/agents/coo

print_step "2.2" "Copying COO agent files"
cp "$SCRIPT_DIR/CLAUDE.md" "$COO_HOME/CLAUDE.md"
cp "$SCRIPT_DIR/agents/coo/SOUL.md" "$COO_HOME/agents/coo/SOUL.md"
cp -r "$SCRIPT_DIR/heartbeats" "$COO_HOME/heartbeats"
cp -r "$SCRIPT_DIR/templates" "$COO_HOME/templates"
cp -r "$SCRIPT_DIR/rules" "$COO_HOME/rules"

print_done "COO workspace created at $COO_HOME"

echo ""
echo "Workspace structure:"
echo "  $COO_HOME/"
echo "  ├── CLAUDE.md              (COO rules & personality)"
echo "  ├── agents/coo/SOUL.md     (COO identity)"
echo "  ├── heartbeats/            (scheduled check instructions)"
echo "  ├── templates/             (report templates)"
echo "  ├── rules/                 (52 operational rules)"
echo "  ├── logs/                  (auto-generated logs)"
echo "  ├── reports/               (daily/weekly reports)"
echo "  ├── cache/                 (temporary data)"
echo "  └── daily/                 (daily memory files)"

# ═══════════════════════════════════════════════════════
#  STEP 3: Prevent Mac from Sleeping
# ═══════════════════════════════════════════════════════

print_header "Step 3/7 — Always-On Configuration"

echo "Your Mac needs to stay awake 24/7 for the COO to work."
echo "This prevents sleep, display sleep, and disk sleep."
echo ""

if ask_yes_no "Configure always-on settings?"; then
    sudo pmset -a sleep 0
    sudo pmset -a disablesleep 1
    sudo pmset -a displaysleep 0
    sudo pmset -a disksleep 0
    print_done "Sleep disabled. Mac will stay on 24/7."
    echo ""
    print_warn "If running headless (no monitor), get an HDMI dummy plug (~\$10 Amazon)."
    print_warn "Search: 'HDMI display emulator dongle'"
else
    print_warn "Skipped. You can configure this later:"
    echo "  sudo pmset -a sleep 0 disablesleep 1 displaysleep 0"
fi

# ═══════════════════════════════════════════════════════
#  STEP 4: Install Paperclip
# ═══════════════════════════════════════════════════════

print_header "Step 4/7 — Paperclip Dashboard"

echo "Paperclip gives you a visual dashboard for all your agents."
echo "Access from any device via browser."
echo ""

if ask_yes_no "Install Paperclip now?"; then
    PAPERCLIP_DIR="$HOME/paperclip"

    if [ -d "$PAPERCLIP_DIR" ]; then
        print_warn "Paperclip directory already exists at $PAPERCLIP_DIR"
        if ask_yes_no "Update it?"; then
            cd "$PAPERCLIP_DIR" && git pull && pnpm install
        fi
    else
        print_step "4.1" "Cloning Paperclip..."
        git clone https://github.com/paperclipai/paperclip.git "$PAPERCLIP_DIR"
        cd "$PAPERCLIP_DIR"

        print_step "4.2" "Installing dependencies..."
        pnpm install

        print_done "Paperclip installed at $PAPERCLIP_DIR"
    fi

    echo ""
    echo "To start Paperclip manually:"
    echo "  cd $PAPERCLIP_DIR && pnpm dev"
    echo "  Open: http://localhost:3100"
    echo ""

    if ask_yes_no "Set up Paperclip to auto-start on boot?"; then
        cat > "$HOME/Library/LaunchAgents/com.jbell.paperclip.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jbell.paperclip</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(which pnpm)</string>
        <string>dev</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$PAPERCLIP_DIR</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/paperclip.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/paperclip-error.log</string>
</dict>
</plist>
PLIST
        launchctl load "$HOME/Library/LaunchAgents/com.jbell.paperclip.plist" 2>/dev/null || true
        print_done "Paperclip will auto-start on boot."
    fi
else
    print_warn "Skipped. Install later: npx paperclipai onboard --yes"
fi

# ═══════════════════════════════════════════════════════
#  STEP 5: Install Tailscale
# ═══════════════════════════════════════════════════════

print_header "Step 5/7 — Tailscale (Remote Access)"

echo "Tailscale lets you access this Mac from your phone and other devices."
echo "Access Paperclip dashboard, SSH in, etc. — from anywhere."
echo ""

if command -v tailscale &> /dev/null; then
    print_done "Tailscale already installed."
    TAILSCALE_STATUS=$(tailscale status --json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('BackendState','unknown'))" 2>/dev/null || echo "unknown")
    echo "Status: $TAILSCALE_STATUS"
    if [ "$TAILSCALE_STATUS" != "Running" ]; then
        print_warn "Tailscale not connected. Run: tailscale up"
    fi
else
    if ask_yes_no "Install Tailscale now?"; then
        if command -v brew &> /dev/null; then
            brew install tailscale
            print_done "Tailscale installed."
            echo ""
            echo "Now run: tailscale up"
            echo "Then install Tailscale on your phone from the App Store."
        else
            echo "Download from: https://tailscale.com/download"
            wait_for_enter
        fi
    else
        print_warn "Skipped. Install later from: https://tailscale.com/download"
    fi
fi

# ═══════════════════════════════════════════════════════
#  STEP 6: ClaudeClaw (Telegram Bridge)
# ═══════════════════════════════════════════════════════

print_header "Step 6/7 — ClaudeClaw (Telegram Chat)"

echo "ClaudeClaw lets you chat with your COO via Telegram on your phone."
echo ""
echo "Prerequisites:"
echo "  - Telegram account"
echo "  - Telegram Bot token (from @BotFather)"
echo "  - Claude API key"
echo ""

if ask_yes_no "Set up ClaudeClaw now?"; then
    CLAUDECLAW_DIR="$HOME/claudeclaw"

    if [ -d "$CLAUDECLAW_DIR" ]; then
        print_warn "ClaudeClaw directory already exists at $CLAUDECLAW_DIR"
    else
        print_step "6.1" "Cloning ClaudeClaw..."
        git clone https://github.com/earlyaidopters/claudeclaw.git "$CLAUDECLAW_DIR" 2>/dev/null || {
            print_warn "Could not clone ClaudeClaw. You can set it up manually later."
            CLAUDECLAW_DIR=""
        }
    fi

    if [ -n "$CLAUDECLAW_DIR" ] && [ -d "$CLAUDECLAW_DIR" ]; then
        cd "$CLAUDECLAW_DIR"

        print_step "6.2" "Installing dependencies..."
        npm install 2>/dev/null || print_warn "npm install had issues — check manually"

        echo ""
        echo "To configure ClaudeClaw:"
        echo "  1. Open Telegram, message @BotFather, send /newbot"
        echo "  2. Save the bot token"
        echo "  3. Edit $CLAUDECLAW_DIR/.env:"
        echo "     TELEGRAM_BOT_TOKEN=your-token"
        echo "     ANTHROPIC_API_KEY=your-key"
        echo "     ALLOWED_USERS=your-telegram-user-id"
        echo ""
        echo "To find your Telegram user ID: message @userinfobot on Telegram"
        echo ""

        if ask_yes_no "Set up ClaudeClaw auto-start on boot?"; then
            cat > "$HOME/Library/LaunchAgents/com.jbell.claudeclaw.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jbell.claudeclaw</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(which node)</string>
        <string>index.js</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$CLAUDECLAW_DIR</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/claudeclaw.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/claudeclaw-error.log</string>
</dict>
</plist>
PLIST
            print_done "ClaudeClaw will auto-start on boot (after you configure .env)."
        fi
    fi
else
    print_warn "Skipped. Set up later — see infrastructure/claudeclaw-setup.md"
fi

# ═══════════════════════════════════════════════════════
#  STEP 7: MCP Connections
# ═══════════════════════════════════════════════════════

print_header "Step 7/7 — MCP Tool Connections"

echo "MCP tools give the COO instant access to your business tools."
echo "These connect through Claude Code's settings."
echo ""
echo "Available integrations:"
echo "  - ClickUp (task management)"
echo "  - Gmail (email)"
echo "  - Google Calendar (schedule)"
echo "  - Slack (team chat)"
echo "  - Notion (documentation)"
echo "  - Google Drive (files)"
echo "  - GoHighLevel (CRM)"
echo "  - Composio (982+ tools)"
echo ""

CLAUDE_SETTINGS="$HOME/.claude/settings.json"

if [ -f "$CLAUDE_SETTINGS" ]; then
    print_done "Claude settings file found at $CLAUDE_SETTINGS"
    echo "Your existing MCP connections will carry over."
else
    print_warn "No Claude settings file found."
    echo "Claude Code will create this automatically when you add MCP servers."
fi

echo ""
echo "To add MCP tools, open Claude Code and run:"
echo "  /mcp add clickup"
echo "  /mcp add gmail"
echo "  /mcp add google-calendar"
echo "  /mcp add slack"
echo ""
echo "Or see: infrastructure/mcp-connections.md for manual config."

# ═══════════════════════════════════════════════════════
#  DONE
# ═══════════════════════════════════════════════════════

print_header "Setup Complete"

echo -e "${GREEN}Your AI COO is ready.${NC}"
echo ""
echo "What was set up:"
echo "  ├── COO workspace: $COO_HOME"
if [ -d "$HOME/paperclip" ]; then
echo "  ├── Paperclip:     $HOME/paperclip (http://localhost:3100)"
fi
if [ -d "$HOME/claudeclaw" ]; then
echo "  ├── ClaudeClaw:    $HOME/claudeclaw (configure .env first)"
fi
echo "  ├── Always-on:     Sleep disabled"
echo "  └── MCP tools:     Configure via Claude Code"
echo ""
echo "Next steps:"
echo ""
echo "  1. Start Paperclip:"
echo "     cd ~/paperclip && pnpm dev"
echo ""
echo "  2. Open Claude Code in your COO workspace:"
echo "     cd $COO_HOME && claude"
echo ""
echo "  3. Test the COO — ask it:"
echo "     'Run the morning briefing heartbeat'"
echo ""
echo "  4. Set up Telegram (if not done):"
echo "     See infrastructure/claudeclaw-setup.md"
echo ""
echo "  5. Deploy SDR agents to DigitalOcean:"
echo "     See infrastructure/digitalocean-sdr-setup.md"
echo ""
echo "  6. Install Tailscale on your phone:"
echo "     App Store → Tailscale → sign in with same account"
echo ""
echo -e "${BOLD}Your COO is AG. Talk to it like a co-founder.${NC}"
echo ""
