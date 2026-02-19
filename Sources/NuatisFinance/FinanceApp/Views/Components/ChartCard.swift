import Charts
import SwiftUI

struct ChartCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        DashboardCard(title: title) {
            content
                .frame(height: 220)
        }
    }
}
