import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeSync = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.largeTitle.weight(.semibold))

            DashboardCard(title: "Application Preferences", subtitle: "Company and workspace controls") {
                Toggle("Enable notifications", isOn: $notificationsEnabled)
                Divider()
                Toggle("Match system appearance", isOn: $darkModeSync)
            }
        }
    }
}
