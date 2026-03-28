# GTM Playbook — COO Operational Guide

This playbook defines how the COO supports and monitors go-to-market execution.

---

## The Funnel (COO Tracks Every Stage)

```
UNIVERSE → ICP MATCH → ENRICHED → OUTREACH → REPLY → QUALIFIED → MEETING → PROPOSAL → CLOSE
```

| Stage | Owner | COO Role | Key Metric |
|-------|-------|----------|------------|
| Universe | Prospector Agent | Monitor volume, ICP fit | Leads/day |
| ICP Match | Prospector Agent | Verify scoring accuracy | Match rate |
| Enriched | Research Agent | Check data completeness | Enrichment rate |
| Outreach | Email/Phone/Text SDR | Monitor delivery, volume | Sends/day, delivery rate |
| Reply | Sequence Manager | Flag positive replies | Reply rate |
| Qualified | COO + Justin | Score and route | Qualified rate |
| Meeting | Justin | Book and prep | Meetings/week |
| Proposal | Justin | Track follow-up | Proposal rate |
| Close | Justin | Track and forecast | Close rate, deal value |

## Daily GTM Monitoring (COO)

1. **Pipeline velocity check:** How many leads moved stages today?
2. **Bottleneck detection:** Where are leads getting stuck? (>3 days in any stage = flag)
3. **Channel health:** Is any outreach channel underperforming vs 7-day average?
4. **Hot lead routing:** Any positive signals → immediate notification to Justin
5. **Cost per stage:** Track spend attributed to each funnel stage

## Weekly GTM Actions (COO)

1. Compile channel ROI comparison table
2. Identify winning A/B test variants → apply broadly
3. Flag underperforming channels with recommendation (scale down, fix, or kill)
4. Update 30-day pipeline forecast
5. Propose new experiments based on patterns

## Monthly GTM Actions (COO)

1. Full funnel conversion analysis
2. CAC calculation by channel
3. ROAI (Revenue / AI operational costs)
4. Competitive positioning check
5. Strategic recommendations for next month

## GTM Metrics Dashboard

The COO maintains these metrics in the weekly and monthly reports:

### Primary Metrics
- **Meetings booked per week** — the north star for outbound
- **Cost per meeting** — efficiency measure
- **Pipeline value** — total $ in active pipeline
- **Close rate** — proposals → closed deals

### Secondary Metrics
- Email open rate, reply rate, bounce rate
- Call connect rate, conversation rate
- SMS response rate
- LinkedIn engagement rate (if active)
- Newsletter subscriber growth, open rate

### Health Metrics
- Email domain reputation (Smartlead)
- Phone number caller ID reputation
- LinkedIn account health (connection rate, response rate)
- CRM data hygiene (% of records with email, phone, company)

## Channel Playbooks

### Cold Email (Smartlead + SDR Fleet)
- Target: 150 emails/day per SDR agent
- Quality gate: 8-rule + 5-AI-criteria QA (0.7+ score)
- A/B test: Every new template runs 70/30 split
- Deliverability: Monitor daily, pause if bounce >3% or spam complaints >0.1%

### Cold Call (Retell AI + Phone SDR)
- Target: Based on calling hours and connect rates
- Script testing: New scripts get 20-call minimum before evaluation
- Voicemail: Track callback rate per voicemail script

### SMS (Twilio + Text SDR)
- Target: 150 messages/day per SDR
- Compliance: TCPA consent verification before every send
- Opt-out: Immediate removal, logged, never re-contacted via SMS

### LinkedIn (Computer Use + Manual)
- Target: 20 connection requests/day, 10 DMs/day (platform limits)
- Content: 3 posts/week minimum for authority building
- Monitoring: Track SSI score monthly

## ICP Scoring Model

| Factor | Weight | Scoring |
|--------|--------|---------|
| Company size | 20% | 1-50: 3pts, 51-200: 5pts, 201-1000: 4pts, 1000+: 2pts |
| Industry match | 25% | Exact ICP: 5pts, Adjacent: 3pts, Other: 1pt |
| Tech stack fit | 15% | Uses our stack: 5pts, Compatible: 3pts, Incompatible: 1pt |
| Funding/revenue | 15% | Series A+: 5pts, Seed: 3pts, Bootstrapped: 2pts |
| Decision maker | 15% | C-suite: 5pts, VP: 4pts, Director: 3pts, Manager: 2pts |
| Timing signals | 10% | Hiring for role: 5pts, Recent funding: 4pts, Job posting: 3pts |

**Tier Assignment:**
- 85-100: Tier A (all channels, highest priority)
- 70-84: Tier B (email + call + one more)
- 50-69: Tier C (email only, automated sequence)
- Below 50: Do not contact
