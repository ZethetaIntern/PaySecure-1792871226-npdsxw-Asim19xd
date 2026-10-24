# RB-06: Kafka Broker or Partition Failure

## Trigger

Under-replicated partitions, offline partitions, broker failure, or rising consumer lag.

## Immediate actions

1. Identify affected topic and partition.
2. Confirm broker and replica health.
3. Verify `min.insync.replicas=2`.
4. Replace unhealthy broker if required.
5. Redirect consumers to healthy region.
6. Move repeated failures to dead-letter topic.

## Validation

- Under-replicated partitions return to zero
- Consumer lag decreases
- Reconciliation matches event and ledger counts

## Recovery

- Restore replication factor 3
- Replay dead-letter events after root-cause fix
