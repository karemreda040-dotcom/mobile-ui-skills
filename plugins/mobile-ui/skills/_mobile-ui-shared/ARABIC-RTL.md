# Arabic and RTL Mobile UI

## Contents

- Typography
- Direction and alignment
- Mirroring
- Mixed-direction content
- Numbers, dates, and localization
- Components and interaction
- Testing checklist

## Typography

- Default Arabic typeface: Cairo.
- Use a complete family with the required weights; avoid synthetic bolding.
- Arabic generally needs generous line height. A 16-unit Arabic body style commonly works well around 24 line height; verify with the selected font.
- Avoid positive letter spacing and forced tracking in Arabic.
- Avoid clipping ascenders, descenders, diacritics, and stacked marks.
- Test Arabic and Latin together for baseline, visual weight, numeral height, and line height.
- Use Regular for body copy; use Medium or Semibold for concise emphasis and headings.
- Do not shrink Arabic text simply to fit a layout designed only for English.
- Avoid justified Arabic UI text; use natural alignment and readable line lengths.
- Ensure fonts render Arabic punctuation and localized numerals correctly.

## Direction and alignment

- Use semantic `leading` and `trailing`, never hardcoded `left` and `right`, for directional layout.
- Arabic paragraphs, titles, labels, and primary reading flow normally align to the right.
- Mirror the layout hierarchy, not just text alignment.
- Navigation order, lists, carousels, pagination, and directional flow should start from the right when the locale expects it.
- Keep content that has an inherent direction in that direction, even inside an RTL screen.

## Mirroring

Usually mirror:

- Back and forward arrows.
- Directional chevrons.
- Navigation order.
- Carousels and pagination direction.
- Stepper or progress flow when it represents reading or ordered navigation.
- Directional swipe actions.
- Breadcrumb-like sequences.

Usually do not mirror automatically:

- Logos and trademarks.
- Photographs and most illustrations.
- Clocks.
- Media play/pause controls.
- Download, upload, search, close, settings, and other nondirectional symbols.
- Maps, compass directions, and real-world orientation.
- Charts whose x-axis direction is defined by domain convention.

Validate ambiguous icons by meaning, not shape.

## Mixed-direction content

- Emails, URLs, file paths, code, serial numbers, and many phone-number formats are LTR inside an RTL layout.
- Use the framework's bidi isolation or direction APIs for mixed strings.
- Do not concatenate Arabic and LTR values with raw punctuation when a localized format string can control ordering.
- Test parentheses, slashes, colons, plus signs, percentages, currency, and version numbers.
- Keep icon-label order semantic after mirroring.
- Avoid embedding directional Unicode marks manually unless the framework cannot solve the case; hidden marks become hard to maintain.

## Numbers, dates, and localization

- Support the numeral system expected by the target locale; do not hardcode Western or Eastern Arabic digits globally.
- Use locale-aware formatting for dates, times, currency, decimals, percentages, units, and plurals.
- Respect regional calendar conventions.
- Keep mathematical expressions, codes, and identifiers in their conventional direction.
- Charts and timelines require domain-specific direction decisions; test with local users or product requirements.
- Allow Arabic copy expansion. Buttons, tabs, and fields must not depend on short English labels.
- Use localized action verbs, not literal word-for-word translations.
- Keep error and helper copy specific and easy to scan.

## Components and interaction

- Place primary reading content on the right and trailing metadata according to the mirrored hierarchy.
- Mirror top-bar action ordering where the platform does so.
- Ensure back gestures and transitions feel consistent with the platform's RTL behavior.
- In forms, keep labels, helper text, prefix/suffix, currency, and country codes directionally correct.
- Search fields may accept Arabic and LTR queries; preserve cursor behavior and result ordering.
- Tables and dense data may keep numeric columns LTR while the table structure is RTL.
- Do not flip imagery when doing so changes factual meaning.
- Screen-reader labels and hints must be localized, not only visually mirrored.

## Testing checklist

Test each relevant screen with:

- Arabic RTL and English LTR.
- Arabic text containing English product names.
- Emails, phone numbers, URLs, codes, prices, dates, and percentages.
- Western and Eastern Arabic numerals according to locale.
- Long Arabic labels and accessibility text sizes.
- Back arrows, chevrons, carousels, pagination, and transitions.
- Lists, forms, sheets, dialogs, search, charts, and empty/error states.
- VoiceOver or TalkBack in Arabic.
- Device locale changes without restarting assumptions.
- Screenshots at narrow phone width and tablet width.

Release blockers include:

- Wrong navigation direction.
- Clipped Arabic glyphs.
- Reordered or corrupted mixed-direction values.
- Hardcoded left/right layout.
- Mirrored logos or factual imagery.
- Unlocalized accessibility labels.
