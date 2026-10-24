# RB-12: Data Corruption or Erroneous Deployment

## Trigger

Bad release, incorrect migration, corrupted ledger entries, or wrong configuration.

## Immediate actions

1. Halt affected deployment pipeline.
2. Roll back to last known-good version.
3. Freeze affected data domain.
4. Identify affected time window and transaction IDs.
5. Restore using point-in-time recovery or immutable event replay.
6. Correct downstream systems using reconciliation reports.

## Validation

- Data integrity checks pass
- No duplicate or missing financial events
- Business owner approves resumed processing
