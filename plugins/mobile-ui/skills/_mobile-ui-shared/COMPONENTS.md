# Mobile Component Rules

## Contents

- General component behavior
- Buttons
- Icon buttons
- Inputs and forms
- Cards and grouped content
- Lists and rows
- Top app bars
- Bottom navigation and tab bars
- Tabs and segmented controls
- Chips and badges
- Sheets, dialogs, and menus
- Feedback and status states
- Search
- Media and data visualization

## General component behavior

- Build components as semantic variants, not one-off visual copies.
- A component variant must define size, padding, type role, icon behavior, radius, color, and states.
- Interactive states commonly include: default, pressed, focused, hovered when relevant, disabled, loading, selected, error, and success.
- Loading should preserve the component footprint to avoid layout shift.
- For async actions, test delayed, failing, duplicate, and cancelled/disposed requests; a recoverable failure keeps the user's input or current step and offers retry.
- Auto-save must not lose the latest committed edit during overlapping requests or cancellation. A master “pause” control preserves child preferences unless an explicit clear policy says otherwise.
- Labels must remain understandable without relying on icon color.
- Component content must survive longer localization strings and text scaling.
- Never hide a critical action behind an unlabeled gesture.

## Buttons

### Size tokens

Do not choose between 48, 50, 52, and 56 randomly. Use explicit variants:

| Variant | Visible height | Typical use |
|---|---:|---|
| XL | 56 | Rare hero, onboarding, or high-emphasis action |
| Large | 52 | Primary full-width mobile CTA |
| Medium | 48 | Standard button |
| Small | 40 | Compact visual button; retain 44/48 minimum hit area |

Values such as 30, 32, 34, or 36 are suitable for chips, badges, compact toolbar visuals, or secondary controls only when the surrounding hit area still reaches the platform minimum. They are not suitable as isolated primary tap targets.

### Button anatomy

- Standard label: 16/20 semibold.
- Compact label: 14/20 medium or semibold.
- Horizontal padding: 16; use 20–24 for large text-only buttons.
- Icon-label gap: 8.
- Standard icon: 20; compact icon: 18.
- Standard radius: 12. Use full pill only when the product shape language calls for it.
- Keep a single-line label when possible; rewrite before shrinking text.
- Preserve button width when showing a spinner.

### Hierarchy

Use these roles consistently:

1. Primary: one principal action in the decision region.
2. Secondary: meaningful alternative with lower emphasis.
3. Tertiary or text: lightweight contextual action.
4. Destructive: used only for destructive outcomes.
5. Disabled: unavailable and noninteractive, with the reason discoverable when needed.

Rules:

- Avoid two equally prominent primary buttons side by side.
- Use action-oriented labels such as “Save”, “Continue”, or “Try again”.
- Do not use generic “OK” when a specific action name is available.
- Avoid all caps.
- Do not color a cancel action red.
- Confirm irreversible or high-impact destructive actions.
- A destructive action may be visually quiet until the user reaches the confirmation step.

## Icon buttons

- Visible icon: usually 20–24.
- Hit area: at least 44 pt iOS or 48 dp Android.
- Use a circular or rounded container only when it communicates a control surface or selected state.
- Give unfamiliar icon-only actions a visible label where space permits.
- Supply an accessibility label describing the action result.
- Keep at least 8 units between adjacent hit areas and prevent invisible target overlap.
- Use a consistent stroke/fill style.

## Inputs and forms

### Field sizing

- Standard field: 52 high.
- Compact field: 48 high.
- Large or accessibility-forward field: 56 high.
- Multiline fields use content-driven height with a sensible minimum.
- Field radius: usually 12.
- Horizontal padding: 14–16.
- Field text: 16/24 regular.
- Label: 14/20 medium.
- Helper or error text: 12/16 or 14/20 depending importance.

### Field behavior

