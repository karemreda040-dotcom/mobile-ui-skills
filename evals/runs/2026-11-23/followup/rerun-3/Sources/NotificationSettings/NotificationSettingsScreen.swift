import SwiftUI

public enum NotificationCategory: String, CaseIterable, Codable, Identifiable, Sendable {
    case account = "Account activity"
    case payments = "Payments"
    case insights = "Insights"

    public var id: String { rawValue }

    var detail: String {
        switch self {
        case .account: "Security and sign-in updates"
        case .payments: "Payment and transfer status"
        case .insights: "Spending summaries and helpful reminders"
        }
    }

    var accessibilityHint: String {
        "Controls \(rawValue) notifications"
    }
}

public struct NotificationPreferences: Equatable, Codable, Sendable {
    public var accountNotificationsEnabled: Bool
    public var enabledCategories: Set<NotificationCategory>

    public init(
        accountNotificationsEnabled: Bool = true,
        enabledCategories: Set<NotificationCategory> = Set(NotificationCategory.allCases)
    ) {
        self.accountNotificationsEnabled = accountNotificationsEnabled
        self.enabledCategories = enabledCategories
    }
}

/// Persistence boundary. The screen never reaches into app-wide settings or
/// system notification permissions directly.
@MainActor
public protocol NotificationPreferencesStore: AnyObject {
    func load() -> NotificationPreferences
    func save(_ preferences: NotificationPreferences)
}

@MainActor
public final class UserDefaultsNotificationPreferencesStore: NotificationPreferencesStore {
    private let defaults: UserDefaults
    private let key: String

    public init(defaults: UserDefaults = .standard, key: String = "notification-preferences") {
        self.defaults = defaults
        self.key = key
    }

    public func load() -> NotificationPreferences {
        guard let data = defaults.data(forKey: key),
              let preferences = try? JSONDecoder().decode(NotificationPreferences.self, from: data)
        else { return NotificationPreferences() }
        return preferences
    }

    public func save(_ preferences: NotificationPreferences) {
        guard let data = try? JSONEncoder().encode(preferences) else { return }
        defaults.set(data, forKey: key)
    }
}

@MainActor
public final class NotificationSettingsViewModel: ObservableObject {
    @Published public private(set) var preferences: NotificationPreferences
    private let store: NotificationPreferencesStore

    public init(store: NotificationPreferencesStore) {
        self.store = store
        preferences = store.load()
    }

    public func setAccountNotifications(_ enabled: Bool) {
        preferences.accountNotificationsEnabled = enabled
        persist()
    }

    public func setCategory(_ category: NotificationCategory, enabled: Bool) {
        if enabled {
            preferences.enabledCategories.insert(category)
        } else {
            preferences.enabledCategories.remove(category)
        }
        persist()
    }

    private func persist() { store.save(preferences) }
}

@MainActor
public struct NotificationSettingsScreen: View {
    @StateObject private var viewModel: NotificationSettingsViewModel

    public init(store: NotificationPreferencesStore) {
        _viewModel = StateObject(wrappedValue: NotificationSettingsViewModel(store: store))
    }

    public init() {
        self.init(store: UserDefaultsNotificationPreferencesStore())
    }

    public var body: some View {
        List {
            Section {
                Toggle(
                    "Notifications for this account",
                    isOn: Binding(
                        get: { viewModel.preferences.accountNotificationsEnabled },
                        set: { enabled in
                            viewModel.setAccountNotifications(enabled)
                        }
                    )
                )
                .accessibilityHint("Turns all account notifications on or off")
            } footer: {
                Text("When this is off, category preferences are kept but no notifications are delivered.")
            }

            Section("Notification categories") {
                ForEach(NotificationCategory.allCases) { category in
                    Toggle(isOn: Binding(
                        get: { viewModel.preferences.enabledCategories.contains(category) },
                        set: { viewModel.setCategory(category, enabled: $0) }
                    )) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.rawValue)
                            Text(category.detail)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .disabled(!viewModel.preferences.accountNotificationsEnabled)
                    .accessibilityHint(
                        viewModel.preferences.accountNotificationsEnabled
                            ? category.accessibilityHint
                            : "Enable account notifications to change this category"
                    )
                }
            }
        }
        .navigationTitle("Notifications")
    }
}

#if DEBUG
#Preview {
    NavigationStack { NotificationSettingsScreen() }
}
#endif
