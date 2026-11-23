import XCTest
@testable import NotificationSettings

@MainActor
private final class MemoryStore: NotificationPreferencesStore {
    var value: NotificationPreferences
    private(set) var saveCount = 0

    init(_ value: NotificationPreferences = NotificationPreferences()) { self.value = value }
    func load() -> NotificationPreferences { value }
    func save(_ preferences: NotificationPreferences) { value = preferences; saveCount += 1 }
}

@MainActor
final class NotificationSettingsTests: XCTestCase {
    func testAccountTogglePersistsWithoutDiscardingCategoryChoices() {
        let store = MemoryStore(NotificationPreferences(enabledCategories: [.account, .payments]))
        let viewModel = NotificationSettingsViewModel(store: store)

        viewModel.setAccountNotifications(false)

        XCTAssertFalse(store.value.accountNotificationsEnabled)
        XCTAssertEqual(store.value.enabledCategories, [.account, .payments])
    }

    func testCategoryTogglePersistsSelection() {
        let store = MemoryStore()
        let viewModel = NotificationSettingsViewModel(store: store)

        viewModel.setCategory(.insights, enabled: false)

        XCTAssertFalse(store.value.enabledCategories.contains(.insights))
        XCTAssertEqual(store.saveCount, 1)
    }
}
