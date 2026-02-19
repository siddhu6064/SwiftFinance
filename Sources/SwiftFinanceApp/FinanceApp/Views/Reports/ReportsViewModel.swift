import Foundation

struct ReportsViewModel {
    let reports: [ReportRow]

    static let sample = ReportsViewModel(
        reports: [
            ReportRow(name: "Profit & Loss", description: "Revenue, COGS, and net profit over time.", lastGenerated: "Generated today"),
            ReportRow(name: "Balance Sheet", description: "Assets, liabilities, and owner equity snapshot.", lastGenerated: "Generated yesterday"),
            ReportRow(name: "Cash Flow", description: "Operating, investing, and financing cash movement.", lastGenerated: "Generated 2 days ago")
        ]
    )
}

struct ReportRow: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let lastGenerated: String
}
