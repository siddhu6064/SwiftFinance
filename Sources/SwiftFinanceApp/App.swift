import SwiftUI

@main
struct FinanceApp: App {
    private let coreData = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            MainWindow()
                .environment(\.managedObjectContext, coreData.container.viewContext)
        }
        .windowResizability(.automatic)
    }
}
