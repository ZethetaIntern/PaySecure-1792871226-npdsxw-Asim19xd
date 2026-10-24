# RB-11: Ransomware or Destructive Cyber Incident

## Trigger

Data encryption, unauthorized deletion, compromised credentials, or extortion.

## Immediate actions

1. Declare SEV-1 cyber incident.
2. Isolate accounts, VPCs, IAM roles, and workloads.
3. Revoke sessions and rotate credentials.
4. Preserve CloudTrail, VPC Flow Logs, EKS audit logs, and Kafka evidence.
5. Activate clean-room recovery account.
6. Restore only from validated immutable backups.
7. Notify legal, compliance, insurer, and regulators as required.

## Validation

- No persistence mechanisms remain
- Restored data passes integrity and reconciliation checks
- Security and compliance approve production re-entry
