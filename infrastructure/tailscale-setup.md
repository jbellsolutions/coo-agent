# Tailscale Setup — Access Everything from Anywhere

## What It Does
Tailscale creates a secure mesh network between your devices. Access your Mac Mini's Paperclip dashboard, SSH into DO droplets, and reach any service — all from your phone, without exposing public ports.

## Install

### Mac Mini
```bash
brew install tailscale
# OR download from tailscale.com/download

tailscale up
# Follow the browser auth flow
```

### iPhone
1. App Store → search "Tailscale"
2. Install and sign in with same account

### DigitalOcean Droplets
```bash
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up
```

## What You Can Access

| Service | URL via Tailscale | From |
|---------|-------------------|------|
| Paperclip dashboard | `http://mac-mini:3100` | Phone, laptop, anywhere |
| Mac Mini SSH | `ssh mac-mini` | Any device |
| DO SDR droplet SSH | `ssh sdr-team` | Any device |
| Any local service | `http://mac-mini:PORT` | Any device |

## Free Tier
Tailscale free tier supports up to 100 devices and 3 users. More than enough.
