# RB-07: Kafka Cross-Region Replication Failure

## Trigger

MirrorMaker 2 lag, connector failure, or replication checkpoint gap.

## Immediate actions

1. Confirm source and target MSK health.
2. Restart replication connector or MirrorMaker 2 task.
3. Identify last replicated offset.
4. Calculate replication gap.
5. Prioritize financial topics if failover is imminent.

## Validation

- Replication lag below threshold
- Checkpoint offsets match source topics
- Reconciliation confirms no missing financial events

## Recovery

- Resume normal replication
- Backfill missed events using idempotent consumers
