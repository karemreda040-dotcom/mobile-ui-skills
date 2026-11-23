# UI consistency refactor

## What changed

- Centralized the standard primary-control geometry in `src/theme.ts`: 48-unit minimum height, 12-unit control radius, and 16-unit horizontal control padding.
- Normalized the Home, Focus, and Profile screen margins to the existing 16-unit `theme.spacing.screen` token.
- Replaced each screen's one-off button heights (40/44/46), radii (14/full/6), and horizontal padding (17) with those shared semantic tokens.

## Files and contracts preserved

- Changed: `src/theme.ts`, `src/screens/Home.tsx`, `src/screens/Focus.tsx`, and `src/screens/Profile.tsx`.
- Preserved the violet `#6C3FC5` brand, screen content, navigation route calls, analytics through `openSection`, translation keys, `testID` values, and accessibility roles/labels.
- The 48-unit primary controls satisfy the Android minimum target and exceed the iOS 44-point minimum. The shared 12-unit radius removes the prior full-pill and mixed-radius treatment.

## Validation

- `npm test` — passed: 2 tests, 0 failures. This verifies the analytics-before-navigation action contract and invalid-section behavior.
- Searched the edited screen styles: all three screens now consume the same screen padding, minimum height, radius, and control-padding tokens.

## Limitations

The fixture supplies only React Native excerpts and a Node action test; it has no renderer, formatter, typecheck, or native build configuration. Consequently, no device/visual verification of pressed feedback, font scaling, dark mode, or platform-specific behavior was available. Parent `AppShell` continues to own safe-area handling.
