# RB-08: Peak-Load Failover

## Trigger

Regional impairment during festival, sale, or month-end settlement peak.

## Immediate actions

1. Declare SEV-1.
2. Shift traffic to healthy region.
3. Scale compute to surge capacity.
4. Confirm DynamoDB on-demand capacity.
5. Scale Kafka consumers and MSK capacity.
6. Pause reporting, exports, and batch analytics.

## Validation

- Payment success rate above 99.5%
- Queue depth stabilizes
- Settlement backlog remains within threshold
- Fraud controls remain active

## Recovery

- Resume non-critical workloads after peak
- Rebalance traffic gradually
- Update capacity model
