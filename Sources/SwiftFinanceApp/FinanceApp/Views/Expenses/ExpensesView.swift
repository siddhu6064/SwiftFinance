import SwiftUI

struct ExpensesView: View {
    @StateObject private var viewModel = ExpensesModuleViewModel()
    @State private var selectedCategory = "All"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Expenses")
                    .font(.largeTitle.weight(.semibold))
                Spacer()
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag("All")
                    ForEach(categories, id: \.self) { Text($0).tag($0) }
                }
                .frame(width: 220)

                Button("Add Expense") {}
                    .buttonStyle(.borderedProminent)
            }

            DashboardCard(title: "Expense Register", subtitle: "Grouped by category") {
                DataTable(rows: filteredRows, columns: ExpenseRow.columns)
            }
        }
        .task { viewModel.load() }
    }

    private var categories: [String] {
        Array(Set(viewModel.expenses.map(\.category))).sorted()
    }

    private var filteredRows: [ExpenseRow] {
        let rows = viewModel.expenses.map(ExpenseRow.init)
        return selectedCategory == "All" ? rows : rows.filter { $0.category == selectedCategory }
    }
}

struct ExpenseRow: Identifiable {
    let id: UUID
    let vendor: String
    let category: String
    let amount: String
    let date: String

    init(expense: Expense) {
        id = expense.id
        vendor = expense.vendorName
        category = expense.category
        amount = expense.amount.currency
        date = expense.incurredAt.shortDate
    }

    static let columns: [TableColumnDefinition<ExpenseRow>] = [
        .init(title: "Vendor", width: nil, content: { AnyView(Text($0.vendor)) }),
        .init(title: "Category", width: 160, content: { AnyView(Text($0.category).foregroundStyle(.secondary)) }),
        .init(title: "Amount", width: 120, content: { AnyView(Text($0.amount).fontWeight(.medium)) }),
        .init(title: "Date", width: 120, content: { AnyView(Text($0.date)) })
    ]
}

private extension Decimal {
    var currency: String { "$\(NSDecimalNumber(decimal: self))" }
}

private extension Date {
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
}
