from automation.reconcile import reconcile


def test_reconcile_detects_missing_ledger_entry(monkeypatch):
    monkeypatch.setattr(
        "automation.reconcile.load_transaction_ids",
        lambda table, region: {"txn-1", "txn-2"},
    )

    def fake_ledger(table, region):
        return {"txn-1"} if table == "paysecure-ledger" else {"txn-1", "txn-2"}

    monkeypatch.setattr(
        "automation.reconcile.load_transaction_ids",
        fake_ledger,
    )

    result = reconcile("ap-south-1", "ap-south-2")

    assert result["status"] == "FAIL"
    assert result["missing_in_ledger"] == ["txn-2"]
