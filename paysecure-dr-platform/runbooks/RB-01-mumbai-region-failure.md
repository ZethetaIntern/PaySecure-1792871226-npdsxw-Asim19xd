# RB-01: Full Mumbai Region Failure

## Trigger

- Mumbai region unavailable
- Route 53 ARC marks Mumbai unhealthy
- Synthetic payment probes fail from Mumbai

## Impact

All Mumbai traffic must be served by Hyderabad.

## Immediate actions

1. Declare SEV-1 and assign incident commander.
2. Confirm Mumbai impairment and Hyderabad readiness.
3. Run readiness checks.
4. Promote Hyderabad Aurora Global Database cluster if Mumbai writer is unavailable.
5. Shift Route 53 ARC routing controls to Hyderabad.
6. Scale Hyderabad compute to full peak capacity.
7. Redirect Kafka consumers to replicated Hyderabad topics.

## Commands

```bash
python automation/failover.py --from-region ap-south-1 --to-region ap-south-2 --approve
python automation/reconcile.py --transaction-region ap-south-2 --ledger-region ap-south-2
```

## Validation

- Payment success rate above 99.5%
- p99 latency below 800 ms
- Kafka consumer lag decreasing
- Reconciliation status PASS
- No duplicate transaction IDs

## Communication

- Declare SEV-1 within 5 minutes
- Update status page within 10 minutes
- Notify banks, NPCI contact where applicable, and major merchants
- Provide hourly updates until closure

## Recovery

- Keep Hyderabad primary until reconciliation completes
- Replicate Hyderabad-generated data back to Mumbai
- Perform controlled traffic shift back after validation
