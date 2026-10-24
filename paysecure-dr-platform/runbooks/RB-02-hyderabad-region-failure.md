# RB-02: Full Hyderabad Region Failure

## Trigger

Hyderabad region unavailable or readiness checks fail.

## Immediate actions

1. Declare SEV-1 if customer traffic is affected.
2. Confirm Mumbai writer and application health.
3. Shift all traffic to Mumbai.
4. Stop Hyderabad consumers and scheduled jobs.
5. Verify Kafka replication checkpoints.
6. Scale Mumbai to full peak capacity.

## Commands

```bash
python automation/failover.py --from-region ap-south-2 --to-region ap-south-1 --approve
python automation/reconcile.py --transaction-region ap-south-1 --ledger-region ap-south-1
```

## Recovery

- Rebuild Hyderabad from Terraform.
- Restore Aurora secondary, DynamoDB replica, and MSK replication.
- Resume Hyderabad reads first, then production traffic gradually.
