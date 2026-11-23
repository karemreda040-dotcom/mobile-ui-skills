---
description: Audits an existing mobile UI read-only and returns a prioritized, evidence-based report of design, spacing, typography, contrast, accessibility, platform, RTL, and generic AI-generated-look problems. Use when the UI already exists and the user wants to know what is wrong before anything is changed. Never edits files.
when_to_use: Trigger for mobile design review, visual QA, UI health check, or inspecting an AI-generated app's interface before refactoring it.
argument-hint: "[screen, path, screenshot, or whole-app scope to audit]"
disable-model-invocation: true
disallowed-tools: Edit, Write, NotebookEdit
---

# Audit Mobile UI

Inspect the requested mobile UI and return a precise, prioritized, evidence-based report. **This skill is read-only.**

**Scope:** $ARGUMENTS

## Read-only rule

Claude Code hosts may honor this skill's `disallowed-tools` frontmatter. In every environment, treat this workflow as read-only and use host read-only permissions when they are available. In addition:

- Do not run any shell command that mutates source files, dependencies, generated files, Git state, or configuration.
- Read-only shell inspection (`ls`, `grep`, `cat`, `git diff`, `git log`) is allowed.
- Do not install packages. Do not create files. Do not stage or commit.

If the user asks you to fix something during this invocation, tell them to run the fix skill instead.

## Authority order

Judge the UI against this order — not against personal taste:

1. Explicit user requirements, product constraints, and accessibility needs.
2. The project's existing design system, brand, tokens, components, and code conventions.
3. Native platform conventions for the target OS.
4. The fallback system in [../_mobile-ui-shared/TOKENS.json](../_mobile-ui-shared/TOKENS.json).

A deliberate, coherent product style is **not** a finding. Only flag it when it breaks usability, accessibility, platform behavior, or its own internal consistency.

## Workflow

### 1. Establish the scope

Determine what you are auditing: a single screen, a flow, a component set, a screenshot, or the whole app. Identify the framework, platform, and whether Arabic/RTL is in scope. If given a screenshot path, read the image.

### 2. Read the design system first

Before judging any screen, read the project's theme, tokens, and shared components. Most real findings are *inconsistencies against the project's own system*, which you cannot see without reading it.

### 3. Inspect

Check, at minimum:

- Typography: scale, weights, line height, hierarchy, number of weights in use.
- Spacing: rhythm, screen margins, gutters, group-vs-section gaps, arbitrary values.
- Grid and alignment: shared edges, baselines, absolute positioning misuse.
- Visual hierarchy and emphasis: competing primary actions, uniform emphasis.
- Color and contrast: measured ratios, status-by-color-alone, invented brand colors.
- Radius, borders, elevation, shadows: mixed nearby values, shadow on everything.
- Component states: default, pressed, focused, selected, disabled, loading, error.
- Screen states: loading, skeleton, empty, error, offline, permission, success, retry.
- Touch targets: 44 pt iOS / 48 dp Android minimum.
- Safe areas, notch, home indicator, keyboard insets.
- Navigation and platform fidelity: iOS patterns on Android or vice-versa.
- Localization, RTL, mixed-direction content, long Arabic labels.
- Text scaling and small-screen overflow.
- Duplicated one-off values and missed shared-component opportunities.
- Generic AI-generated patterns per `ANTI-AI.md`.

### 4. Report

Order findings by severity: **Blocker → High → Medium → Polish.**

Accessibility failures that block use are Blocker or High — never Polish.

Only report observed defects as confirmed findings. Before claiming missing safe-area handling, navigation ownership, or asynchronous states, inspect the relevant parent, navigator, and caller code. If that evidence is unavailable, list it separately as an **Unverified question** with the evidence needed; do not assign it a severity or prescribe it as a confirmed fix. Consolidate overlapping symptoms into the one finding that identifies the shared cause.

Every finding must have this exact shape:

```
High — Inconsistent screen margins

Location:
src/screens/Home.tsx:42
src/screens/Profile.tsx:31

Evidence:
Home uses 20. Profile uses 16. Settings uses 24.

Problem:
Primary screen alignment shifts between routes and breaks the app-wide grid.

Recommended correction:
Introduce a semantic `screenHorizontalPadding` token with a default of 16.

Fix location:
Shared theme token — not three screen-level patches.
```

A finding without a concrete location, an observed value, and an exact correction is not a finding. Never write subjective comments like "make it more modern" or "the spacing could be better."

### 5. Close

End with:

1. Top priorities in execution order (tokens → shared components → screens).
2. A ready-to-paste fix invocation scoped to the confirmed findings, e.g.
   `/mobile-ui:fix Apply the Blocker and High findings from the audit above.`

## Reference routing

Always read `ANTI-AI.md` and `REVIEW-CHECKLIST.md`. Read the rest as the scope requires.

- Typography, spacing, color, radius, elevation, glass, motion, accessibility → [../_mobile-ui-shared/FOUNDATIONS.md](../_mobile-ui-shared/FOUNDATIONS.md)
- Buttons, fields, cards, lists, navigation, sheets, forms, UI states → [../_mobile-ui-shared/COMPONENTS.md](../_mobile-ui-shared/COMPONENTS.md)
- iOS conventions and Liquid Glass → [../_mobile-ui-shared/PLATFORM-IOS.md](../_mobile-ui-shared/PLATFORM-IOS.md)
- Android and Material 3 → [../_mobile-ui-shared/PLATFORM-ANDROID.md](../_mobile-ui-shared/PLATFORM-ANDROID.md)
- Arabic typography, bidi, localization, RTL → [../_mobile-ui-shared/ARABIC-RTL.md](../_mobile-ui-shared/ARABIC-RTL.md)
- Generic / AI-generated patterns → [../_mobile-ui-shared/ANTI-AI.md](../_mobile-ui-shared/ANTI-AI.md)
- Severity gates and final QA → [../_mobile-ui-shared/REVIEW-CHECKLIST.md](../_mobile-ui-shared/REVIEW-CHECKLIST.md)
- Fallback semantic tokens → [../_mobile-ui-shared/TOKENS.json](../_mobile-ui-shared/TOKENS.json)

## Honesty

Never claim you visually verified a rendered screen when you only read code. Say which findings come from code and which from an actual screenshot or render.
