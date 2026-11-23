# Notification settings (SwiftUI)

Created a focused SwiftUI notification-settings source package with account-level and category-level notification toggles.

## Plan applied

1. Use native SwiftUI `List`, `Section`, and `Toggle` controls for expected iOS behavior, Dynamic Type, and VoiceOver semantics.
2. Keep the account-level preference separate from category choices: turning the account preference off disables delivery without deleting the category choices.
3. Persist through an injected local boundary only; do not modify system permissions or call a service.

## Platform and accessibility decisions

- Native `NavigationStack`-compatible screen with an iOS navigation title and standard toggles (44-point platform hit areas).
- Each category supplies an explanatory subtitle; the account control explains that category settings are retained.
- Disabled category toggles expose an accessibility hint explaining how to re-enable them.
- Uses system typography and standard SwiftUI colors so Dynamic Type, contrast, light/dark appearance, and accessibility settings remain platform-managed.

## Files created

- `Package.swift`
- `Sources/NotificationSettings/NotificationSettingsScreen.swift`
- `Tests/NotificationSettingsTests/NotificationSettingsTests.swift`

`NotificationPreferencesStore` is the explicit persistence boundary. `UserDefaultsNotificationPreferencesStore` is a local implementation, and tests use an in-memory implementation.

## Validation

| Command | Result |
|---|---|
| `swift test` | Passed: 2 tests, 0 failures |

The tests verify that disabling account notifications preserves category selections and that changing a category is persisted through the injected store.

## Limits

This is a Swift package source example rather than a complete Xcode app target, so no iPhone Simulator launch or visual screenshot was produced. It intentionally does not request or mutate iOS global notification permission and has no network/service integration.
