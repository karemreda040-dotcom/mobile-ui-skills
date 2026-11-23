# React Native home-screen audit

Scope: `scenario-2/src/screens/Home.tsx`, the theme, action helper, and parent shell. This is a code audit of React Native excerpts; no render was supplied or visually verified. `AppShell` owns the safe area, so safe-area handling is not a finding.

## Confirmed findings

### High — Every primary action is below the minimum mobile tap target

Location:
`scenario-2/src/screens/Home.tsx:10`

Evidence:
Each of the eight `Pressable` actions has `height:32`. The cross-platform minimum is 44 pt on iOS and 48 dp on Android.

Problem:
The only navigational control for each section is hard to activate reliably, especially for motor-impaired users. Its pill treatment also makes a destination action look like a compact chip.

Recommended correction:
Make each action at least the shared `theme.control.minHeight` (48) and use `theme.radius.control` rather than a full pill. Prefer making the whole destination row the `Pressable` when opening that section is the row's sole action.

Fix location:
The shared control token and home row component, not eight independently styled buttons.

### High — Secondary metadata fails normal-text contrast

Location:
`scenario-2/src/screens/Home.tsx:9`

Evidence:
The 14-unit record value uses `#AAAAAA` on the white `#FFFFFF` card surface: approximately 2.32:1, below the 4.5:1 normal-text requirement. The theme already supplies `theme.colors.secondary` as `#5F6368`.

Problem:
Values such as “2 tasks” and “Account settings” are difficult to read in varied lighting or with low vision.

Recommended correction:
Use `theme.colors.secondary` for ordinary supporting copy and reserve lighter text for disabled or nonessential information.

Fix location:
The home row's secondary-text style, drawing from the existing theme color.

### Medium — Equivalent destinations use conflicting, unearned elevation and shape

Location:
`scenario-2/src/screens/Home.tsx:8-10`

Evidence:
All eight records are white floating cards on `#F7F7F8`, each with `elevation:12`, `shadowOpacity:0.4`, and `shadowRadius:16`; radii alternate between 18 and 32. Card padding is 19 and the inter-card gap is 13, neither in the project's 4-unit token scale.

Problem:
Equal heavy shadows make every destination compete for attention, while alternating radii imply different hierarchy for equivalent rows. The result weakens efficient productivity-screen scanning.

Recommended correction:
Render the records as consistent destination rows (or one coherent grouped list) using `theme.spacing.screen`/`inline`/`section` and one standard row radius. Use dividers or a restrained surface boundary; remove heavy shadows from routine content.

Fix location:
A reusable home destination-row/list style backed by theme tokens, rather than per-record inline literals.

### Medium — The header adds an un-tokenized decorative gradient

Location:
`scenario-2/src/screens/Home.tsx:7`

Evidence:
The theme establishes one violet brand value, `#6C3FC5`, but the header imports `LinearGradient` and combines it with un-tokenized `#915ED9`, `padding:24`, and `borderRadius:28`.

Problem:
The gradient competes with the screen content hierarchy and introduces a generic purple-gradient treatment outside the declared brand system. The oversized rounded header reinforces decoration rather than the task-oriented app structure.

Recommended correction:
Use a simple brand or neutral header with the existing 16-unit screen alignment, a semantic title style, and restrained shape. Keep violet as the brand identity.

Fix location:
The home header and shared theme tokens; remove this screen's gradient dependency if no other screen needs it.

## Unverified questions

- No renderer, device configuration, or native build is supplied. Verify pressed feedback, Android ripple/iOS feedback, text scaling, narrow-width wrapping, RTL behavior, and VoiceOver/TalkBack traversal on devices before release.
- The excerpt supplies static records only. Loading, empty, error, offline, and retry states may be owned by an unavailable parent or data layer; their absence is not a confirmed screen defect.

## Top priorities

1. Establish semantic row/control spacing, radius, and 48-unit minimum-height tokens.
2. Replace the eight elevated cards and tiny pills with accessible, consistent destination rows.
3. Correct secondary-text contrast, then simplify the non-tokenized gradient header.

Ready-to-paste fix invocation:

`$mobile-ui-fix Apply the confirmed High and Medium findings from this home-screen audit. Preserve the violet brand, navigation route IDs, analytics, translations, accessibility labels, and test IDs.`
