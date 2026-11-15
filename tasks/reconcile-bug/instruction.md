# Repair the payment reconciliation CLI

Fix `/app/reconcile.py` so `python /app/reconcile.py INPUT.csv` prints exactly one JSON object with keys `total_valid_amount`, `valid_count`, `failed_count`.

The CSV has columns `tx_id,timestamp,amount,status`. Status is case-insensitive and can be VALID, FAILED or PENDING. Ignore malformed rows (invalid amounts, timestamps, missing IDs or unsupported statuses). Timestamps must be ISO 8601 with explicit UTC offset or Z. For duplicate transaction IDs, keep only the row with the latest **absolute instant** (compare after timezone normalization), even when the newest row is FAILED or PENDING. If two timestamps are equal, retain the first row. Count VALID and FAILED only, ignoring PENDING. Sum valid amounts using decimal arithmetic to avoid binary floating-point errors. `total_valid_amount` must be a JSON number. Do not change the CSV files or verifier; repair the CLI implementation.
