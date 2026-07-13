---
description: Designs and implements a new mobile screen, flow, or feature UI for iOS, Android, Flutter, React Native, SwiftUI, UIKit, or Jetpack Compose. Use when the UI does not exist yet and must be built, including Arabic and RTL interfaces. Inspects the project's existing design system first, then implements and validates real code.
when_to_use: Trigger when starting a new mobile screen, flow, onboarding, form, or feature UI from scratch, or when adding a screen to an existing mobile app.
argument-hint: "[screen or flow to build, plus platform and constraints]"
disable-model-invocation: true
---

# Create Mobile UI

Build the requested mobile interface so it feels intentional, product-specific, platform-aware, accessible, and human-designed. Solve the user's task first; use decoration only when it supports hierarchy, meaning, or interaction.

**Task:** $ARGUMENTS

## Authority order

Apply rules in this order. Never replace a coherent existing system just to match the fallback.

1. Explicit user requirements, product constraints, and accessibility needs.
2. The project's existing design system, brand, tokens, components, icon set, and code conventions.
3. Native platform conventions for the target OS.
4. The fallback system in [../_mobile-ui-shared/TOKENS.json](../_mobile-ui-shared/TOKENS.json).

When a requested value creates a usability or accessibility problem, preserve the intent, make the smallest safe correction, and state it briefly.

## Workflow

### 1. Inspect before designing

Read the project before proposing anything:

- Framework and platform: SwiftUI, UIKit, Jetpack Compose, Android Views, Flutter, React Native, Ionic, or other.
- Theme, tokens, reusable components, fonts, icon set, navigation, localization, analytics hooks, accessibility labels, test identifiers.
- Existing screens that solve a similar problem.
- Target form factor: phone, tablet, foldable, iOS, Android, or shared cross-platform.
- Whether Arabic or RTL is in scope.

Find the closest existing component or pattern before creating a new one.

### 2. Define the screen job

- Primary user goal, primary action, information priority, entry and exit paths.
- Which states are relevant: loading, empty, error, disabled, offline, permission, success.
- Infer conservative defaults when details are missing. Do not block implementation for cosmetic questions. Ask only when an ambiguity would change product behavior or risk destructive work.

### 3. Choose a platform mode

- Native iOS behavior for iOS-first products.
- Material 3 behavior for Android-first products.
- For shared cross-platform products, keep brand foundations shared while preserving platform navigation, gestures, feedback, system bars, and accessibility behavior.

### 4. Plan, then build

Write a short implementation plan, then implement it. Do not stop at design advice when implementation was requested.

- Use semantic tokens instead of arbitrary values.
- Use responsive constraints, safe areas, insets, and content-driven height.
- Reuse components and variants; do not duplicate near-identical components.
- Do not add a dependency for a component the existing stack can build cleanly.
- Do not invent fake product data, features, claims, metrics, testimonials, or generic marketing copy to make a screen look full.

If there is no codebase yet, produce implementation-ready specs — component structure, exact tokens, states, constraints, and platform assumptions — not vague inspiration.

### 5. Validate

- Check hierarchy, alignment, spacing rhythm, typography, contrast, touch targets, states, RTL, text scaling, keyboard behavior, and small-screen overflow.
- Run the project's formatter, linter, type checker, tests, and the nearest safe build or preview command.
- When the app can actually be rendered, inspect the real screen or a screenshot and iterate. Never claim visual verification you did not perform.

### 6. Refine

Fix what validation surfaces rather than only listing it. Remove decoration that does not improve comprehension or interaction. Keep changes scoped to the requested screen unless a shared fix is genuinely necessary.

## Non-negotiables

- Logical units only: points on iOS, `dp` for Android layout, `sp` for Android text, framework-equivalent logical units in cross-platform code. Never reason in physical device pixels.
- Respect status bars, notches, Dynamic Island, home indicators, gesture areas, keyboard insets, and fold or tablet constraints.
- Minimum interactive hit area: 44 × 44 pt on iOS, 48 × 48 dp on Android. A smaller visible icon may sit inside the larger hit area.
- Normal text ≥ 4.5:1 contrast. Large text and meaningful non-text UI ≥ 3:1.
- Never communicate status with color alone.
- Support text scaling and content expansion without clipping, overlap, or inaccessible truncation.
- One clear primary action per screen or decision region.
- Every interactive component needs its applicable default, pressed, focused, disabled, loading, error, and selected states.
- Keep native back behavior, gestures, sheets, system controls, and accessibility semantics unless the product has a strong documented reason to change them.
- Use leading/trailing semantics; never hardcode left/right for directional layout.
- Do not use gradients, glass, shadows, pills, cards, or animation as default decoration.

## Reference routing

Read only what the task needs, but **always read `ANTI-AI.md` and `REVIEW-CHECKLIST.md` before finishing.**

- Typography, spacing, color, radius, elevation, glass, motion, accessibility → [../_mobile-ui-shared/FOUNDATIONS.md](../_mobile-ui-shared/FOUNDATIONS.md)
- Buttons, fields, cards, lists, navigation, sheets, forms, UI states → [../_mobile-ui-shared/COMPONENTS.md](../_mobile-ui-shared/COMPONENTS.md)
- iOS conventions and Liquid Glass → [../_mobile-ui-shared/PLATFORM-IOS.md](../_mobile-ui-shared/PLATFORM-IOS.md)
- Android and Material 3 → [../_mobile-ui-shared/PLATFORM-ANDROID.md](../_mobile-ui-shared/PLATFORM-ANDROID.md)
- Arabic typography, bidi, localization, RTL → [../_mobile-ui-shared/ARABIC-RTL.md](../_mobile-ui-shared/ARABIC-RTL.md)
- Generic / AI-generated patterns to avoid → [../_mobile-ui-shared/ANTI-AI.md](../_mobile-ui-shared/ANTI-AI.md)
- Final QA and severity gates → [../_mobile-ui-shared/REVIEW-CHECKLIST.md](../_mobile-ui-shared/REVIEW-CHECKLIST.md)
- Fallback semantic tokens → [../_mobile-ui-shared/TOKENS.json](../_mobile-ui-shared/TOKENS.json)

## Completion format

End with a compact summary:

- What was created.
- Which platform decisions were applied.
- Files changed.
- What was validated, with the commands and their results.
- Any remaining assumption or limitation that materially affects the result.

Do not output a generic design lecture or narrate every rule you used.
