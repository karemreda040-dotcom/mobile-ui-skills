import SwiftUI

/// Boundary for persisting notification choices. This demo keeps state in memory.
protocol NotificationSettingsStore {
    func save(_ settings: NotificationSettings) async throws
}

struct NotificationSettings: Equatable {
    var accountNotifications = true
    var transactionUpdates = true
    var securityAlerts = true
    var monthlySummary = false
}

struct InMemoryNotificationSettingsStore: NotificationSettingsStore {
    func save(_ settings: NotificationSettings) async throws {}
}

struct NotificationSettingsView: View {
    @State private var settings = NotificationSettings()
    @State private var saveState: SaveState = .idle

    private let store: any NotificationSettingsStore

    init(store: any NotificationSettingsStore = InMemoryNotificationSettingsStore()) {
        self.store = store
    }

    var body: some View {
        Form {
            Section {
                Toggle("Account notifications", isOn: $settings.accountNotifications)
                    .accessibilityHint("Controls all notification categories")
                    .onChange(of: settings.accountNotifications) { _, enabled in
                        if !enabled { settings.transactionUpdates = false; settings.securityAlerts = false; settings.monthlySummary = false }
                    }
            } footer: {
                Text("Turn this off to pause every account notification.")
            }

            Section {
                Toggle("Transaction updates", isOn: $settings.transactionUpdates)
                    .disabled(!settings.accountNotifications)
                Toggle("Security alerts", isOn: $settings.securityAlerts)
                    .disabled(!settings.accountNotifications)
                Toggle("Monthly summary", isOn: $settings.monthlySummary)
                    .disabled(!settings.accountNotifications)
            } header: {
                Text("Categories")
            } footer: {
                Text("Security alerts help protect your account.")
            }

            if case .failed = saveState {
                Section {
                    Label("Couldn’t save changes. Try again.", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.red)
                    Button("Try again", action: save)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: settings) { await persistSettings() }
        .accessibilityElement(children: .contain)
    }

    private func save() { Task { await persistSettings() } }

    @MainActor private func persistSettings() async {
        guard saveState != .saving else { return }
        saveState = .saving
        do { try await store.save(settings); saveState = .idle }
        catch { saveState = .failed }
    }
}

private enum SaveState: Equatable { case idle, saving, failed }
