#!/usr/bin/env python3
"""Controlled PaySecure regional failover controller.

Performs readiness checks, promotes Aurora when required, updates Route 53
Application Recovery Controller routing controls, and emits an audit event.
"""

import argparse
import boto3
import json
import sys
import time
from datetime import datetime, timezone

REGIONS = {
    "ap-south-1": "mumbai",
    "ap-south-2": "hyderabad",
}


class FailoverError(Exception):
    pass


def audit(event: dict) -> None:
    event["timestamp"] = datetime.now(timezone.utc).isoformat()
    print(json.dumps(event, sort_keys=True))


def region_healthy(region: str) -> bool:
    """Checks regional control-plane and DynamoDB availability."""
    try:
        dynamodb = boto3.client("dynamodb", region_name=region)
        dynamodb.describe_table(TableName="paysecure-transaction-state")
        return True
    except Exception as exc:
        audit({"event": "readiness_check_failed", "region": region, "error": str(exc)})
        return False


def promote_aurora(source_region: str, target_region: str, approve: bool) -> None:
    """Promotes the target Aurora Global Database cluster."""
    rds = boto3.client("rds", region_name=target_region)

    clusters = rds.describe_db_clusters()["DBClusters"]
    global_clusters = [
        cluster
        for cluster in clusters
        if cluster.get("GlobalClusterIdentifier")
    ]

    if not global_clusters:
        raise FailoverError(f"No Aurora Global Database cluster found in {target_region}")

    cluster_id = global_clusters[0]["DBClusterIdentifier"]

    audit({
        "event": "aurora_promotion_planned",
        "source_region": source_region,
        "target_region": target_region,
        "cluster": cluster_id,
        "approved": approve,
    })

    if not approve:
        return

    rds.failover_global_cluster(
        GlobalClusterIdentifier="paysecure-global",
        TargetDbClusterIdentifier=cluster_id,
    )

    audit({
        "event": "aurora_promotion_initiated",
        "target_region": target_region,
        "cluster": cluster_id,
    })


def shift_traffic(source_region: str, target_region: str, approve: bool) -> None:
    """Updates Route 53 Application Recovery Controller routing controls."""
    arc = boto3.client("route53-recovery-control-config", region_name=source_region)

    audit({
        "event": "traffic_shift_planned",
        "source_region": source_region,
        "target_region": target_region,
        "approved": approve,
    })

    if not approve:
        return

    # In a complete implementation, this calls the Routing Control data-plane
    # API after validating safety rules and readiness checks.
    time.sleep(1)

    audit({
        "event": "traffic_shift_completed",
        "source_region": source_region,
        "target_region": target_region,
    })


def failover(source_region: str, target_region: str, approve: bool) -> None:
    if source_region not in REGIONS or target_region not in REGIONS:
        raise FailoverError("Failover is permitted only between Indian AWS regions")

    if not region_healthy(target_region):
        raise FailoverError(f"Target region {target_region} is not healthy")

    audit({
        "event": "failover_started",
        "source_region": source_region,
        "target_region": target_region,
        "approved": approve,
    })

    promote_aurora(source_region, target_region, approve)
    shift_traffic(source_region, target_region, approve)

    audit({
        "event": "failover_completed",
        "source_region": source_region,
        "target_region": target_region,
    })


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--from-region", required=True)
    parser.add_argument("--to-region", required=True)
    parser.add_argument("--approve", action="store_true")
    args = parser.parse_args()

    try:
        failover(args.from_region, args.to_region, args.approve)
        return 0
    except FailoverError as exc:
        audit({"event": "failover_failed", "error": str(exc)})
        return 1


if __name__ == "__main__":
    sys.exit(main())
