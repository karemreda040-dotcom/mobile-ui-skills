# Mobile UI Foundations

## Contents

- Decision rules
- Visual design principles
- Units and density
- Typography
- Spacing and grid
- Color
- Shape, borders, and elevation
- Glass and translucency
- Iconography and imagery
- Motion and feedback
- Adaptive layout
- Accessibility

## Decision rules

- Product consistency beats isolated beauty.
- Clarity beats novelty.
- Familiar interaction beats custom behavior.
- A single strong hierarchy beats many competing highlights.
- Use the fewest visual tools needed to communicate grouping and priority.
- When a platform-native component already solves the problem well, use it and theme it rather than recreating it.

## Principles of visual design

Apply these as operational checks, not decorative theory.

1. **Balance**
   - Distribute visual weight intentionally across the screen.
   - Balance does not require symmetry; content density, color, image weight, and whitespace all affect it.

2. **Contrast**
   - Create meaningful distinction in size, weight, color, shape, spacing, or position.
   - Do not rely on tiny weight changes or nearly identical gray values to create hierarchy.

3. **Hierarchy and emphasis**
   - The first glance should reveal the screen purpose, current state, and primary action.
   - Limit the number of elements competing at the highest emphasis level.

4. **Alignment**
   - Reuse a small set of alignment edges and baselines.
   - Correct optical misalignment for icons and rounded shapes instead of relying only on mathematical centering.

5. **Proximity**
   - Place related items close together and separate unrelated groups more strongly.
   - Internal component spacing must be smaller than spacing between groups.

6. **Repetition and consistency**
   - Reuse type roles, spacing tokens, radii, colors, icon style, and interaction behavior.
   - Same appearance means same behavior; same behavior should usually share the same appearance.

7. **Scale and proportion**
   - Size reflects importance and interaction needs.
   - Avoid making every element large, bold, rounded, or full width.

8. **Rhythm**
   - Build a predictable vertical cadence using a limited spacing scale.
   - Repeated list rows and cards should align without tiny one-off offsets.

9. **Whitespace**
   - Use whitespace to clarify grouping and reduce cognitive load.
   - Do not use excessive empty space that pushes important content below the fold without a reason.

10. **Unity and harmony**
    - Components should feel like one product, not a collage of trends or libraries.
    - Keep one dominant visual idea and let content provide variety.

11. **Clarity and simplicity**
    - Remove anything that does not improve understanding, action, brand, or delight.
    - Simplicity means removing ambiguity, not removing useful information.

## Units and density

- iOS layout uses points.
- Android layout uses `dp`; Android type uses `sp`.
- Flutter, React Native, and similar frameworks use logical units that map to density-independent dimensions.
- Design specifications may call these values `px` informally, but implementation must treat them as logical units, never physical display pixels.
- Use integer tokens in normal layout. Fractional values are acceptable only for hairlines, optical corrections, or platform-rendering needs.

## Typography

### Default product type scale

Use this reduced scale when the project has no established system. Do not use every role on every screen.

| Role | Size / line height | Weight | Primary use |
|---|---:|---:|---|
| Display / Hero | 32 / 40 | Bold 700 | Rare hero or milestone moment |
| Heading 1 | 24 / 32 | Semibold 600 | Page title |
| Heading 2 | 20 / 28 | Semibold 600 | Major section title |
| Title | 18 / 24 | Semibold 600 | Card, row, or dialog title |
| Subtitle | 16 / 24 | Medium 500 | Supporting heading or emphasized metadata |
| Body Large | 16 / 24 | Regular 400 | Primary reading text |
| Body | 14 / 20 | Regular 400 | Secondary body, dense product UI |
| Body Emphasis | 14 / 20 | Medium 500 | Emphasis inside body copy |
| Label | 14 / 20 | Medium 500 | Fields, chips, compact controls |
| Button | 16 / 20 | Semibold 600 | Standard CTA; use 14 / 20 for compact actions |
| Caption | 12 / 16 | Regular or Medium | Metadata and tertiary information |
| Navigation | 12–14 / 16–20 | Medium 500 | Tab and bottom-navigation labels |

### Corrections to the initial draft