- Use a persistent label; placeholder text is an example or hint, not the only label.
- Use the correct keyboard, capitalization, return-key action, autocomplete, autofill, and content type.
- Keep cursor, selection, and paste behavior native.
- Validate after meaningful interaction; do not show an error before the user has had a chance to act.
- Place error text near the field and explain how to recover.
- Preserve user input after validation failure.
- Provide show/hide behavior for passwords with a clear accessibility label.
- Use input masks only when they help; do not make editing or pasting difficult.
- Keep prefix, suffix, currency, country code, and unit behavior locale-aware.
- Mark required and optional fields explicitly; validate phone, postal, and address requirements from the selected country's rules rather than applying one global rule.
- Focus the first invalid field on submit and announce the error accessibly.
- Avoid disabling the primary submit button without explaining what is missing; inline guidance is often clearer.
- Keep the active field and next action visible above the keyboard.

### Form layout

- One-column forms are the mobile default.
- Group related fields under clear section titles.
- Use 12–16 between closely related fields and 24–32 between sections.
- Put legal or explanatory copy near the action it affects, not in a remote footer.
- Use selection controls for constrained choices instead of free text.
- For long flows, split by user task rather than by arbitrary field count.
- Preserve progress and draft state when navigation is interrupted.

## Cards and grouped content

- Use a card only when the content needs a distinct surface, grouping boundary, or interaction container.
- Do not place every section in a card.
- Default card radius: 16.
- Default card padding: 16; use 20–24 for large feature cards.
- Use either a subtle border or Level 1 elevation for ordinary cards. Avoid using both by default.
- Do not nest cards unless the inner element has a clearly different semantic role.
- Keep card actions close to the content they affect.
- A tappable card needs pressed feedback and a clear accessibility role.
- Do not make only a tiny chevron tappable when the whole row represents the destination.
- Align card content to the screen grid.
- Avoid floating cards over a gray background simply because it is a common template look; lists or sections may be clearer.

## Lists and rows

- Typical row minimum: 52–56, increasing with multiline content.
- Horizontal padding: 16.
- Icon or avatar to text gap: 12.
- Keep title, subtitle, metadata, and trailing action hierarchy distinct.
- Use inset dividers for dense lists.
- Let the entire row be the target when it opens one destination.
- Use checkmarks, radio controls, or switches according to selection semantics.
- Do not place a switch on a row that also navigates unless the interaction zones are unmistakable.
- Preserve scroll position and selected state.
- Skeleton rows should match real row geometry.

## Top app bars

### Shared custom fallback

- Content height: 56, excluding status-bar or top safe-area inset.
- Horizontal margin: 16.
- Gap between actions: 8.
- Icon visual size: 20–24 with platform hit-area minimum.
- Page title: typically 20–24 semibold depending hierarchy.
- Do not vertically center against the full physical top area; account for the safe area separately.

### Behavior

- Prefer native platform app bars and navigation bars when available.
- Include only screen-level actions.
- Keep a clear back affordance and native gesture behavior.
- A large-title pattern is appropriate for top-level content, not every detail screen.
- Avoid centered titles when multiple uneven actions make the bar feel optically unbalanced; follow platform convention.
- Do not add a bottom shadow if a divider, edge effect, or content scroll treatment already provides separation.
- Search may live in the bar only when it is a major screen function.

## Bottom navigation and tab bars

- Use for 3–5 top-level destinations.
- Keep destination labels short and stable.
- Use 24-unit icons and 12–14 labels.
- Respect the bottom safe area or gesture inset.
- Preserve each tab's navigation stack and scroll position when appropriate.
- The selected state must be visible by more than color alone when possible: weight, fill, indicator, or shape can help.
- Do not place contextual actions in top-level navigation.
- Do not use a bottom bar for a linear next/back flow.
- Do not hide the bar unpredictably; when it minimizes on scroll, follow native platform behavior.
- Use a “More” destination or a different information architecture rather than squeezing more than five primary destinations.

## Tabs and segmented controls

- Use tabs for peer content views within the same context.
- Use segmented controls for a small mutually exclusive mode or filter.
- Keep labels concise and avoid wrapping.
- The selected state must remain clear in light, dark, high-contrast, and translucent contexts.
- Support swipe between pages only when it does not conflict with navigation gestures or horizontal content.
- Do not use tabs as decoration for two unrelated actions.

