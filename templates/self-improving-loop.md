# Self-Improving Loop Template (Karpathy Pattern)

The COO and all sub-agents use this loop to get better over time without manual intervention.

---

## The Loop

```
OBSERVE → MEASURE → HYPOTHESIZE → TEST → KEEP/DISCARD → REPEAT
```

### Step 1: Observe
After every cycle (daily for SDR, weekly for COO), collect:
- What was the outcome? (meetings booked, tasks completed, issues resolved)
- What was the cost? (tokens, API calls, compute time)
- What went wrong? (errors, misses, false positives)
- What went right? (wins, efficiencies, catches)

### Step 2: Measure
Compare against baselines:
```
METRIC:          ___________________________________
THIS PERIOD:     ___________________________________
LAST PERIOD:     ___________________________________
BASELINE:        ___________________________________
TREND:           [ ] Improving  [ ] Flat  [ ] Declining
```

### Step 3: Hypothesize
Form ONE hypothesis about what to change:
```
HYPOTHESIS:      ___________________________________
EXPECTED IMPACT: ___________________________________
RISK LEVEL:      [ ] Low (reversible)  [ ] Medium  [ ] High
ROLLBACK PLAN:   ___________________________________
```

### Step 4: Test
Run the change as an A/B test or time-boxed experiment:
```
CONTROL:         [Current approach]
VARIANT:         [New approach]
SAMPLE SIZE:     [Minimum N before evaluating]
DURATION:        [Minimum days before evaluating]
SUCCESS METRIC:  ___________________________________
```

### Step 5: Keep or Discard
```
KEEP if:
  - Variant outperforms control by >= 5% on success metric
  - AND no regression on secondary metrics (deliverability, cost, errors)

DISCARD if:
  - Variant underperforms or shows no improvement
  - OR regression on any secondary metric

KEEP → Update baseline, document in pattern library, apply broadly
DISCARD → Revert, document what didn't work and why, try new hypothesis
```

---

## COO Self-Improvement Areas

| Area | Metric | Frequency |
|------|--------|-----------|
| Morning briefing | Justin action rate (did he act on items?) | Weekly |
| SDR monitoring | False positive rate on anomaly detection | Weekly |
| Daily report | Report completeness (did any section say "no data"?) | Daily |
| Hot lead detection | Time from positive signal to Justin notification | Per event |
| Cost optimization | Total cost trend (should be flat or declining) | Weekly |
| Error recovery | Mean time to recovery (MTTR) for self-healing events | Weekly |
| Proactive catches | Number of issues flagged before they became problems | Weekly |

## SDR Self-Improvement Areas

| Area | Metric | Frequency |
|------|--------|-----------|
| Email subject lines | Open rate | Weekly (50+ send minimum) |
| Email body templates | Reply rate | Weekly (50+ send minimum) |
| Call scripts | Connect rate, meeting conversion | Weekly (20+ call minimum) |
| SMS templates | Response rate | Weekly (50+ send minimum) |
| Lead scoring | Qualified rate per tier | Monthly |
| Prospect research | Personalization score vs reply rate | Monthly |

## Pattern Library Location
- Winning patterns: `improvements/patterns-winning.md`
- Anti-patterns: `improvements/patterns-losing.md`
- Experiment log: `improvements/experiments.jsonl`

## Rules
1. ONE change per experiment. Isolate variables.
2. Never skip the measurement step. Feelings are not data.
3. Document everything — future you needs the context.
4. If an experiment is inconclusive, increase sample size before discarding.
5. Review patterns before designing new experiments — don't repeat failures.
