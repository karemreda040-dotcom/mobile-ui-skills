# Mobile UI Release Checklist

Use this checklist before declaring a design or implementation complete. Fix issues when possible. Report only material remaining risks.

## Severity

- **Blocker**: prevents task completion, breaks navigation, loses data, creates an inaccessible core action, or causes severe clipping/overflow.
- **High**: materially harms comprehension, interaction, platform behavior, accessibility, or consistency.
- **Medium**: noticeable inconsistency or friction with a viable workaround.
- **Polish**: optical or aesthetic refinement that does not block use.

A release-ready result has no known blockers and no unresolved high-severity issues.

## 1. Task and information architecture

- [ ] The primary user goal is obvious.
- [ ] The screen title and state are clear.
- [ ] The primary action is visible and unambiguous.
- [ ] Secondary actions do not compete with the primary action.
- [ ] Navigation follows the user's mental model.
- [ ] The back path and cancel path are safe.
- [ ] No unrelated feature or fake data was invented.

## 2. Visual hierarchy

- [ ] One element owns the highest emphasis.
- [ ] Heading levels are visually distinct.
- [ ] Related content is grouped by proximity.
- [ ] Section separation is stronger than internal spacing.
- [ ] Alignment edges and baselines are consistent.
- [ ] Whitespace improves scanning without hiding important content.
- [ ] Cards are used only where a surface boundary is needed.

## 3. Typography

- [ ] The screen uses a limited semantic type scale.
- [ ] Page title and subordinate headings are not the same size with only a slight weight change.
- [ ] Long text uses a readable regular weight and line height.
- [ ] Button and navigation labels are consistent.
- [ ] Text wraps or truncates intentionally.
- [ ] Large text scaling does not clip, overlap, or hide actions.
- [ ] Arabic glyphs, diacritics, and mixed-script baselines render correctly.

## 4. Spacing and grid

- [ ] Values come from the spacing tokens.
- [ ] Phone margins are normally at least 16.
- [ ] The 4-column grid or project grid is respected.
- [ ] Component padding is consistent.
- [ ] Vertical rhythm is consistent.
- [ ] No arbitrary one-off spacing remains without a reason.
- [ ] Narrow and large phone widths were checked.
- [ ] Tablet/foldable layout is adapted when in scope.

## 5. Color and contrast

- [ ] Primary and secondary text meet contrast requirements.
- [ ] `#808080` or weaker gray is not used for ordinary small text.
- [ ] Status meaning is not color-only.
- [ ] Primary accent use is restrained.
- [ ] Disabled controls do not appear active.
- [ ] Borders and icons remain visible.
- [ ] Light and dark appearance work when supported.
- [ ] Translucent surfaces preserve legibility over real content.

## 6. Components

- [ ] Buttons use named size and hierarchy variants.
- [ ] No isolated interactive target is below 44 pt iOS or 48 dp Android.
- [ ] Inputs have persistent labels and useful error recovery.
- [ ] Loading preserves layout and prevents duplicate action.
- [ ] Selected, pressed, disabled, focus, error, and success states are present as applicable.
- [ ] Rows, cards, and icon buttons expose the expected tap area.
- [ ] Sheets, dialogs, menus, and snackbars are used for the correct scope.
- [ ] Touch targets do not overlap invisibly.

## 7. Platform fidelity

- [ ] iOS navigation, swipe-back, sheets, tab bars, system controls, and safe areas behave natively.
- [ ] Android back, insets, Material components, ripple, system bars, and navigation behave natively.
- [ ] Cross-platform branding does not erase platform interaction conventions.
- [ ] Current iOS glass is limited to navigation/control layers.
- [ ] Android does not imitate iOS glass without a product requirement.
- [ ] Icon set matches the platform or one coherent product set.

## 8. States and resilience

- [ ] Loading state exists.
- [ ] Empty state exists where data may be empty.
- [ ] Error state explains recovery.
- [ ] Offline or stale-data state exists when relevant.
- [ ] Permission-denied state exists when relevant.
- [ ] Success feedback matches the scope of the action.
- [ ] User input survives recoverable failure.
- [ ] Long content and unexpected data do not break layout.

## 9. Accessibility

- [ ] Normal text contrast is at least 4.5:1.
- [ ] Large text and meaningful UI graphics meet at least 3:1.
- [ ] Semantic roles and accessible names are correct.
- [ ] Focus/reading order matches visual order.
- [ ] Screen-reader announcements describe action and state.
- [ ] Color is not the sole cue.
- [ ] Gesture-only actions have alternatives.
- [ ] Reduced Motion, text scaling, and contrast settings are respected.
- [ ] Keyboard and switch access work where relevant.

## 10. Arabic and RTL

- [ ] Layout uses leading/trailing rather than left/right.
- [ ] Reading flow and navigation order mirror correctly.
- [ ] Directional icons mirror; nondirectional icons and factual imagery do not.
- [ ] Mixed Arabic/LTR values remain correctly ordered.
- [ ] Dates, currency, numbers, units, and plurals are locale-aware.
- [ ] Long Arabic labels do not clip.
- [ ] Arabic screen-reader labels are localized.
- [ ] Charts and timelines use the domain-correct direction.

## 11. Code quality

- [ ] Existing tokens and components were reused.
- [ ] New literals are centralized in theme/tokens.
- [ ] No unnecessary dependency was added.
- [ ] Business logic, analytics, localization keys, test IDs, and accessibility labels were preserved.
- [ ] Layout uses constraints instead of brittle absolute positioning.
- [ ] Formatter, lint, types, tests, and relevant build/preview commands pass or material failures are documented.
- [ ] No debug content, placeholder copy, or unused style remains.

## 12. Anti-AI polish

- [ ] The screen is specific to the product and task.
- [ ] No default purple-blue gradient or gradient text.
- [ ] No glass or shadow on every card.
- [ ] No excessive pills, badges, floating blobs, or decorative icons.
- [ ] No generic startup copy.
- [ ] No fake metrics or content.
- [ ] No oversized hero treatment on a utility screen.
- [ ] At least one simplification pass was completed.
