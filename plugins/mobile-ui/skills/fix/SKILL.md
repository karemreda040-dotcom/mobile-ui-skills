---
description: Inspects and directly refactors an existing mobile UI — removes the generic AI-generated look, fixes spacing, typography, contrast, radii, shadows, component states, accessibility, platform fidelity, and RTL problems, then validates the changes. Use when the UI exists and the user wants the code actually corrected, not just reviewed.
when_to_use: Trigger when cleaning up an AI-generated app's interface, unifying design tokens, fixing visual QA findings, or applying a previous audit's results.
argument-hint: "[what to fix, and the scope: screen, flow, or whole app]"
disable-model-invocation: true
---

# Fix Mobile UI

Inspect the existing mobile UI in scope, then **edit the code** to correct it. Do not stop at a report.

**Task:** $ARGUMENTS

## Authority order

1. Explicit user requirements, product constraints, and accessibility needs.
2. The project's existing design system, brand, tokens, components, and code conventions.
3. Native platform conventions for the target OS.
4. The fallback system in [../_mobile-ui-shared/TOKENS.json](../_mobile-ui-shared/TOKENS.json).

**Never replace a coherent existing design system just to force the fallback values.** Preserve product identity. The goal is to remove *unearned decoration and inconsistency* — not to make every app look the same.

## Must preserve

Refactoring the UI must not change what the app does. Preserve:

- Business logic and data flow.
- API behavior.
- Routes and navigation behavior.
- Analytics events.
- Localization keys.
- Accessibility labels and semantics.
- Test identifiers and testable behavior.

Do not redesign screens outside the requested scope. Do not add a dependency when the existing stack can implement the correction cleanly.

## Workflow

### 1. Audit internally first

If an audit already exists earlier in this conversation, use it — but re-verify it against the current files rather than repeating the full report.

Otherwise, inspect the scope yourself: read the theme, tokens, and shared components **before** the screens. Most problems are best fixed once at the system level, not patched per screen.

### 2. Plan

Write a concise fix plan ordered by severity and by dependency:

1. Design tokens.
2. Shared typography.
3. Shared buttons and inputs.
4. Shared cards and list items.
5. Navigation.
6. Individual screens.

Fix **Blocker and High** first, then Medium and Polish that fit the requested scope. Accessibility failures that block use are Blocker or High.

Then edit the code — unless the user explicitly asked for plan-only.

### 3. Fix

- Replace arbitrary literals with semantic tokens where the repetition justifies it.
- Resolve each role to the existing semantic token's current value. Do not replace it with a fallback preference unless an observed defect or the user requested a redesign; report why when you do.
- Reuse or improve shared components instead of duplicating variants.
- If the same problem appears repeatedly, fix the token or shared component — not ten one-off patches.
- Prefer small, coherent diffs.

Remove these generic AI patterns while keeping real brand personality (see `ANTI-AI.md` for the full list):

- Every section wrapped in a card; many white cards floating on pale gray.
- Blue/purple gradients unrelated to the brand; glow, blobs, sparkles.
- Glassmorphism on ordinary content surfaces.
- Pill shapes and huge radii everywhere.
- The same shadow under every card, field, and button.
- Giant marketing hero text on a utility screen.
- Everything centered; every element with equal emphasis; the same gap everywhere.
- Random values: 13, 17, 19, 23.
- Icons in decorative colored squares with no semantic purpose; emoji as the icon system; mixed icon families.
- Fake statistics, testimonials, names, or filler copy.
- A polished happy path with no loading, error, empty, offline, or disabled states.
- A screen that only works in English and collapses with Arabic or long text.

### 4. Validate

- Inspect the configured package scripts, `pubspec`, Gradle, or Xcode setup first; run only the applicable configured formatter, linter, type checker, tests, and safe build or preview commands. Report unavailable commands and their actual results.
- Run a safe preview or render verification if the project supports one.
- Iterate on failures until checks pass, or report the exact external blocker.
- Never claim visual verification you did not perform.

## Non-negotiables

- Logical units only — points on iOS, `dp`/`sp` on Android, framework-equivalent elsewhere. Never physical pixels.
- Minimum hit area 44 × 44 pt on iOS, 48 × 48 dp on Android.
- Normal text ≥ 4.5:1 contrast; large text and meaningful non-text UI ≥ 3:1.
- Never communicate status with color alone.
- One clear primary action per screen or decision region.
- Use leading/trailing semantics; never hardcode left/right for directional layout.
- Respect safe areas, notches, home indicators, and keyboard insets.

## Reference routing

Always read `ANTI-AI.md` and `REVIEW-CHECKLIST.md` before finishing.

- Typography, spacing, color, radius, elevation, glass, motion, accessibility → [../_mobile-ui-shared/FOUNDATIONS.md](../_mobile-ui-shared/FOUNDATIONS.md)
- Buttons, fields, cards, lists, navigation, sheets, forms, UI states → [../_mobile-ui-shared/COMPONENTS.md](../_mobile-ui-shared/COMPONENTS.md)
- iOS conventions and Liquid Glass → [../_mobile-ui-shared/PLATFORM-IOS.md](../_mobile-ui-shared/PLATFORM-IOS.md)
- Android and Material 3 → [../_mobile-ui-shared/PLATFORM-ANDROID.md](../_mobile-ui-shared/PLATFORM-ANDROID.md)
- Arabic typography, bidi, localization, RTL → [../_mobile-ui-shared/ARABIC-RTL.md](../_mobile-ui-shared/ARABIC-RTL.md)
- Generic / AI-generated patterns → [../_mobile-ui-shared/ANTI-AI.md](../_mobile-ui-shared/ANTI-AI.md)
- Severity gates and final QA → [../_mobile-ui-shared/REVIEW-CHECKLIST.md](../_mobile-ui-shared/REVIEW-CHECKLIST.md)
- Fallback semantic tokens → [../_mobile-ui-shared/TOKENS.json](../_mobile-ui-shared/TOKENS.json)

## Completion format

End with:

- What changed.
- Files, components, and tokens affected.
- Platform and accessibility decisions applied.
- Validation commands run and their actual results.
- Remaining limitations or intentionally deferred polish.

Do not narrate every rule you used.
