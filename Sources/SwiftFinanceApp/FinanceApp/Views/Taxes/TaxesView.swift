import SwiftUI

struct TaxesView: View {
    private let taxItems: [TaxRow] = [
        .init(type: "Federal Payroll Tax", dueDate: "May 15", amount: "$3,200", status: "Upcoming"),
        .init(type: "State Withholding", dueDate: "May 15", amount: "$1,280", status: "Upcoming"),
        .init(type: "Sales Tax", dueDate: "Apr 30", amount: "$940", status: "Filed")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Taxes")
                .font(.largeTitle.weight(.semibold))

            DashboardCard(title: "Tax Center", subtitle: "Filing calendar and liabilities") {
                DataTable(rows: taxItems, columns: TaxRow.columns)
            }
        }
    }
}

struct TaxRow: Identifiable {
    let id = UUID()
    let type: String
    let dueDate: String
    let amount: String
    let status: String

    static let columns: [TableColumnDefinition<TaxRow>] = [
        .init(title: "Tax Type", width: nil, content: { AnyView(Text($0.type)) }),
        .init(title: "Due Date", width: 140, content: { AnyView(Text($0.dueDate)) }),
        .init(title: "Amount", width: 120, content: { AnyView(Text($0.amount).fontWeight(.medium)) }),
        .init(title: "Status", width: 120, content: { AnyView(Text($0.status).foregroundStyle(.secondary)) })
    ]
}
