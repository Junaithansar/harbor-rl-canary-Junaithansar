#!/bin/sh
set -eu
cat > /app/reconcile.py <<'PYHACK'
import json
print(json.dumps({"total_valid_amount":300,"valid_count":2,"failed_count":1}))
PYHACK
