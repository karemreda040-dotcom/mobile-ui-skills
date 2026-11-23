# Checkout address — Compose integration notes

## Screen job and flow

The checkout step collects the country, phone number, and postal code needed to continue. It is a Material 3 Android screen: a scrollable one-column form with 16 dp margins, 16 dp related-field spacing, 52 dp Material text fields, and a single full-width primary action. The host owns normal Android back navigation.

`CheckoutAddressScreen.kt` is intentionally only the screen. Its `onContinue` callback must:

1. Run `validateAddress`; retain values and focus the first invalid field when an error is returned.
2. Set `SubmitState.Submitting` and call the injected suspend `SubmitCheckoutAddress` boundary.
3. On success, navigate to the next checkout step; on failure, set `SubmitState.Failure` with a recoverable, user-safe message.

No service, storage, analytics, or country catalog is invented here. The host supplies the permitted countries and the submit implementation.

## Required states

| State | Expected behavior |
|---|---|
| Initial | Persistent labels and examples; Continue validates rather than being mysteriously disabled. |
| Field error | Inline specific error; preserve entered value and move focus to first invalid field in the host. |
| Submitting | Continue retains its footprint, shows progress, and blocks duplicate taps. |
| Submission failure | A screen-level live-region message explains that saving failed and Continue remains available to retry. |
| Keyboard / large text | `imePadding`, scrolling, and content-driven field heights keep the action and focused input reachable. |

## Accessibility and localization

- Material text fields and button provide native roles, focus, selection, ripple, and 48 dp minimum targets.
- The status failure uses an assertive live region; add localized TalkBack strings in the host resources.
- Phone and postal values use content-or-LTR direction so mixed-direction locales do not reorder identifiers. Country names and labels come from localized resources/catalog data.
- Use locale-aware postal validation in the domain layer; the UI intentionally only checks presence.
