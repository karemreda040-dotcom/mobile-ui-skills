# Android UI Rules

## Contents

- Platform intent
- Units and typography
- Layout and navigation
- Components and feedback
- Color, shape, and elevation
- Accessibility
- Android review checks

## Platform intent

- Prefer Material 3 components and Android platform behavior unless the product has a deliberate cross-platform system.
- Preserve system back, predictive back where supported, edge-to-edge layout, window insets, ripple or pressed feedback, text editing, autofill, and accessibility semantics.
- Theme native behavior rather than reimplementing it.

## Units and typography

- Use `dp` for layout and `sp` for text.
- Respect user font scaling.
- Material 3's default type scale is a useful reference, not a requirement to use all roles:

| Material role | Size / line height |
|---|---:|
| Display Large | 57 / 64 |
| Display Medium | 45 / 52 |
| Display Small | 36 / 44 |
| Headline Large | 32 / 40 |
| Headline Medium | 28 / 36 |
| Headline Small | 24 / 32 |
| Title Large | 22 / 28 |
| Title Medium | 16 / 24 |
| Title Small | 14 / 20 |
| Body Large | 16 / 24 |
| Body Medium | 14 / 20 |
| Body Small | 12 / 16 |
| Label Large | 14 / 20 |
| Label Medium | 12 / 16 |
| Label Small | 11 / 16 |

- Most products need a reduced subset. Map project roles to Material roles consistently.
- Native default: Roboto or the system font.
- Branded default: Inter for product UI, Poppins for limited expressive headings, Cairo for Arabic.
- Use Medium for labels and compact titles; use Regular for body copy.
- Avoid tiny 11–12 sp text for important information.
- Test maximum font scale, long translations, and mixed Arabic/Latin content.

## Layout and navigation

- Draw edge to edge when the app architecture supports it, then handle status, navigation, gesture, cutout, and keyboard insets explicitly.
- Use Material top app bars, navigation bars, navigation rails, drawers, and adaptive navigation components according to width.
- Use a bottom navigation bar for 3–5 top-level destinations.
- Use navigation rail or drawer on wider screens where appropriate.
- Preserve state for top-level destinations.
- Keep system back behavior predictable.
- Avoid placing critical controls under gesture areas or display cutouts.
- On tablets and foldables, use adaptive panes or max-width content rather than stretching the phone layout.

## Components and feedback

- Minimum touch target: 48 × 48 dp.
- Use Material Button, IconButton, Checkbox, RadioButton, Switch, Slider, TextField, Snackbar, Dialog, Sheet, and menu components when appropriate.
- Material components often provide accessibility semantics and minimum targets; custom components must add them explicitly.
- Use ripple or an equivalent immediate pressed state.
- Use Material Symbols or one coherent product icon set.
- A FAB is appropriate only for a highly important, frequent creation action.
- Snackbars communicate brief process feedback and may include one action; they are not a replacement for persistent error guidance.
- Keep text fields, selection, cursor, autofill, keyboard options, and IME actions native.

## Color, shape, and elevation

- Use `MaterialTheme` or the project's theme as the source of truth.
- Use semantic color roles and accessible on-colors.
- Support dynamic color only if it fits the product and preserves brand and contrast.
- Material shapes can map cleanly to 4, 8, 12, 16, and 24 radii.
- Use tonal surfaces and Material elevation before adding strong custom shadows.
- Do not imitate iOS Liquid Glass by default.
- Keep selected, pressed, disabled, focused, and error states distinct.
- Avoid excessive container shapes and expressive morphing unless the product actually benefits from Material Expressive patterns.

## Accessibility

- Minimum target: 48 × 48 dp.
- Normal text below large-text thresholds: at least 4.5:1 contrast.
- Large text and meaningful UI visuals: at least 3:1.
- Provide TalkBack semantics, roles, state descriptions, and meaningful click labels.
- Decorative icons should not create redundant announcements.
- Keep traversal order logical.
- Provide alternatives to drag, swipe, and long press.
- Test font scale, display size, dark theme, high contrast, RTL, TalkBack, Switch Access, and keyboard navigation on larger devices.
- Use locale-aware formatting for dates, numbers, currency, plurals, and bidirectional text.

## Android review checks

- Does the UI use `dp`/`sp` and respond to font scale?
- Are touch targets at least 48 × 48 dp?
- Are system bars, keyboard, and gesture insets handled?
- Is back behavior native and predictable?
- Are Material components and semantics reused rather than recreated?
- Is elevation restrained and platform-appropriate?
- Does the screen adapt to tablet/foldable widths?
- Does TalkBack announce purpose and state correctly?
- Is RTL behavior correct?
