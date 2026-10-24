# RB-04: Aurora Database Split-Brain

## Trigger

Both regions behave as writer, conflicting ledger records appear, or reconciliation reports conflicts.

## Immediate actions

1. Declare SEV-1.
2. Activate transaction freeze switch.
3. Stop all application writers.
4. Snapshot Kafka topics, queues, and database state.
5. Identify authoritative writer using transaction IDs, timestamps, and reconciliation records.
6. Quiesce non-authoritative writer.
7. Reconcile conflicts using immutable event IDs.
8. Replay only validated non-duplicate events.

## Validation

- Ledger balances reconcile
- No duplicate transaction IDs
- Settlement totals match source events
- Finance and risk approve recovery

## Recovery

- Restore single-writer topology
- Resume read-only traffic first
- Resume writes gradually after sign-off
