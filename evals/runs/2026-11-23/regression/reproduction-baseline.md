# Baseline reproduction

Scope: copied `scenario-1` into `repro-onboarding`; no baseline source files were edited. The following baseline hashes were identical before and after the reproduction:

- `lib/main.dart`: `7b70952a6fcf6dbcc608ab64677d7c354960fc07`
- `test/onboarding_test.dart`: `4b467d797ea574f97b90eadca6639ab018cd0516`
- `pubspec.yaml`: `fadf5af412c349b8540642d18c90a72c2ec75e4f`

Dependency reuse command: `/Users/bdc/flutter/bin/flutter pub get --offline` — exit 0.

Regression command: `/Users/bdc/flutter/bin/flutter test test/regression_baseline_test.dart` — exit 1. The added tests exist only in `repro-onboarding/test/regression_baseline_test.dart` and intentionally expose the following baseline behavior:

1. A throwing `AccountCreationService` causes an uncaught `StateError`; the loading state is not recovered, no actionable Arabic retry/error UI is rendered, and the test fails.
2. A controllable pending service is invoked only once after two submission attempts; the duplicate-submission regression test passed.
3. At 320 × 568 logical units and 2× text scale, all three steps put the primary action off-screen. Step 1 also raises `RenderFlex overflowed by 368 pixels on the bottom`. Measured primary-action bottoms: step 1 = 912, step 2 = 976, step 3/final = 927; all exceed 568.

No implementation fixes were applied.

## Independent scenario-5 token check

The source fixture is `fixtures/scenario-5/src/theme.ts`, where `radius.control` is `8`. The existing scenario output at `scenario-5/src/theme.ts` sets `radius.control` to `12`, and all three output primary screens consume that token. Therefore the existing output does **not** preserve the source control-radius token (8 → 12).
