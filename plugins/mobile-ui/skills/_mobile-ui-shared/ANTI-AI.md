# Anti-AI Visual Quality Rules

The goal is not to hide that tools were used. The goal is to avoid generic, decorative, context-free output that does not look like a real product decision.

## Start from product truth

Before styling, identify:

- The user's actual task.
- The information that must be seen first.
- The real product vocabulary and data.
- Existing brand and component patterns.
- Platform expectations.
- Operational states and edge cases.

A human-designed interface usually feels specific because it reflects the product's content, constraints, and behavior.

## Common AI-looking patterns to avoid

- Purple-blue gradient as an automatic primary style.
- Gradient text.
- Glassmorphism on every card.
- Heavy shadow under every white surface.
- A gray page containing many identical floating cards.
- Excessively large hero text on a utility screen.
- Centered composition for workflows that need scanning and comparison.
- Pill-shaped everything.
- Huge rounded corners on small controls.
- Random decorative blobs, sparkles, glows, rings, or floating orbs.
- Emoji used as the main icon system.
- Mixed icon families and inconsistent stroke weights.
- Every section introduced by an icon badge.
- Repeated three-card feature layouts with generic copy.
- Too many badges and status chips.
- Fake statistics, testimonials, user names, or activity.
- Generic phrases such as “Unlock your potential”, “Seamless experience”, or “Everything you need”.
- Empty states with unrelated illustrations.
- Large whitespace that hides basic content below the fold.
- Multiple equally loud CTAs.
- Borders around every item.
- Shadow, border, tint, and blur applied to the same component.
- Decorative charts without meaningful data or units.
- Animation added merely because the framework supports it.
- Rebuilding familiar native controls as unfamiliar custom widgets.
- Copying iOS glass onto Android without a product reason.
- Copying Material expressive shapes into an otherwise restrained iOS app.
- Redesigning the whole app when asked to fix one screen.

## Human-craft pass

Run this pass after the functional layout works.

1. **Specificity**
   - Replace generic copy with product language already present in the project.
   - Use real states and realistic data from the codebase or supplied requirements.
   - Remove invented claims and filler.

2. **Hierarchy**
   - Identify the one strongest element.
   - Reduce competition from secondary actions, badges, and decorative surfaces.
   - Make section boundaries clear through spacing before adding containers.

3. **Alignment**
   - Check repeated left/right or leading/trailing edges.
   - Align text baselines, icons, dividers, and card content.
   - Apply small optical corrections where mathematically centered elements still look wrong.

4. **Spacing**
   - Replace arbitrary values with tokens.
   - Ensure related items are closer than unrelated groups.
   - Compare top, bottom, and section spacing for a deliberate rhythm.

5. **Shape**
   - Reduce the number of corner-radius values.
   - Remove pills that are not semantically pills.
   - Avoid nested rounded rectangles.

6. **Color**
   - Limit accent use.
   - Make neutral hierarchy readable.
   - Remove unnecessary gradients and colored backgrounds.
   - Confirm status meaning does not rely on color alone.

7. **Depth**
   - Remove unnecessary shadows.
   - Use one elevation model.
   - Reserve floating depth for actually floating elements.

8. **Content density**
   - Keep enough information for confident action.
   - Do not oversimplify a professional workflow into large empty cards.
   - Do not compress critical labels or metadata to create a “clean” screenshot.

9. **Platform**
   - Restore native gestures, bars, controls, feedback, and accessibility behavior where a custom treatment weakened them.
   - Keep cross-platform branding without making both platforms behave identically.

10. **Restraint**
    - Remove at least one decorative element and verify whether the design improves.
    - Keep the element only when its removal harms clarity, interaction, brand, or meaningful delight.

## Authenticity checks

A screen is more likely to feel product-quality when:

- It has a clear job and entry/exit path.
- It handles real states, not only the happy path.
- It uses a small coherent token system.
- It respects the existing product rather than imposing a fashionable template.
- Its components behave correctly, not just look polished in a static state.
- Its copy is specific and concise.
- Its layout survives real content, small screens, large text, RTL, and dark mode.
- Decorative decisions are few and defensible.

## Final anti-AI gate

Before finishing, answer internally:

- Could this screen belong to any random startup? If yes, make it more product-specific.
- Did styling begin before information hierarchy? If yes, correct the structure.
- Are cards, glass, gradients, pills, or shadows doing work that spacing and typography should do? If yes, simplify.
- Did any invented content enter the design? If yes, remove or label it as placeholder.
- Does each platform still feel native in behavior? If no, restore platform conventions.
- Is there one clear visual priority? If no, reduce emphasis elsewhere.
