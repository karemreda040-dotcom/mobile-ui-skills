# Arabic finance onboarding (Flutter)

Created a minimal, runnable three-step onboarding flow for **أمان**.

## Plan applied

1. Use an RTL-first Arabic flow with Cairo and a single, clearly dominant action.
2. Keep the screens simple: progress, optional skip, step content, and next/final CTA.
3. Put the final account action behind an explicit local service boundary; do not implement identity, payment, network, or remote account behavior.

## Platform and accessibility decisions

- Flutter/Material 3, with `Directionality.rtl`, semantic directional alignment, and Arabic accessibility text for progress.
- Cairo is bundled from the official Google Fonts Cairo family under its included OFL license (`assets/fonts/OFL.txt`).
- 16 logical-unit safe margins, 56 logical-unit full-width CTA, readable text colors, and content-driven text wrapping.
- The CTA preserves its footprint during its local loading state and prevents duplicate taps. The final step announces a local-only completion through a snack bar.

## Files created

- `pubspec.yaml`
- `lib/main.dart`
- `test/onboarding_test.dart`
- `assets/fonts/Cairo-Regular.ttf`, `Cairo-SemiBold.ttf`, `Cairo-Bold.ttf`, and `OFL.txt`

## Validation

| Command | Result |
|---|---|
| `/Users/bdc/flutter/bin/dart format lib/main.dart test/onboarding_test.dart` | Passed |
| `/Users/bdc/flutter/bin/flutter pub get` | Passed |
| `/Users/bdc/flutter/bin/flutter analyze` | Passed: no issues found |
| `/Users/bdc/flutter/bin/flutter test` | Passed: 1 widget test |

The widget test verifies step progression, skip-to-final behavior, final Arabic CTA visibility, and invocation of only the injected local account-service boundary.

## Limits

No emulator or device was configured, so this does not claim device screenshot or visual-device verification. An optional offscreen-render screenshot attempt was not retained because the Flutter test renderer did not complete its image export; the production test suite remains green. The `LocalAccountCreationService` is deliberately a no-op integration seam for a future authorized account flow.
