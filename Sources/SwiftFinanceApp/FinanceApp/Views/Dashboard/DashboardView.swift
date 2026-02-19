import Charts
import SwiftUI

struct DashboardView: View {
    private let metrics = [
        ("Total Balance", "$428,340", Color.primary),
        ("Income (MTD)", "$84,220", Color.green),
        ("Expenses (MTD)", "$49,870", Color.orange),
        ("Profit / Loss", "+$34,350", Color.blue)
    ]

    private let monthlyCashFlow: [CashPoint] = [
        .init(month: "Jan", income: 70, expense: 51), .init(month: "Feb", income: 75, expense: 53),
        .init(month: "Mar", income: 78, expense: 57), .init(month: "Apr", income: 84, expense: 50)
    ]

    private let expenseBreakdown: [CategoryPoint] = [
        .init(category: "Payroll", amount: 42), .init(category: "Software", amount: 15),
        .init(category: "Operations", amount: 23), .init(category: "Marketing", amount: 20)
    ]

    private let transactions: [TransactionRow] = [
        .init(type: "Invoice Payment", party: "Acme Inc.", amount: "$12,400", date: "Apr 14", status: "Cleared"),
        .init(type: "Payroll Run", party: "Team Payroll", amount: "-$18,900", date: "Apr 13", status: "Processed"),
        .init(type: "Vendor Bill", party: "CloudOps", amount: "-$2,140", date: "Apr 12", status: "Approved")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Financial Overview")
                .font(.largeTitle.weight(.semibold))

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 250), spacing: 12)], spacing: 12) {
                ForEach(metrics, id: \.0) { metric in
                    DashboardCard(title: metric.0) {
                        Text(metric.1)
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(metric.2)
                    }
                }
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ChartCard(title: "Cash Flow") {
                    Chart(monthlyCashFlow) {
                        LineMark(x: .value("Month", $0.month), y: .value("Income", $0.income))
                            .foregroundStyle(.green)
                        LineMark(x: .value("Month", $0.month), y: .value("Expenses", $0.expense))
                            .foregroundStyle(.orange)
                    }
                }

                ChartCard(title: "Expense Breakdown") {
                    Chart(expenseBreakdown) {
                        BarMark(x: .value("Category", $0.category), y: .value("Amount", $0.amount))
                            .foregroundStyle(.blue.gradient)
                    }
                }
            }

            DashboardCard(title: "Recent Transactions") {
                DataTable(rows: transactions, columns: TransactionRow.columns)
            }
        }
    }
}

struct CashPoint: Identifiable {
    let id = UUID()
    let month: String
    let income: Double
    let expense: Double
}

struct CategoryPoint: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
}

struct TransactionRow: Identifiable {
    let id = UUID()
    let type: String
    let party: String
    let amount: String
    let date: String
    let status: String

    static let columns: [TableColumnDefinition<TransactionRow>] = [
        .init(title: "Type", width: nil, content: { AnyView(Text($0.type)) }),
        .init(title: "Party", width: nil, content: { AnyView(Text($0.party).foregroundStyle(.secondary)) }),
        .init(title: "Amount", width: 140, content: { AnyView(Text($0.amount).fontWeight(.medium)) }),
        .init(title: "Date", width: 120, content: { AnyView(Text($0.date).foregroundStyle(.secondary)) }),
        .init(title: "Status", width: 120, content: { AnyView(Text($0.status)) })
    ]
}
