# RB-09: Payment API Degradation or Brownout

## Trigger

High latency or elevated error rate without full regional failure.

## Immediate actions

1. Identify affected service, region, and dependency.
2. Enable circuit breakers for non-critical calls.
3. Shed low-priority traffic.
4. Scale affected service.
5. Roll back recent deployment if correlated.
6. Verify idempotency protection.

## Validation

- 5XX rate below threshold
- p99 latency below 800 ms
- No duplicate transaction submissions
