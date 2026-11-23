# Mobile UI evaluation evidence

This directory records reproducible evidence for six independent skill executions and their guided corrective follow-ups. The artifacts are evidence of those runs, not production samples or a statistical benchmark.

## Result snapshot

- Baseline: **71/88 (80.68%)** across 44 criteria.
- Final follow-up: **83/88 (94.32%)** across 44 criteria.
- The change reflects actual observed gaps and guided corrections in scenarios 1, 3, and 4; it is not a clean one-shot success rate or a causal model comparison.
- Follow-up test evidence is categorized as 4 Flutter widget tests, 4 Swift tests, 7 Android JVM logic tests, and 2 Node logic tests — 17 tests total, not 17 UI tests. Native package checks and three installer test cases are reported separately.

## Method

- Baseline configuration: `gpt-5.6-terra`, medium reasoning effort.
- Six separate scenarios were executed against the baseline skill package and graded against [`runs/2026-11-23/baseline/rubric.json`](runs/2026-11-23/baseline/rubric.json).
- The baseline score is an evidence-bounded source/spec review. A score is not a visual-runtime, production-readiness, or device-compatibility certification.
- Scenario 5 follow-up work used `gpt-5.6-luna`, medium reasoning effort. Because the model changed, it is not a controlled success-rate comparison with the baseline. The follow-up artifacts document before/after guidance changes; they are not a causal or statistical success-rate estimate.
- `check_evidence.py` is a stored-evidence integrity checker, not a benchmark runner. It makes no remote calls, model calls, platform installs, agent reruns, native UI tests, or runtime claims. It verifies rubric IDs, score arithmetic, copied artifact hashes, fixture hashes, and the unchanged scenario-2 audit input.

Run it from the repository root:

```bash
python3 evals/check_evidence.py
```

## Evidence limits

The grading mixes static source/spec review with the tests that were actually available for each scenario. Flutter widget/typecheck results, Swift typecheck results, and Node logic tests are recorded where present; they do not establish Android runtime behavior. No Android emulator, Compose build, renderer, screenshot review, contrast measurement, VoiceOver session, or TalkBack session is implied where the reports say source/spec only.

Platform command outcomes are evidence from the recorded baseline runs and are preserved in the scenario responses and regression report/log. They are not rerun by `check_evidence.py`.

The scenario-5 `regression/verify-token-preservation.mjs` check is intentionally fixture-scoped: it evaluates the supplied `src/theme.ts` plus protected action/shell/test files. It fails against the baseline's `radius.control` 8→12 change and passes against the follow-up output; it does not prove preservation in an arbitrary application.

The reports record observed gaps, including the scenario-1 blocker and runtime reproduction, source-level Compose defects in scenario 4, the scenario-6 chart-direction contradiction, and limitations of the Node-only scenario-5 tests. The final score does not erase those evidence boundaries.

## Layout

- `runs/2026-11-23/baseline/` — copied scenario inputs, outputs, rubric, scorecard, and hash manifests.
- `runs/2026-11-23/baseline/fixtures/` — supplied React Native fixture inputs.
- `runs/2026-11-23/baseline/scenario-1/assets/fonts/` — the supplied Cairo font and its OFL provenance.
- `runs/2026-11-23/regression/` — the focused onboarding regression test, curated summary, and unfiltered raw reproduction log; the full app checkout is intentionally not duplicated.
- `runs/2026-11-23/followup/` — finalized individual reruns, final scorecard, raw Flutter/Swift/React Native/Android command logs, corrective-iteration notes, and exact skill-source hashes. The Android evidence is compile plus JVM logic tests only; it contains no device UI claim.
- `runs/2026-11-23/iterations/` — initial rerun attempts retained to show the process was not a one-shot success.
