# Compliance Monitoring Playbook

The COO ensures all outreach operations comply with federal, state, and platform-specific regulations. Non-compliance = fines, blacklists, and lost revenue.

---

## Regulatory Framework

### Federal (US)
| Regulation | Applies To | Key Requirements | Penalty |
|-----------|-----------|-----------------|---------|
| **CAN-SPAM** | Email | Opt-out honored in 10 days, physical address, no deceptive headers | $51,744/violation |
| **TCPA** | Calls + SMS | Prior express consent, DNC registry check, AI voice disclosure | $500-$1,500/violation |
| **FCC One-to-One Consent** | Calls + SMS | Individual consent per seller (not blanket) | Per violation fines |

### State-Specific (Critical)
| State | Regulation | Key Requirement | Effective |
|-------|-----------|-----------------|-----------|
| **Texas** | SB 140 | SMS counts as telephone solicitation, treble damages | Sept 2025 |
| **Virginia** | SB 1339 | SMS opt-out must be honored for 10 YEARS, $500/violation | Jan 2026 |
| **California** | CCPA/CPRA | Right to delete, opt-out of data sale, privacy notice | Active |
| **Florida** | New telemarketing rules | Enhanced DNC enforcement | 2025+ |

### Platform-Specific
| Platform | Limits | Enforcement |
|----------|--------|-------------|
| **LinkedIn** | 100 connections/week, 150 profile views/day, 50 messages/day | Account restriction → permanent ban |
| **Smartlead** | Per-domain sending limits, warmup schedules | Deliverability degradation |
| **Gmail** | 500 emails/day (personal), 2000/day (workspace) | Temporary suspension |

## Pre-Send Compliance Checks

### Email (Every Send)
```
BEFORE sending any email:
  [ ] 1. Physical mailing address in footer
  [ ] 2. Clear sender identification (no deceptive From/Subject)
  [ ] 3. Functioning unsubscribe link (one-click)
  [ ] 4. Not sending to anyone who opted out
  [ ] 5. Not sending to any address that bounced hard
  [ ] 6. SPF/DKIM/DMARC passing for sending domain
  [ ] 7. Content does not contain prohibited claims
  [ ] 8. Not exceeding domain daily send limit
```

### Phone Call (Every Call)
```
BEFORE making any call:
  [ ] 1. Number checked against National DNC Registry
  [ ] 2. Number checked against internal opt-out list
  [ ] 3. Number checked against state-specific DNC lists
  [ ] 4. Calling within permitted hours (8 AM - 9 PM recipient local time)
  [ ] 5. AI voice disclosure ready ("This call uses AI-generated voice")
  [ ] 6. Prior express consent documented (for TCPA)
  [ ] 7. Caller ID displaying valid, callback-capable number
```

### SMS (Every Message)
```
BEFORE sending any SMS:
  [ ] 1. Prior express written consent obtained
  [ ] 2. Number checked against opt-out list
  [ ] 3. Opt-out instructions included ("Reply STOP to unsubscribe")
  [ ] 4. Not sending outside permitted hours (8 AM - 9 PM local)
  [ ] 5. Not sending to landlines
  [ ] 6. Message identifies the sender
  [ ] 7. State-specific rules checked (TX: treble damages, VA: 10-year opt-out)
```

### LinkedIn (Every Action)
```
DAILY LIMITS (hard caps — never exceed):
  [ ] Connection requests: ≤20/day (conservative; platform limit ~100/week)
  [ ] Profile views: ≤100/day
  [ ] Direct messages: ≤30/day
  [ ] InMails: per subscription limit
  [ ] Post engagement (likes/comments): ≤50/day
  [ ] Content posts: ≤3/day

WEEKLY LIMITS:
  [ ] Total connection requests: ≤80/week
  [ ] Total DMs: ≤150/week
```

## Opt-Out Management

### Opt-Out Processing Rules
1. **Email opt-outs:** Process within 24 hours (CAN-SPAM allows 10 days, we do 24 hours)
2. **SMS opt-outs (STOP):** Process immediately, confirm with "You've been unsubscribed"
3. **Phone DNC requests:** Add to internal list immediately, never call again
4. **LinkedIn removal requests:** Remove from all sequences, do not re-add
5. **Virginia contacts:** Retain opt-out for 10 YEARS minimum

### Opt-Out Storage
```json
{
  "email": "contact@example.com",
  "phone": "+15551234567",
  "opt_out_channel": "email",
  "opt_out_date": "2026-03-28T14:30:00Z",
  "opt_out_method": "unsubscribe_link",
  "state": "VA",
  "retention_until": "2036-03-28",
  "suppress_all_channels": false
}
```

## Monitoring Dashboards

### Daily Compliance Check (COO — automated)
| Metric | Threshold | Action if Exceeded |
|--------|-----------|-------------------|
| Email bounce rate | >3% | Pause sends, investigate list quality |
| Email spam complaint rate | >0.1% | Pause sends, review content |
| Opt-out rate | >2% | Review messaging, adjust targeting |
| DNC match rate | >0% (should be 0 after filtering) | Halt all calls, investigate |
| LinkedIn restriction warnings | Any | Stop all LinkedIn automation |
| SMS opt-out rate | >5% | Review messaging and targeting |

### Weekly Compliance Report
Include in the weekly review:
```
COMPLIANCE STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━
Email: [compliant/warning/violation]
  - Bounce rate: [X]% (threshold: 3%)
  - Spam complaints: [X]% (threshold: 0.1%)
  - Opt-outs processed: [N] (all within 24h: [yes/no])

Phone: [compliant/warning/violation]
  - DNC violations: [N] (target: 0)
  - After-hours calls: [N] (target: 0)
  - AI disclosure included: [100%/X%]

SMS: [compliant/warning/violation]
  - Opt-outs processed: [N] (all immediate: [yes/no])
  - After-hours sends: [N] (target: 0)

LinkedIn: [compliant/warning/violation]
  - Daily limits exceeded: [N] days
  - Account restrictions: [none/warning/restricted]

Overall: [COMPLIANT / AT RISK / VIOLATION]
```

## Geographic Segmentation

The COO must segment contacts by jurisdiction and apply the strictest applicable rules:

| Contact Location | Email Rules | Phone Rules | SMS Rules |
|-----------------|-------------|-------------|-----------|
| US (general) | CAN-SPAM | TCPA + National DNC | TCPA + consent |
| Texas | CAN-SPAM | TCPA + state DNC | TCPA + SB 140 (treble damages) |
| Virginia | CAN-SPAM | TCPA + state DNC | TCPA + SB 1339 (10-year opt-out) |
| California | CAN-SPAM + CCPA | TCPA + state DNC + CCPA | TCPA + CCPA |
| EU/UK | GDPR (opt-in required) | GDPR | GDPR |
| Canada | CASL (opt-in required) | CASL | CASL |

**Default rule:** When contact location is unknown, apply the strictest US rules (currently Virginia/Texas).

## Audit Trail

Every outreach action must be logged:
```json
{
  "timestamp": "2026-03-28T10:30:00Z",
  "action": "email_sent",
  "contact_id": "abc123",
  "contact_email": "john@example.com",
  "contact_state": "VA",
  "compliance_checks_passed": ["can_spam", "opt_out_clear", "dkim_valid", "not_on_suppress_list"],
  "agent": "email-sdr",
  "campaign_id": "camp_456",
  "template_version": "v2.3"
}
```

Retain audit logs for minimum 4 years (statute of limitations for TCPA).
