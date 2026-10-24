# RB-05: DynamoDB Global Table Conflict or Replication Failure

## Trigger

Replication lag, item conflict, or regional DynamoDB impairment.

## Immediate actions

1. Identify affected table and partition keys.
2. Stop writers for mutable items.
3. Determine authoritative record using transaction ID and event version.
4. Run controlled backfill.
5. Verify idempotency records before enabling retries.

## Validation

- No duplicate webhook deliveries
- Transaction state transitions remain monotonic
- Fraud counters rebuilt from immutable events

## Recovery

- Re-enable Global Table replication
- Resume writes gradually
- Correct data model to prevent recurrence
