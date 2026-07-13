# Skill Evaluation Scenarios

Use these scenarios after changing the skill. A passing result should apply the rules without the tester explicitly repeating them.

## Evaluation method

For each scenario, score 0, 1, or 2:

- 0: misses or contradicts the requirement.
- 1: partially follows it.
- 2: follows it clearly and consistently.

A stable release should score at least 85% overall and have no 0 on a blocker requirement.

## Scenario 1: New Arabic onboarding screen

Prompt:

> Build a three-step Arabic onboarding flow in Flutter for a finance app. Use Cairo, a progress indicator, skip, next, and a final account-creation CTA.

Expected:

- RTL layout and semantic leading/trailing.
- Cairo with readable line heights.
- Realistic product-specific copy or clearly marked placeholders.
- One primary action.
- 44/48 minimum targets.
- Safe areas and text scaling.
- No generic gradients, glass cards, or decorative blobs by default.
- Correct mixed-direction treatment for numbers or currency.
- Loading/error state for final submission.

## Scenario 2: Audit an AI-looking home screen

Prompt:

> Review this React Native home screen. It has eight white cards, a purple gradient header, pill buttons, and strong shadows. Make it feel like a real productivity app.

Expected:

- Reorganizes information before restyling.
- Removes unnecessary cards and gradients.
- Reduces shadows and radius variety.
- Establishes one primary action and clearer sections.
- Reuses existing tokens/components.
- Does not invent fake productivity metrics.
- Validates accessibility and states.

## Scenario 3: iOS settings detail screen

Prompt:

> Implement a SwiftUI notification-settings screen with account-level and category-level toggles.

Expected:

- Native navigation and controls.
- System text styles/Dynamic Type.
- 44 pt targets.
- Grouped content without unnecessary custom cards.
- Clear dependency behavior between parent and child toggles.
- VoiceOver labels and state.
- No custom Liquid Glass content cards.
- Safe handling of save/error state if persistence is asynchronous.

## Scenario 4: Android checkout form

Prompt:

> Build a Jetpack Compose checkout address screen with country, phone, postal code, and continue button.

Expected:

- Material 3 components and theme.
- `dp`/`sp`, 48 dp targets, IME actions, autofill, correct keyboard types.
- Persistent labels and recoverable inline validation.
- Locale-aware field behavior.
- Insets and keyboard handling.
- Loading and submission error state.
- No disabled CTA with no explanation.
- TalkBack semantics.

## Scenario 5: Cross-platform design system refactor

Prompt:

> Clean up a React Native app where every screen uses slightly different spacing, button heights, and corner radii.

Expected:

- Inspects and inventories existing values.
- Creates semantic tokens and component variants.
- Normalizes buttons to named sizes.
- Preserves platform navigation and feedback.
- Minimizes unrelated visual change.
- Migrates incrementally rather than rewriting everything.
- Runs lint/types/tests and reports material limitations.

## Scenario 6: Arabic data-heavy dashboard

Prompt:

> Design an Arabic mobile operations dashboard with KPIs, alerts, a timeline, and a small chart.

Expected:

- Maintains useful information density.
- Does not turn every metric into a decorative card.
- Uses Arabic RTL while evaluating chart direction by domain.
- Locale-aware numbers, dates, and units.
- Accessible chart summary and non-color status cues.
- Responsive narrow-phone behavior.
- Avoids fake data or labels it clearly.

## Blocker requirements

A scenario fails regardless of score if it:

- Uses physical pixels as device-independent sizing.
- Produces core targets below platform minimum.
- Breaks back navigation or safe-area behavior.
- Uses ordinary small text below required contrast.
- Hardcodes left/right in an Arabic RTL task.
- Invents product claims or fake data as fact.
- Uses glass, gradients, or cards as the main solution without hierarchy work.
