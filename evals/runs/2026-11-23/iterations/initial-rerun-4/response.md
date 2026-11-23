# Checkout address — implementation note

## Created

`CheckoutAddressScreen.kt` is a compact Material 3 Compose implementation for a checkout delivery-details step. It uses a native Material top app bar, country chooser, phone and postal-code fields, and one 52 dp primary Continue action. The screen is edge-to-edge-aware through `Scaffold` content insets and raises above the keyboard with `imePadding()`.

## Screen plan and behaviors

- **Job and path:** the shopper provides contact/delivery details; Back returns to checkout and a successful save advances through `onComplete`.
- **Country:** a constrained Material dialog selection sets a dial-code prefix. The sample options are UI examples only; a production host supplies its actual country catalog and country-specific validation.
- **Validation:** required errors appear only after Continue is attempted; they are local, specific, and leave all entries intact. In production, validate phone and postal formats according to the selected country, not a global pattern.
- **Async boundary:** `SaveCheckoutAddress` is a suspending boundary with explicit Saved/Failed results. Pending state preserves button geometry, blocks duplicate submits, and exposes a textual error with an assertive live region; failure preserves entered values. A real app should place the coroutine/state in its ViewModel rather than this standalone source artifact.
- **Accessibility and adaptive behavior:** Material semantics/controls, 48 dp+ interactions (52 dp CTA), persistent field labels, error text adjacent to fields, normal Material text scaling, safe drawing insets, IME avoidance, and a one-column width-constrained form. At 2× text scale, content scrolls rather than clipping; the CTA follows content and remains reachable after scrolling.

## Visual decisions

Fallback Material semantic color roles are used instead of a custom palette, gradients, cards, or decorative imagery. Layout uses 16 dp horizontal margins; 16 dp related gaps and a 24 dp section transition; body text is Material `bodyLarge`, section text is `titleMedium`, and the page title is `headlineSmall`. The primary button is 52 dp, matching the large mobile CTA variant.

## Checks actually performed

- Source review: verified one clear primary action; persistent labels; post-interaction validation; recoverable failure; spinner preserves CTA footprint; no fake checkout service; no hardcoded left/right layout; `Scaffold` `contentWindowInsets` consumed; `imePadding()` present.
- API research: checked current Android documentation for `Scaffold` content-inset consumption, `Modifier.imePadding()`, AGP 9 built-in Kotlin source-set configuration, and the Compose compiler requirement. Avoided `ExposedDropdownMenuBox` because its current `menuAnchor` API/version requirements vary.
- Compilation: `:app:compileDebugKotlin --console=plain` **passed** in an isolated temporary harness using Gradle 9.1.0, AGP 9.0.1, Java 17, Android SDK API 36, Compose compiler plugin 2.2.10, and Material 3 from the Compose BOM. The harness contains a minimal `MainActivity` solely to compile the supplied source; it is not part of this screen artifact.

## Limitations / host work

The source is intentionally not a full Android project. Runtime preview/device, screenshot, TalkBack, keyboard, narrow-phone, dark-mode, and real 2× font-scale checks were not run. Wire `SaveCheckoutAddress` to the checkout use case in a lifecycle-aware ViewModel; provide a real localized country catalog and country rules; add localized strings and test IDs; then run the corresponding UI/device tests in the target app.
