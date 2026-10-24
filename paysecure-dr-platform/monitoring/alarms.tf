resource "aws_cloudwatch_metric_alarm" "aurora_replication_lag" {
  alarm_name          = "paysecure-aurora-global-lag-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 5
  alarm_description   = "Aurora Global Database replication lag exceeded 5 seconds"
  treat_missing_data  = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "payment_error_rate" {
  alarm_name          = "paysecure-payment-5xx-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "5XXError"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Payment API 5XX error rate is elevated"
  treat_missing_data  = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "kafka_under_replicated" {
  alarm_name          = "paysecure-kafka-under-replicated-partitions"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnderReplicatedPartitions"
  namespace           = "AWS/Kafka"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Kafka has under-replicated partitions"
  treat_missing_data  = "breaching"
}
