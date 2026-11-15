#!/bin/sh
set -eu
cat > /app/reconcile.py <<'PYFIX'
#!/usr/bin/env python3
import argparse
import csv
import json
from datetime import datetime, timezone
from decimal import Decimal, InvalidOperation


def parse_time(value):
    dt = datetime.fromisoformat(value.strip().replace("Z", "+00:00"))
    if dt.tzinfo is None:
        raise ValueError("Timestamp must contain timezone")
    return dt.astimezone(timezone.utc)


def reconcile(path):
    latest = {}
    with open(path, newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        if set(reader.fieldnames or []) != {"tx_id", "timestamp", "amount", "status"}:
            raise ValueError("Expected tx_id,timestamp,amount,status columns")
        for row in reader:
            try:
                txid = row["tx_id"].strip()
                timestamp = parse_time(row["timestamp"])
                amount = Decimal(row["amount"].strip())
                status = row["status"].strip().upper()
                if not txid or not amount.is_finite() or status not in {"VALID", "FAILED", "PENDING"}:
                    continue
            except (ValueError, KeyError, TypeError, InvalidOperation, OverflowError):
                continue
            if txid not in latest or timestamp > latest[txid][0]:
                latest[txid] = (timestamp, amount, status)
    valid = [amount for _, amount, status in latest.values() if status == "VALID"]
    failed = sum(status == "FAILED" for _, _, status in latest.values())
    total = sum(valid, Decimal("0"))
    return {"total_valid_amount": float(total), "valid_count": len(valid), "failed_count": failed}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("input_csv")
    args = parser.parse_args()
    print(json.dumps(reconcile(args.input_csv)))
PYFIX
