# PaySecure Multi-Region DR Platform

Infrastructure and automation for an active-active AWS Mumbai (`ap-south-1`) and Hyderabad (`ap-south-2`) disaster-recovery platform for PaySecure Gateway.

## Objectives

- 99.99% availability
- RPO under 1 minute
- RTO under 5 minutes
- India-only data residency
- Automated, auditable regional failover

## Components

- Terraform-style infrastructure modules
- Aurora Global Database failover automation
- DynamoDB Global Table configuration
- MSK/Kafka replication monitoring
- Route 53 Application Recovery Controller routing controls
- CloudWatch synthetic canaries and alarms
- Ledger reconciliation job
- 12 disaster-recovery runbooks

## Structure

```text
paysecure-dr-platform/
├── terraform/
├── automation/
├── runbooks/
├── monitoring/
├── docs/
└── tests/
```

## Deployment

```bash
cd terraform/envs/mumbai
terraform init
terraform plan -var-file=mumbai.tfvars
terraform apply -var-file=mumbai.tfvars

cd ../hyderabad
terraform init
terraform plan -var-file=hyderabad.tfvars
terraform apply -var-file=hyderabad.tfvars
```

## Failover

```bash
python automation/failover.py --from-region ap-south-1 --to-region ap-south-2 --approve
```

The failover controller performs readiness checks, promotes Aurora only when necessary, updates routing controls, and writes an immutable audit event.

## Testing

```bash
pytest -q
```
