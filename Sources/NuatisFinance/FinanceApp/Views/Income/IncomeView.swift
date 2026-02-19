import SwiftUI

struct IncomeView: View {
    private let rows: [IncomeRow] = [
        .init(source: "Subscription Revenue", amount: "$48,200", period: "Apr 2026"),
        .init(source: "Professional Services", amount: "$21,400", period: "Apr 2026"),
        .init(source: "Other Income", amount: "$3,650", period: "Apr 2026")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Income")
                .font(.largeTitle.weight(.semibold))

            DashboardCard(title: "Income Register", subtitle: "Revenue streams by period") {
                DataTable(rows: rows, columns: IncomeRow.columns)
            }
        }
    }
}

struct IncomeRow: Identifiable {
    let id = UUID()
    let source: String
    let amount: String
    let period: String

    static let columns: [TableColumnDefinition<IncomeRow>] = [
        .init(title: "Source", width: nil, content: { AnyView(Text($0.source)) }),
        .init(title: "Amount", width: 140, content: { AnyView(Text($0.amount).fontWeight(.medium)) }),
        .init(title: "Period", width: 160, content: { AnyView(Text($0.period).foregroundStyle(.secondary)) })
    ]
}
