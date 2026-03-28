# Monthly Strategy Review — 1st of Month, 9:00 AM ET

## Purpose
Strategic-level review of business operations, GTM performance, and forward-looking recommendations. This is the COO's most strategic output — written for CEO decision-making.

## Data Sources

### Pipeline & Revenue (MCP)
1. **GoHighLevel** → 30-day pipeline snapshot: leads created, qualified, meetings, proposals, closed deals
2. **ClickUp** → project completion rates, overdue trends, capacity utilization
3. **Google Calendar** → meeting volume trends (internal vs external, sales vs ops)

### SDR & Outreach (SSH + MCP + Computer Use)
4. **SDR metrics** → 30-day aggregate: total outreach, response rates, meetings booked, cost per meeting
5. **Smartlead** → email deliverability trends, domain reputation
6. **A/B test results** → winning patterns from the month

### Financial (MCP + SSH)
7. **Cost tracking** → total operational costs broken down by: compute, API, tools, subscriptions
8. **Revenue data** → from GHL pipeline (closed deals × deal value)

### Competitive (Web Research)
9. **Competitor scan** → pricing changes, new features, market positioning shifts
10. **Market trends** → industry news, regulatory changes, technology shifts

## Output Format

```
Monthly Strategy Review — [Month Year]

EXECUTIVE SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━
[3-sentence summary: what happened, what it means, what to do]

GTM PERFORMANCE
━━━━━━━━━━━━━━━━━━━━━━━━━
              This Month    Last Month    Target    Status
Leads:        [N]           [N]           [N]       [on/off track]
Qualified:    [N]           [N]           [N]       [on/off track]
Meetings:     [N]           [N]           [N]       [on/off track]
Proposals:    [N]           [N]           [N]       [on/off track]
Closed:       [N]           [N]           [N]       [on/off track]
Revenue:      $[X]          $[X]          $[X]      [on/off track]

Conversion Rates:
  Lead → Qualified: [X]% (target: [Y]%)
  Qualified → Meeting: [X]% (target: [Y]%)
  Meeting → Proposal: [X]% (target: [Y]%)
  Proposal → Close: [X]% (target: [Y]%)

Pipeline Velocity: [X] days avg (target: [Y] days)

CHANNEL ROI
━━━━━━━━━━━━━━━━━━━━━━━━━
Channel         Spend    Meetings    Cost/Meeting    ROI
Cold Email      $[X]     [N]         $[X]            [X]:1
Cold Call       $[X]     [N]         $[X]            [X]:1
SMS             $[X]     [N]         $[X]            [X]:1
LinkedIn        $[X]     [N]         $[X]            [X]:1
Newsletter      $[X]     [N]         $[X]            [X]:1

Recommendation: [Scale/Maintain/Reduce] [channel] because [data-backed reason]

COST ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━
Total Ops Cost: $[X] (budget: $[Y])
  Compute (DO): $[X]
  APIs/Tools:   $[X]
  LLM Tokens:   $[X]
  Subscriptions: $[X]

CAC (Customer Acquisition Cost): $[X]
ROAI (Revenue / AI Costs): [X]:1

COMPETITIVE LANDSCAPE
━━━━━━━━━━━━━━━━━━━━━━━━━
• [Competitor A]: [Notable change or no change]
• [Competitor B]: [Notable change or no change]
Market signal: [Any trend worth noting]

SELF-IMPROVEMENT RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━
Experiments run: [N]
Winners adopted: [N]
Losers discarded: [N]
Net improvement: [metric] improved by [X]% month-over-month

STRATEGIC RECOMMENDATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━
1. [High-impact recommendation with expected outcome]
2. [Medium-impact recommendation with expected outcome]
3. [Efficiency improvement with expected savings]

90-DAY FORECAST
━━━━━━━━━━━━━━━━━━━━━━━━━
Based on current pipeline and trends:
  Month +1: $[X] revenue (confidence: [H/M/L])
  Month +2: $[X] revenue (confidence: [H/M/L])
  Month +3: $[X] revenue (confidence: [H/M/L])
```

## Rules
- Lead with the executive summary. Justin should get the key takeaway in 10 seconds.
- Every recommendation must include the expected outcome and effort level.
- Never present data without context (what does this number mean? is it good or bad?).
- Use Opus model for this review — it requires strategic reasoning.
- If a metric is unmeasurable, say so and propose how to start measuring it.
