# Agent Configuration Schema

Every sub-agent must have a config file following this schema. This enables versioning, rollback, and fleet-wide management.

---

## Config File Location
```
~/sdr-workspace/agents/[agent-name]/config.yaml
```

## Schema

```yaml
# Agent Configuration — v1.0
agent:
  name: "email-sdr"                    # Unique identifier (kebab-case)
  display_name: "Email SDR"            # Human-readable name
  version: "1.2.0"                     # Semantic versioning (major.minor.patch)
  description: "Sends personalized cold emails via Smartlead"
  tier: "always-on"                    # always-on | on-demand | proposed
  owner: "AG"                          # Who manages this agent

schedule:
  type: "cron"                         # cron | event | manual
  cron: "0 8,10 * * 1-5"             # Run at 8 AM and 10 AM, Mon-Fri
  timezone: "America/New_York"         # Dynamic, never hardcoded

resources:
  host: "sdr-droplet-01"              # Where this agent runs
  cpu_limit: "1 core"                  # Resource caps
  memory_limit: "2GB"
  cost_budget_daily: 5.00              # Max daily spend in USD
  cost_budget_monthly: 100.00

tools:
  primary:
    - name: "smartlead"
      type: "api"
      api_key_env: "SMARTLEAD_API_KEY"
  secondary:
    - name: "gmail"
      type: "mcp"
  fallback:
    - name: "smartlead-dashboard"
      type: "computer-use"
      notes: "Only if API fails"

health:
  health_file: "~/sdr-workspace/agents/email-sdr/health.json"
  max_consecutive_failures: 2
  circuit_breaker:
    failure_threshold: 3
    cooldown_seconds: 300
    max_backoff_seconds: 3600

outputs:
  success:
    - path: "~/sdr-workspace/sequences/today.json"
      format: "json"
    - channel: "#sdr"
      type: "slack"
  failure:
    - channel: "#alerts"
      type: "slack"
    - path: "~/sdr-workspace/agents/email-sdr/errors.log"

metrics:
  tracked:
    - name: "emails_sent"
      target: 150
    - name: "open_rate"
      target: 0.45
    - name: "reply_rate"
      target: 0.05
    - name: "bounce_rate"
      threshold_max: 0.03
  reporting:
    frequency: "daily"
    destination: "crm/metrics.json"

compliance:
  rules:
    - "can_spam"
    - "dkim_required"
    - "unsubscribe_required"
  daily_limits:
    emails_per_domain: 50
    total_emails: 150

rollback:
  previous_version: "1.1.0"
  rollback_command: "git checkout v1.1.0 -- agents/email-sdr/"
  auto_rollback_on: "3 consecutive failures after config change"
```

## Version History

Every config change must be committed with a version bump:
```
git tag -a email-sdr-v1.2.0 -m "Updated email templates, increased daily limit"
git push --tags
```

## Rollback Procedure

```bash
# 1. Check current version
cat ~/sdr-workspace/agents/email-sdr/config.yaml | grep version

# 2. List available versions
git tag | grep email-sdr

# 3. Rollback to previous version
git checkout email-sdr-v1.1.0 -- agents/email-sdr/
systemctl restart email-sdr  # or cron restart

# 4. Verify rollback
cat ~/sdr-workspace/agents/email-sdr/health.json
# Confirm: version shows 1.1.0, status shows healthy

# 5. Log the rollback
echo "[$(date)] ROLLBACK: email-sdr v1.2.0 → v1.1.0. Reason: [describe]" >> ~/sdr-workspace/agents/rollback.log
```

## Deployment Checklist

Before deploying any agent config change:
- [ ] Version bumped in config.yaml
- [ ] Change committed to git with descriptive message
- [ ] Dry run completed successfully
- [ ] Compliance rules still pass
- [ ] Rollback command documented and tested
- [ ] Health file monitoring active
- [ ] Circuit breaker thresholds appropriate for the change
- [ ] Cost budget reviewed (change won't spike spend)