- Do not use both `Heading 1: 24 semibold` and `Sub-header: 24 medium` as separate hierarchy levels. They are visually too similar. Keep 24 semibold for the page title and use 20 semibold or 16 medium for subordinate headings.
- Long-form or multi-line body text should normally be Regular, not Medium. Use Medium only for emphasis.
- Do not choose 16 or 18 for the same CTA arbitrarily. Use 16 by default; reserve 18 for unusually large, prominent controls.
- A screen should usually use 4–6 type roles, not the whole scale.

### Typeface rules

- English default: **Inter** for product UI.
- **Poppins** is optional for brand-forward headings or marketing moments; avoid it as the default dense body face unless the product already uses it.
- Arabic default: **Cairo**.
- Prefer the native system font for strongly native iOS or Android products unless custom branding requires otherwise.
- For mixed Arabic and Latin content, test cap height, baseline, numeral style, line height, and visual weight together.
- Avoid synthetic weights when the font file does not provide them.
- Avoid letter spacing in Arabic. Use restrained tracking in Latin labels only when the typeface needs it.
- Never use font size alone as the only hierarchy signal; combine size with weight, spacing, and position.
- Avoid more than three weights on one screen.
- Allow text to wrap where meaning matters. Truncate only when there is a clear way to access the full value.

## Spacing and grid

### Spacing scale

Use a 4-unit base:

`0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64`

Common assignments:

- 4: icon-to-label micro gap, tightly related metadata.
- 8: standard internal gap, adjacent controls, compact row content.
- 12: related text blocks or compact card groups.
- 16: screen margin, standard component padding, field gap.
- 20: comfortable card padding or medium group separation.
- 24: section separation.
- 32: major section separation.
- 40–64: large editorial or onboarding separation, used sparingly.

### Mobile grid

- Phone default: 4-column grid, 16-unit outer margins, 16-unit gutters.
- Narrow devices: keep at least 16-unit margins unless a full-bleed content pattern is intentional.
- Large phones: 16–20-unit margins are acceptable.
- Tablets: use 8 or 12 columns, 24–32-unit margins, and a readable maximum content width.
- Full-bleed media may cross the grid; controls and readable text should return to the content margin.
- Do not treat the grid gutter as the default spacing between every object. Use the spacing scale according to relationship.

### Vertical rhythm

- Keep internal component spacing smaller than external section spacing.
- Typical card padding: 16; use 20 or 24 for spacious cards.
- Typical list row horizontal padding: 16.
- Typical section gap: 24; major transition: 32.
- Avoid isolated values such as 13, 17, 19, or 27 unless an existing design system requires them or an optical correction is documented.

## Color

### Semantic use

Always name colors by purpose, not by raw appearance:

- `background`
- `surface`
- `surface-subtle`
- `text-primary`
- `text-secondary`
- `text-disabled`
- `border`
- `primary`
- `error`
- `success`
- `warning`
- `info`
- container variants for status feedback

Use [TOKENS.json](TOKENS.json) when no project palette exists.

### Light fallback palette

- Main screen background: `#F7F7F7`
- Main surface and cards: `#FFFFFF`
- Standard border: `#E0E0E0`
- Primary text: `#171717`
- Secondary text: `#5F6368`
- Tertiary text that still needs normal-text contrast: `#6B7280`
- Primary fallback: `#2563EB`
- Error: `#D92D20`
- Success: `#15803D`
- Warning: `#B54708`
- Info: `#175CD3`

### Important gray correction

`#808080` on white is too weak for ordinary small text. Reserve it for disabled, inactive, or nonessential information, where contrast requirements may differ. Use `#5F6368` or `#6B7280` for readable secondary text.

### Color behavior

- Use one primary brand accent, plus semantic status colors.
- Primary color should identify important actions and active states, not decorate every section.
- Avoid pure black for large UI regions; use a near-black neutral for better tonal control.
- Avoid low-contrast gray-on-gray interfaces.
- Do not use red for neutral actions.
- Pair status colors with an icon and text.
- Disabled styling must remain understandable without appearing active.
- Derive dark mode semantically; do not simply invert the light palette.
- Test colors over actual backgrounds, including translucent and image-based surfaces.

## Shape, borders, and elevation

### Radius scale

- 4: tiny details and progress indicators.
- 8: compact controls.
- 12: fields, buttons, and standard controls.
- 16: cards and grouped surfaces.
- 20: large feature surfaces.
- 24: sheets, large dialogs, or expressive containers.
- Full: avatars, circular icon buttons, and true pill controls.

Do not make every component a pill. Limit a screen to a small, intentional radius family.