## Chips and badges

- Chips represent filters, compact choices, or attributes.
- Typical visible height: 32–36, with the surrounding target expanded when interactive.
- Use 12–14 medium labels.
- Keep padding and radius consistent.
- Selected and unselected states must be distinct without relying only on a subtle border color.
- Badges communicate count or status; they are not buttons unless explicitly built as controls.
- Cap large counts or provide a stable layout so badge width does not break surrounding content.
- Avoid a page full of colorful chips; use them only where compact selection is the right interaction.

## Sheets, dialogs, and menus

### Bottom sheets

- Prefer the platform-native sheet.
- Use a visible drag handle only when the sheet is draggable.
- Respect top and bottom safe areas.
- Use a 24 top radius for custom fallback sheets.
- Keep the main action reachable and the content scrollable.
- Avoid nesting scroll views with competing gestures.
- Use detents or sizes based on task and content, not arbitrary percentages.
- Do not use a sheet for a complex task that needs full-screen navigation and deep focus.

### Dialogs

- Use for important interruption, confirmation, permission explanation, or a short decision.
- Keep the title and message concise.
- Prefer one primary action and one cancel action.
- Destructive action labeling must name the consequence.
- Do not put long forms or large content sets in a small dialog.
- Use native alert behavior and focus order.

### Menus

- Use for secondary actions that do not need to remain visible.
- Group related items, order by frequency, and separate destructive actions.
- Use familiar icons consistently, but do not add icons to every item without value.
- Anchor menus to their source control.
- Avoid hiding the screen's primary action in an overflow menu.

## Feedback and status states

### Loading

- Use an inline spinner for a local action.
- Use a skeleton when the content structure is known and loading lasts long enough to notice.
- Match skeleton geometry to real content.
- Do not show many independent spinners.
- Prevent duplicate submission while preserving user confidence.
- When progress is measurable, show determinate progress.
- Avoid blocking the entire screen for a small local update.

### Empty states

- Explain what is empty and why it matters.
- Offer the most relevant next action when one exists.
- Keep illustration secondary and product-specific.
- Distinguish first-use empty, filtered empty, permission empty, offline empty, and true no-data states.
- Do not use generic motivational copy.

### Errors

- State what happened in plain language.
- Explain the recovery path.
- Keep user-entered data.
- Use inline errors for local problems and screen-level errors for screen-level failure.
- Provide Retry only when retry can reasonably work.
- Do not expose raw technical errors to end users.
- Use red with text or icon, not color alone.

### Success

- Confirm success at the right scope.
- Avoid a full-screen celebration for routine actions.
- Use transient feedback for reversible, low-risk actions.
- Include the resulting state, not only a toast saying “Success”.

### Offline and stale data

- Show whether content is cached, stale, or unavailable.
- Allow useful offline actions when the product supports them.
- Queue and communicate pending changes.
- Avoid replacing available cached content with a blank error screen.

## Search

- Use a standard search field with clear affordance and cancel/clear behavior.
- Search placement should match how central it is to the screen.
- Keep recent, suggested, loading, no-results, offline, and error states distinct.
- Preserve the query while filters or detail views are opened.
- Debounce remote search without making typing feel unresponsive.
- Highlight matching terms only when it improves scanning.
- Provide accessible announcements for result count changes.
- In Arabic, ensure query, results, numerals, and mixed-direction values render correctly.

## Media and data visualization

- Preserve media aspect ratio and define fit/crop behavior.
- Keep text readable over images with a gradient scrim or solid surface only when needed.
- Do not place critical controls over unpredictable image regions.
- Charts need labels, units, accessible summaries, and non-color differentiation.
- Chart direction in Arabic depends on the domain and locale; do not mirror all data blindly.
- Avoid decorative charts with fake or unexplained data.
- Provide empty, loading, partial, and error states for media and charts.
