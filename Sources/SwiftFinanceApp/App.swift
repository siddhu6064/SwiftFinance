import SwiftUI

@main
struct FinanceApp: App {
    var body: some Scene {
        WindowGroup {
            MainWindow()
                .frame(minWidth: 1280, minHeight: 820)
        }
        .windowResizability(.contentSize)
    }
}
