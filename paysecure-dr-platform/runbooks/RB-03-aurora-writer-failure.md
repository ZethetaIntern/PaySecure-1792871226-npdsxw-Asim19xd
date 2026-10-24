# RB-03: Aurora PostgreSQL Writer Failure

## Trigger

Aurora writer endpoint unhealthy or automatic failover event detected.

## Immediate actions

1. Confirm Aurora cluster and writer endpoint status.
2. Allow in-region automatic failover to complete.
3. If in-region failover fails, promote Hyderabad cluster.
4. Update global writer routing.
5. Pause non-critical batch jobs.

## Commands

```bash
python automation/failover.py --from-region ap-south-1 --to-region ap-south-2 --approve
```

## Validation

- New ledger writes succeed
- No duplicate settlement entries
- Reconciliation reports PASS

## Recovery

- Restore failed writer as reader
- Re-establish Global Database topology
- Perform controlled switchover back to Mumbai
