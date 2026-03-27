# Mac Mini Always-On Setup

## Why Mac Mini?
Computer Use requires macOS + a screen. The Mac Mini stays on 24/7, running your COO agent, Paperclip dashboard, and ClaudeClaw bridge.

## Hardware Requirements
- Any Mac Mini (M1 or later recommended)
- 16GB RAM (8GB works but tight)
- Power connection (UPS recommended for stability)
- Display emulator dongle (if running headless — $10 on Amazon, search "HDMI dummy plug")

## Prevent Sleep

```bash
# Prevent ALL sleep
sudo pmset -a sleep 0
sudo pmset -a disablesleep 1
sudo pmset -a displaysleep 0

# Verify settings
pmset -g
```

## Auto-Login on Reboot

1. System Settings → Users & Groups → Login Options
2. Enable "Automatic Login" for your user
3. This ensures the Mac recovers from power outages

## Start Services on Boot

Create a launch agent for each service:

### Paperclip Auto-Start
```bash
cat > ~/Library/LaunchAgents/com.jbell.paperclip.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jbell.paperclip</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/pnpm</string>
        <string>dev</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/home/paperclip</string>
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
EOF

launchctl load ~/Library/LaunchAgents/com.jbell.paperclip.plist
```

### ClaudeClaw Auto-Start
```bash
cat > ~/Library/LaunchAgents/com.jbell.claudeclaw.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jbell.claudeclaw</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/node</string>
        <string>index.js</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/Users/home/claudeclaw</string>
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
EOF

launchctl load ~/Library/LaunchAgents/com.jbell.claudeclaw.plist
```

## Network
- Connect via Ethernet (not WiFi) for reliability
- Set a static IP on your local network
- Install Tailscale for remote access (see tailscale-setup.md)

## Monitoring
- Check Mac Mini is alive: `ping mac-mini.tailnet` from any device
- Check Paperclip: `curl http://mac-mini:3100/api/health`
- Logs: `/tmp/paperclip.log`, `/tmp/claudeclaw.log`
