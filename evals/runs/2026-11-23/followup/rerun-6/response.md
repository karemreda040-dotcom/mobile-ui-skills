# Arabic operations dashboard — delivery note

## Created

`operations-dashboard-ar.md` is an implementation-ready RTL Android mobile-dashboard specification. It includes the information hierarchy, phone wireframe, exact component/state contracts, semantic token choices, Arabic/RTL and bidirectional behavior, chart/timeline behavior, responsiveness, accessibility, and host integration plan.

## Intentional platform decisions

- Android Material 3 / Jetpack Compose is the stated implementation target, with native system back, insets, ripple/focus feedback, and 48 dp minimum interaction targets.
- The page uses a restrained hierarchy: KPI summary, attention-required alerts, a small labelled chart, then an activity timeline. It does not add decorative cards, glass, gradients, or a bottom navigation bar to a read-only operations view.
- All KPI, alert, timeline, and chart values are marked as **example-only**; the document defines the data contract rather than inventing a live product feed.
- Arabic is a true RTL layout, while mixed strings and the chart’s temporal direction are explicitly handled by meaning rather than indiscriminate mirroring.

## Checks actually performed

- Manual artifact review against the supplied mobile-UI guidance: scoped goal/entry/exit path; visual hierarchy; semantic fallback colors; 16 dp grid; 48 dp minimum targets; normal-text contrast guidance; loading/empty/error/partial/stale states; Arabic RTL/mixed-direction behavior; chart labels, units, text summary, and non-color cue; 2× text-scale and wider-layout rules.
- Directory inspection confirmed no existing implementation or data source to reuse.

## Not performed / limits

No Android/Compose codebase, Gradle wrapper, SDK/emulator, device, renderer, or actual operations data exists in this rerun. Therefore no compilation, runtime preview, screenshot, TalkBack, locale, contrast-ratio measurement, or responsive-device test was executed. The document deliberately remains a compact design handoff rather than creating a broad application scaffold.
