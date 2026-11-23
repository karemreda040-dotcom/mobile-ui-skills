# Consistency refactor

## What changed

- Centralized page-title and primary-button typography in `src/theme.ts`.
- Standardized all three screen margins to the existing 16-unit screen token.
- Standardized title-to-action spacing to the existing 24-unit section token.
- Standardized primary controls to the existing 48-unit minimum height and 8-unit control radius, with 16-unit horizontal padding.
- Added the existing brand's semantic `onBrand` color token instead of repeating the white literal.

## Scope preserved

Routes, navigation, analytics ordering, localization keys, accessibility roles/labels, and test IDs were left unchanged. No dependencies or native scaffolding were added.

## Validation

- `npm test` — passed (2 tests, 0 failures).
- Renderer, typecheck, and native build checks are unavailable because this fixture is excerpts only and provides no such configuration.

## Remaining limitations

No visual/device rendering was possible in this fixture. The changes use React Native logical units and the existing safe-area-owned `AppShell`; platform-specific native behavior remains outside the supplied excerpts.
