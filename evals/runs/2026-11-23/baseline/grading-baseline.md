# Independent grading baseline

Raw adherence score: **71/88 (80.68%)**. This is an evidence-bounded source/spec score, not a production-readiness or visual-runtime certification.

## Immediate findings

- **Scenario 1 — confirmed blocker and runtime failures:** `scenario-1/lib/main.dart:64-65` turns an unprovided privacy/data-minimization assurance into a product fact rather than marking it a placeholder. This triggers the documented “invented product claims” blocker. In an untouched copied fixture, a throwing service is uncaught with no retry/error UI; at 320×568 logical units and 2× text scale all primary CTAs are below the viewport (912/976/927 vs 568), and step one overflows by 368px.
- **Scenario 4 — source defects:** `scenario-4/CheckoutAddressScreen.kt:24` imports `androidx.compose.material3.dropdownMenuItem` (lowercase), which is not the Material 3 `DropdownMenuItem` symbol used at line 120. Line 170 also calls `Modifier.liveRegion(...)`; Compose uses `Modifier.semantics { liveRegion = ... }`. The source cannot compile as written. It also implements no autofill and unconditionally requires postal code for every country.
- **Scenario 6 — contradictory chart direction:** `scenario-6/OperationsDashboardSpec.md:41` specifies an old-to-new operational sequence right-to-left. `scenario-6/OperationsDashboard.kt:146` and `:153` map increasing point indices left-to-right. RTL layout direction does not reverse `Canvas` coordinates.
- **Scenario 1 — incomplete failure handling:** `scenario-1/lib/main.dart:74-80` represents loading and success but does not catch a rejected account-creation future, so it lacks the required final-submission error/recovery state.
- **Scenario 2 — hierarchy conclusion is implicit:** the audit usefully recommends a coherent list, but does not clearly answer whether hierarchy reorganization must happen before restyling (`scenario-2-response.md:49-56`).
- **Scenario 5 — scope and evidence limits:** the screens consistently use one tokenized control geometry, but no named component variants/sizes exist. More importantly, `theme.radius.control` changed from the existing 8 to 12 despite no documented defect. The passing `npm test` covers Node navigation/analytics logic only, not React Native widgets or feedback.
- **Scenario 3 — async/state edge cases:** `.task(id: settings)` plus the saving guard can lose the newest rapid toggle change; toggling the master off also erases child choices rather than temporarily pausing them.
- **Scenario 6 — source-invalid formatting:** `Text(..., textDirection = ...)` at `OperationsDashboard.kt:120,132` is not a Compose Text parameter; text direction belongs in `TextStyle`. It therefore supplies neither a compiling bidi solution nor locale-aware number/date/unit formatting.

Confirmed blocker: scenario 1’s unmarked privacy/product assurance. The scenario-6 chart defect is also substantive, but this review does not classify its coordinate mapping alone as a confirmed use of physical left/right layout APIs.

## Scorecard

| Scenario | Score | Notes |
| --- | ---: | --- |
| 1. Flutter Arabic onboarding | 15/18 | Final service has no recovery error; 2× narrow-phone test overflows/off-screens CTAs; unprovided privacy assurance is a blocker. |
| 2. React Native audit | 9/10 | Strong evidence-backed audit; hierarchy decision is indirect. |
| 3. SwiftUI notification settings | 14/16 | Native structure is clear; child preference erasure and a rapid-save race weaken dependency/persistence behavior. |
| 4. Compose checkout | 11/16 | Invalid import/live-region API prevents compilation; autofill and country-aware postal handling are absent. |
| 5. RN system refactor | 10/14 | Focused but modifies an existing radius without defect evidence; Node logic tests are not widget tests. |
| 6. Arabic operations dashboard | 12/14 | Strong density/sample labeling; chart direction conflicts and Text direction code does not compile. |

## Verification levels

- **Independently verified:** scenario 1 `flutter analyze` passed; its original widget tests passed (2), but an untouched copied-fixture regression run had one pass and two expected failures (uncaught service error; CTA off-screen/overflow at 320×568 2× text); scenario 3 `swiftc -typecheck` passed; scenario 5 `npm test` passed (2 Node logic tests, not widgets). Scenario 2’s original fixture hashes are unchanged. For scenario 5, the action helper, shell, identifiers, and Node action tests are unchanged; its intended screen/theme changes (including the 8→12 radius change) were reviewed separately.
- **Reported and independently corroborated only at source/spec level:** scenarios 2, 4, and 6. No renderer, emulator/device, screenshot, contrast measurement, TalkBack/VoiceOver session, or Compose build was available.

## Small skill-guidance fixes supported by this review

1. For source-only Compose outputs, require a final import/symbol sanity pass and explicitly forbid unused/unresolvable imports; this catches scenario 4's single-line failure without imposing a full project scaffold.
2. Where a design decides chart direction by domain, require the implementation to state and test the point-index-to-physical-axis mapping; a `Canvas` is not automatically RTL-aware.
3. For async final CTAs, include a failure-path source/test checklist (`try/catch`, visible retry/error, retained values) alongside the existing loading-state guidance.
