# RB-10: Settlement or Reconciliation Failure

## Trigger

Settlement mismatch, NPCI/bank acknowledgement gap, or ledger imbalance.

## Immediate actions

1. Freeze affected settlement batch.
2. Compare transactions, Kafka events, ledger entries, and acknowledgements.
3. Identify missing, duplicate, reversed, or unmatched records.
4. Escalate to finance, treasury, compliance, and bank partners.
5. Do not manually edit ledger records.

## Validation

- Zero unmatched high-value transactions
- Settlement totals match approved source records
- Finance sign-off recorded
