# Arakoo Harbor RL Canary — Work in Progress

This repository contains a starter implementation of the reconcile-bug Harbor task. **It is not a completed take-home submission.** No verified Harbor baseline/ablation trials, trajectories, or video are included yet.

## Goal
Build a CSV payment reconciler with three intentional bugs, a correct reference solution, a verifier with dense rewards, and a demonstrated anti-cheat check. Run six real model trials and document their outcomes before submission.

## Required evidence
- Three baseline `terminus-2` runs and three controlled ablation runs, with real `result.json` and `trajectory.json` files.
- A results table containing measured binary/dense scores and group-relative advantages.
- Exported AI coding transcripts and an unedited five-minute Loom demonstration.

## Setup
Use Python 3.12, Docker, `uv tool install harbor`, and the official Harbor task examples. Validate `nop` (expected 0) and `oracle` (expected 1) locally. Never commit API keys.

**Status:** Project publication in progress. No fabricated scores or logs are provided.

## Verified workflow evidence (16 November 2026)

- [Latest Harbor Gemini Trials run #43752553793](https://github.com/Junaithansar/harbor-rl-canary-Junaithansar/actions/runs/43752553793): **failed**, as intended by the stricter exception gate. All three attempted baseline trials returned exceptions (one `AgentTimeoutError`, two `RateLimitError`), so **0/3 valid baseline trials** can be counted. The raw failure artifact is attached to the run; it is **not** successful evaluation evidence.
- [Latest smoke-test run #43752553750](https://github.com/Junaithansar/harbor-rl-canary-Junaithansar/actions/runs/43752553750): passed. This does not establish that the six agent trials are complete.
- Gemini API reported HTTP 429 for the free-tier request quota (20 requests/day for the configured model), with a retry interval of approximately 11 hours 53 minutes at 2026-11-15 20:06 UTC. Verify quota availability before retrying; repeated immediate reruns are not useful.
- **Remaining:** three exception-free baseline trials, three controlled ablation trials, verifier rewards, group-relative advantage calculations, exported transcripts, and a verified demonstration-video link. No valid trial results or video are claimed here.

Do not infer trial success from a green workflow alone. Inspect every `result.json` for `exception_info`, verify rewards, and retain the matching trajectories.

## Retry evidence — 16 November 2026, 16:02 IST

- [Harbor Gemini Trials run #43752553793, attempt 2](https://github.com/Junaithansar/harbor-rl-canary-Junaithansar/actions/runs/43752553793) **failed** after about 61 minutes of baseline execution. All three `terminus-2` baseline trials ended with `AgentTimeoutError`; rewards were `0.0` but are **invalid as successful evaluation evidence**.
- Job logs record Gemini HTTP 503 `UNAVAILABLE` (high model demand) and a LiteLLM read timeout after 600 seconds. This retry did **not** establish that Gemini quota is the only blocker. Do not count or relabel the trials as valid.
- [Raw attempt-2 artifact](https://github.com/Junaithansar/harbor-rl-canary-Junaithansar/actions/runs/43752553793/artifacts/14216972710) is retained (42,087 bytes, 38 files). It is failure/debug evidence, not proof of successful trajectories.
- Verified totals remain **0/3 baseline, 0/3 ablation**. Controlled ablation, group-relative advantage analysis, coding transcripts and verified unedited demo video are still missing. Next retry should first confirm model availability and quota, and preferably use a tested compatible model rather than blindly rerunning a 60-minute timeout.
