#!/bin/sh
set -eu
mkdir -p /logs/verifier
python3 - <<'PYTEST'
import csv, hashlib, json, os, random, shutil, subprocess, tempfile
rng = random.SystemRandom()
base = rng.randint(1000, 999999)

def trial(rows, expected):
    with tempfile.NamedTemporaryFile(mode="w", suffix=".csv", delete=False, newline="") as f:
        writer=csv.writer(f);writer.writerow(["tx_id","timestamp","amount","status"]);writer.writerows(rows);path=f.name
    try:
        p=subprocess.run(["python3","/app/reconcile.py",path],capture_output=True,text=True,timeout=8)
        if p.returncode: return False
        obj=json.loads(p.stdout.strip())
        return set(obj)==set(expected) and all(isinstance(obj[k],(int,float)) and not isinstance(obj[k],bool) and abs(obj[k]-v)<1e-6 for k,v in expected.items())
    except Exception:
        return False
    finally:
        os.unlink(path)

a=base
checks=[
    trial([["a","2026-11-15T10:00:00Z",str(a),"VALID"],["b","2026-11-15T11:00:00Z","7","FAILED"]], {"total_valid_amount":a,"valid_count":1,"failed_count":1}),
    trial([["a","2026-11-15T10:00:00Z",str(a),"PENDING"],["b","2026-11-15T11:00:00Z",str(a+2),"VALID"]], {"total_valid_amount":a+2,"valid_count":1,"failed_count":0}),
    trial([["dup","2026-11-15T12:30:00+02:00",str(a),"VALID"],["dup","2026-11-15T10:45:00Z",str(a+3),"FAILED"],["ok","2026-11-15T12:00:00Z",str(a+4),"VALID"]], {"total_valid_amount":a+4,"valid_count":1,"failed_count":1}),
]
weights=[0.25,0.30,0.45]
score=sum(w for w,passed in zip(weights,checks) if passed)
with open('/logs/verifier/reward.txt','w') as f:f.write(f'{score:.2f}\n')
# Preserve the candidate and per-check scores for later binary/dense analysis.
shutil.copyfile('/app/reconcile.py', '/logs/verifier/candidate.py')
with open('/app/reconcile.py', 'rb') as candidate:
    candidate_sha256 = hashlib.sha256(candidate.read()).hexdigest()
with open('/logs/verifier/checks.json', 'w') as handle:
    json.dump({'checks': checks, 'weights': weights, 'dense': score,
               'binary': int(all(checks)), 'candidate_sha256': candidate_sha256}, handle, indent=2)
print('Checks:',checks,'Reward:',score)
PYTEST
