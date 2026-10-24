import pytest

from automation.failover import FailoverError, failover


def test_rejects_non_indian_region():
    with pytest.raises(FailoverError):
        failover("us-east-1", "ap-south-2", approve=False)


def test_dry_run_does_not_raise(monkeypatch):
    monkeypatch.setattr("automation.failover.region_healthy", lambda region: True)
    monkeypatch.setattr("automation.failover.promote_aurora", lambda *args: None)
    monkeypatch.setattr("automation.failover.shift_traffic", lambda *args: None)

    failover("ap-south-1", "ap-south-2", approve=False)
