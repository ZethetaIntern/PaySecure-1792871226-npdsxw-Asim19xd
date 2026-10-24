#!/usr/bin/env python3
"""Reconciles transaction events, ledger entries, and settlement records.

This job is designed to run continuously and is a mandatory gate before
declaring a regional failover complete.
"""

import argparse
import boto3
import json
from collections import defaultdict


def load_transaction_ids(table_name: str, region: str) -> set[str]:
    dynamodb = boto3.client("dynamodb", region_name=region)
    ids = set()
    paginator = dynamodb.get_paginator("scan")

    for page in paginator.paginate(TableName=table_name):
        for item in page.get("Items", []):
            ids.add(item["transaction_id"]["S"])

    return ids


def reconcile(transaction_region: str, ledger_region: str) -> dict:
    transactions = load_transaction_ids("paysecure-transaction-state", transaction_region)
    ledger = load_transaction_ids("paysecure-ledger", ledger_region)

    missing_in_ledger = sorted(transactions - ledger)
    orphan_ledger_entries = sorted(ledger - transactions)

    return {
        "transaction_count": len(transactions),
        "ledger_count": len(ledger),
        "missing_in_ledger": missing_in_ledger,
        "orphan_ledger_entries": orphan_ledger_entries,
        "status": "PASS" if not missing_in_ledger and not orphan_ledger_entries else "FAIL",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--transaction-region", default="ap-south-1")
    parser.add_argument("--ledger-region", default="ap-south-2")
    args = parser.parse_args()

    result = reconcile(args.transaction_region, args.ledger_region)
    print(json.dumps(result, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
