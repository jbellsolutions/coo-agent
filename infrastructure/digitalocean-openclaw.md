# OpenClaw on DigitalOcean — Worker Agent Deployment

## Why DigitalOcean?
OpenClaw SDR agents are headless (no GUI needed). They run on cron schedules, process leads, send emails, make calls. A $37/mo DO droplet handles this easily.

## Option A: One-Click Deploy (Recommended)

1. Go to [DigitalOcean Marketplace](https://marketplace.digitalocean.com)
2. Search for "OpenClaw"
3. Click "Create Droplet"
4. Select: **8GB RAM / 4 vCPU** ($48/mo) or **4GB RAM / 2 vCPU** ($24/mo for starter)
5. Region: NYC1 (closest to ET timezone)
6. Click "Create"
7. SSH in and deploy your agents

## Option B: Manual Deploy

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

# 4. Install OpenClaw
curl -fsSL https://openclaw.com/install.sh | bash

# 5. Clone and deploy SDR agents
git clone https://github.com/jbellsolutions/openclaw-sdr-agent.git
cd openclaw-sdr-agent

# Choose version:
# v1 (email + phone only):
cp -r v1-core/agents/ ~/openclaw-workspace/agents/
crontab v1-core/cron/crontab.txt

# v2 (email + phone + SMS + CRM):
cp -r v2-full/agents/ ~/openclaw-workspace/agents/
crontab v2-full/cron/crontab.txt

# 6. Create workspace directories
mkdir -p ~/openclaw-workspace/{leads,calls,sequences,sms,crm,improvements,pipeline}

# 7. Configure API keys in each SOUL.md
nano ~/openclaw-workspace/agents/prospector/SOUL.md
# ... etc

# 8. Test with 10 leads
# Drop test leads into leads/today.json and verify pipeline
```

## COO Monitoring Access

The COO on the Mac Mini needs to read SDR output files. Set up SSH key access:

```bash
# On Mac Mini:
ssh-keygen -t ed25519 -C "coo-monitor"
ssh-copy-id root@sdr-droplet-ip

# Test:
ssh root@sdr-droplet-ip "cat ~/openclaw-workspace/crm/metrics.json"
```

Add to your SSH config (`~/.ssh/config` on Mac Mini):
```
Host sdr-team
  HostName your-droplet-ip
  User root
  IdentityFile ~/.ssh/id_ed25519
```

Now the COO can: `ssh sdr-team "cat ~/openclaw-workspace/pipeline/status.json"`

## Tailscale (Optional but Recommended)

Install Tailscale on the DO droplet for secure access without public SSH:
```bash
# On DO droplet:
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up
```

Now accessible via Tailscale hostname instead of public IP.
