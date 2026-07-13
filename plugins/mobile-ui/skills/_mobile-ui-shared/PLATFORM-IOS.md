# iOS UI Rules

## Contents

- Platform intent
- Typography
- Layout and navigation
- Controls and interaction
- Liquid Glass and materials
- Accessibility and system settings
- iOS review checks

## Platform intent

- Prefer SwiftUI or UIKit system components when they solve the task.
- Preserve expected iOS navigation, swipe-back behavior, sheets, menus, pickers, selection, text editing, haptics, and system bars.
- Use the product's brand without making standard controls unfamiliar.
- Let native components adapt across iPhone, iPad, Dynamic Type, appearance, and accessibility settings.

## Typography

- Prefer system text styles for native experiences because they support Dynamic Type and platform optical sizing.
- Native iOS body text commonly centers around 17 pt. Use the product fallback scale only when a custom branded type system is intentional.
- Practical role mapping:
  - Hero: native large-title behavior or custom 32–34 bold.
  - Page title: native title style or custom 24/32 semibold.
  - Section title: native title 2/3 behavior or custom 20/28 semibold.
  - Body: native body style or custom 16–17/24 regular.
  - Caption: native caption/footnote behavior or custom 12–13/16–18.
- Support Dynamic Type with custom fonts; do not hardcode a visual size that ignores user settings.
- Test Bold Text, larger accessibility sizes, and long localized strings.
- Prefer San Francisco for native iOS. Use Inter/Poppins/Cairo only when the product has a defined custom typography system.

## Layout and navigation

- Respect safe areas and home-indicator insets.
- A custom compact top bar may use 56 content height, but native `NavigationStack`, `UINavigationController`, and navigation bars should control their own geometry.
- Use large titles primarily at top-level destinations.
- Use a tab bar for stable top-level destinations and keep tab state.
- Use a navigation stack for drill-down content.
- Use native sheets and detents for short, focused modal tasks.
- Keep the native interactive back gesture working.
- On iPad, adapt navigation to width. Consider tab bar, sidebar, split view, or multicolumn layout according to hierarchy.
- Do not stretch phone-sized content across the full iPad width.
- Extend content under system bars only when the native edge treatment preserves legibility.

## Controls and interaction

- Minimum hit region: 44 × 44 pt.
- Use system buttons, toggles, pickers, date controls, text fields, menus, context menus, and swipe actions where appropriate.
- Use SF Symbols for native iconography and choose variants intentionally for state.
- Keep text editing, selection, copy/paste, keyboard shortcuts on iPad, and autofill native.
- Use haptics sparingly for meaningful selection, confirmation, warning, or failure.
- Do not replace a standard control with a custom look that weakens discoverability or accessibility.
- Keep destructive actions clear and confirm high-impact irreversible actions.
- Test with the keyboard, VoiceOver, Switch Control, and pointer on iPad when relevant.

## Liquid Glass and materials

- Liquid Glass forms a distinct functional layer for navigation and controls above content.
- Prefer system-provided glass behavior on supported OS versions.
- Reserve custom glass for elements that genuinely float above content and act as controls.
- Do not use Liquid Glass as the default content-card material.
- Do not stack glass inside glass.
- Avoid custom opaque backgrounds that interfere with native navigation bars, toolbars, sheets, or tab bars when targeting the current iOS design language.
- Let content remain the visual focus; controls should be available but able to recede.
- Provide sensible fallback materials for earlier OS versions.
- Test Increase Contrast, Reduce Transparency, and Reduce Motion. Never assume translucent content remains legible in all contexts.

## Accessibility and system settings

Support:

- Dynamic Type and accessibility text sizes.
- VoiceOver labels, traits, values, hints, and focus order.
- Bold Text.
- Increase Contrast.
- Differentiate Without Color.
- Reduce Transparency.
- Reduce Motion.
- Button Shapes where relevant.
- Light and dark appearance.
- Larger Content Viewer for compact bar controls when appropriate.
- Localization and RTL mirroring through native leading/trailing APIs.

## iOS review checks

- Does the screen feel like iOS without copying visual trends blindly?
- Are native navigation and back gestures intact?
- Are all tap targets at least 44 × 44 pt?
- Does text scale without clipping or losing actions?
- Are system bars and sheets using safe areas correctly?
- Is Liquid Glass limited to the control/navigation layer?
- Do icons match SF Symbols or the product's one coherent set?
- Does the screen work with VoiceOver, RTL, dark mode, and accessibility settings?