### Borders

- Default border: 1 logical unit.
- Strong focus or selected outline: 2 units where appropriate.
- Use a divider for dense lists rather than wrapping every row in a card.
- Do not combine border, tinted fill, and shadow unless each communicates a distinct state or layer.

### Shadow and elevation fallback

Use the lightest level that makes the hierarchy legible:

- Level 0: none.
- Level 1: `0 1 2 rgba(16, 24, 40, 0.06)`.
- Level 2: `0 4 12 rgba(16, 24, 40, 0.08)`.
- Level 3: `0 8 24 rgba(16, 24, 40, 0.12)`.

Rules:

- Prefer borders or tonal surfaces for ordinary cards.
- Reserve stronger elevation for floating controls, sheets, menus, and transient overlays.
- On Android, prefer Material elevation and tonal surface behavior over CSS-like shadows.
- Shadows should not be the only indication that an item is interactive.
- Avoid heavy black shadows, large blur with high opacity, and multiple shadow colors.

## Glass and translucency

Glass is a functional layer, not a general card style.

- Use native system materials when available.
- On current iOS, reserve Liquid Glass primarily for navigation and controls floating above content.
- Do not place glass on content cards by default.
- Do not nest glass inside glass.
- Keep important text off visually busy translucent backgrounds unless a scrim guarantees contrast.
- Respect Reduce Transparency, Increase Contrast, and Reduced Motion.
- On Android, prefer Material tonal surfaces and elevation. Do not imitate iOS glass unless the product explicitly uses a shared glass language.
- For a non-native fallback only: use restrained translucency, 16–24 blur, a subtle light border, and Level 1 shadow. Validate performance and contrast on real devices.

## Iconography and imagery

- Use one icon family per platform or product.
- Default icon size: 24; compact: 20; inline: 16.
- Keep the interactive container larger than the icon.
- Use SF Symbols for native iOS and Material Symbols for native Android unless the product has its own coherent set.
- Do not mix outlined, filled, rounded, sharp, and duotone styles without a state-based rule.
- Use labels for unfamiliar actions.
- Provide accessible names based on purpose, not visual description.
- Preserve image aspect ratio and define crop behavior.
- Do not add decorative illustrations or generic AI imagery merely to fill empty space.
- Use real, product-relevant media when available.

## Motion and feedback

- Motion must explain state change, spatial relationship, hierarchy, or cause and effect.
- Fast feedback: roughly 100–180 ms.
- Standard component transition: roughly 180–260 ms.
- Large navigation or sheet transition: roughly 250–400 ms, preferably native.
- Use springs only when they support direct manipulation or platform character.
- Keep animations interruptible where the platform supports it.
- Provide pressed or ripple feedback immediately.
- Use haptics sparingly for meaningful confirmation, selection, warning, or failure.
- Respect Reduced Motion and avoid auto-playing decorative loops.
- Do not animate layout in a way that moves the user's target during interaction.

## Adaptive layout

Test at minimum:

- A narrow phone width around 320 logical units.
- A common phone width around 375–393.
- A large phone width around 430.
- Landscape where the flow supports it.
- Tablet or foldable width when included in product scope.
- Large text scaling.
- Arabic RTL and mixed-direction content.

Rules:

- Prefer constraints, wrapping, and content-driven height.
- Avoid fixed screen-height assumptions.
- Maintain reachable primary actions without hiding critical content behind the keyboard.
- On tablets, do not stretch phone cards edge to edge; use columns, panes, or a readable max width.
- Preserve context when switching tabs, rotating, or resizing.
- Treat orientation and width as layout inputs, not as separate hardcoded screens.

## Accessibility

- Normal text contrast: at least 4.5:1.
- Large text and meaningful UI graphics/boundaries: at least 3:1.
- iOS hit area: at least 44 × 44 pt.
- Android hit area: at least 48 × 48 dp.
- Support text resizing without loss of content or function.
- Use semantic controls and correct roles.
- Provide labels, values, hints, and state announcements where needed.
- Keep focus and reading order aligned with visual order.
- Do not encode meaning using color alone.
- Provide alternatives for swipe-only, drag-only, or long-press-only actions.
- Respect screen readers, bold text, increased contrast, reduced transparency, reduced motion, and system font scaling.
- Avoid time limits; when unavoidable, allow extension or pause.
- Use plain, specific copy for errors and actions.
