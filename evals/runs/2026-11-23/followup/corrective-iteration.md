# Corrective iteration

The initial fresh generations remain preserved at `initial-rerun-1` and `initial-rerun-3`. They did not satisfy all required resilience, localization, accessibility, and narrow-text-scale behavior; this corrective pass changes only `rerun-1` and `rerun-3`.

## Evidence before the Flutter fix

Added focused tests in `rerun-1/test/onboarding_test.dart` before changing the application and ran `/Users/bdc/flutter/bin/flutter test`.

- The delayed failure test failed: the rejected `AccountCreationService` future propagated `Bad state: local test failure`; no Arabic error or retry affordance was found.
- The narrow layout test failed: at 320 × 568 logical units and 2× text scale, `RenderFlex overflowed by 212 pixels on the bottom`.
- The pending duplicate-submission test passed, showing the existing disabled button was already guarding a pending request.

## Corrective artifacts

### `rerun-1`

- Added `flutter_localizations`, Arabic locale, and Material localization delegates.
- Kept the local `AccountCreationService` boundary; added caught failure state, localized visible error, retry label, and a duplicate-call guard.
- Replaced the fixed-height flow layout with a safe-area-aware, scrollable, content-driven layout. The primary button has a 52-unit minimum instead of a fixed height and can be scrolled into reach at large text sizes.
- Marked all example brand/product copy as an educational/local example rather than a real service claim.
- Extended widget coverage for delayed rejection/retry, pending duplicates, and every step at 320 × 568 / 2× scale with Cairo configured, checking no layout exception and a reachable CTA.

Validated after the correction:

- `/Users/bdc/flutter/bin/dart format lib test` — passed.
- `/Users/bdc/flutter/bin/flutter pub get --offline` — passed.
- `/Users/bdc/flutter/bin/flutter analyze` — passed, no issues.
- `/Users/bdc/flutter/bin/flutter test` — passed, 4 tests.

### `rerun-3`

- Replaced the literal accessibility string `Controls (category.rawValue) notifications` with a category-derived, interpolated hint such as `Controls Payments notifications`.
- Added tests for exact accessibility hint formatting and rapid synchronous preference updates while preserving category choices. The tests use `MemoryStore`, not `UserDefaults`.
- Marked the screen as main-actor isolated and split its default store initializer from dependency injection so iOS SDK typechecking succeeds.

Validated after the correction:

- `swift test` — passed, 4 tests.
- `xcrun swiftc -typecheck -target arm64-apple-ios17.0-simulator -sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)" Sources/NotificationSettings/NotificationSettingsScreen.swift` — passed.

## Parent feedback needed

The corrected Flutter behavior keeps the CTA content-driven and scroll-reachable at 2× scale rather than forcing it into a fixed viewport. Parent review should confirm that this scrolling onboarding treatment is the preferred product behavior for the target device policy. No real account/auth/payment service, device rendering, or simulator accessibility run was added.
