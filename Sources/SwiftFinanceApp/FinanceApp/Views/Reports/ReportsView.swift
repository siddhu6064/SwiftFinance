import SwiftUI

struct ReportsView: View {
    private let reportCards: [ReportCard] = [
        .init(name: "Profit & Loss", description: "Revenue and margin over selected period", icon: "chart.line.uptrend.xyaxis"),
        .init(name: "Balance Sheet", description: "Assets, liabilities, and equity summary", icon: "scale.3d"),
        .init(name: "Cash Flow", description: "Operating, investing, financing cash movement", icon: "waveform.path.ecg"),
        .init(name: "Payroll Cost", description: "Payroll breakdown by team and month", icon: "banknote")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reports")
                .font(.largeTitle.weight(.semibold))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 280), spacing: 12)], spacing: 12) {
                ForEach(reportCards) { report in
                    DashboardCard(title: report.name) {
                        Label(report.description, systemImage: report.icon)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button("Open Report") {}
                            .buttonStyle(.bordered)
                    }
                }
            }
        }
    }
}

struct ReportCard: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
}
