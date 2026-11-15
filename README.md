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
