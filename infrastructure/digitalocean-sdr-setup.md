# SDR Workers on DigitalOcean — Setup Guide

## Why DigitalOcean?
Autonomous SDR agents are headless (no GUI needed). They run on cron schedules, process leads, send emails, make calls. A $37/mo DO droplet handles this easily. Plain Claude Code + cron replaces any wrapper framework.

## Manual Deploy

```bash
# 1. Create droplet via CLI
doctl compute droplet create sdr-team \
  --image ubuntu-24-04-x64 \
  --size s-4vcpu-8gb \
  --region nyc1 \
  --ssh-keys your-ssh-key-id

# 2. Get IP
doctl compute droplet list --format Name,PublicIPv4

# 3. SSH in
ssh root@your-droplet-ip

# 4. Install Node.js (via fnm)
curl -fsSL https://fnm.vercel.app/install | bash
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env)"
fnm install 20
fnm use 20

# 5. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 6. Clone and deploy SDR agents
git clone https://github.com/jbellsolutions/autonomous-sdr-agent.git
cd autonomous-sdr-agent

# Choose version:
# v1 (email + phone only):
cp -r v1-core/agents/ ~/sdr-workspace/agents/
crontab v1-core/cron/crontab.txt

# v2 (email + phone + SMS + CRM):
cp -r v2-full/agents/ ~/sdr-workspace/agents/
crontab v2-full/cron/crontab.txt

# 7. Create workspace directories
mkdir -p ~/sdr-workspace/{leads,calls,sequences,sms,crm,improvements,pipeline}

# 8. Configure API keys in each SOUL.md
nano ~/sdr-workspace/agents/prospector/SOUL.md
# ... etc

# 9. Test with 10 leads
# Drop test leads into leads/today.json and verify pipeline
```

## Running Agents with Claude Code + Cron

Each SDR agent runs via a cron-invoked shell script:

```bash
# Example crontab entry (agent runs at 6 AM ET daily)
0 6 * * 1-5 /root/sdr-workspace/scripts/run-agent.sh prospector >> /root/sdr-workspace/logs/prospector.log 2>&1

# run-agent.sh
#!/bin/bash
AGENT=$1
cd ~/sdr-workspace
claude -p --system-prompt "agents/$AGENT/SOUL.md" "Run your scheduled task now."
```

## COO Monitoring Access

The COO on the Mac Mini needs to read SDR output files. Set up SSH key access:

```bash
# On Mac Mini:
ssh-keygen -t ed25519 -C "coo-monitor"
ssh-copy-id root@sdr-droplet-ip

# Test:
ssh root@sdr-droplet-ip "cat ~/sdr-workspace/crm/metrics.json"
```

Add to your SSH config (`~/.ssh/config` on Mac Mini):
```
Host sdr-team
  HostName your-droplet-ip
  User root
  IdentityFile ~/.ssh/id_ed25519
```

Now the COO can: `ssh sdr-team "cat ~/sdr-workspace/pipeline/status.json"`

## Tailscale (Optional but Recommended)

Install Tailscale on the DO droplet for secure access without public SSH:
```bash
# On DO droplet:
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up
```

Now accessible via Tailscale hostname instead of public IP.
