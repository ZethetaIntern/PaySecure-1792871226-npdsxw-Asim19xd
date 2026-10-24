# Compliance Mapping

## RBI Master Direction

- DR facility in a separate AWS Indian region
- Reconciliation controls to prevent transaction or audit-trail loss
- BCP and cyber-incident scenarios
- At least half-yearly recovery testing for critical payment systems
- Immutable audit logs and incident timelines

## PCI-DSS v4.0

- Private subnets and restricted security groups
- IAM Identity Center, MFA, least privilege
- KMS encryption at rest and TLS in transit
- CloudTrail, CloudWatch, GuardDuty, and Security Hub
- Image and dependency scanning
- Change control through Terraform and CI/CD

## NPCI UPI Technical Standards

- Unique transaction identifiers and idempotency keys
- End-to-end correlation IDs
- Reconciliation with NPCI and bank acknowledgements
- Regional processing capacity and latency controls
- Incident escalation and communication procedures

## India Data Localization

- Production workloads restricted to ap-south-1 and ap-south-2
- AWS Organizations SCP prevents non-Indian production regions
- Cross-region replication remains within India
- Non-production uses synthetic or tokenized data
