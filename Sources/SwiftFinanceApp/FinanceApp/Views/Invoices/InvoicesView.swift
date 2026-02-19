import SwiftUI

struct InvoicesView: View {
    @StateObject private var viewModel = InvoicesModuleViewModel()
    @State private var statusFilter = "All"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Invoices")
                    .font(.largeTitle.weight(.semibold))
                Spacer()
                Picker("Status", selection: $statusFilter) {
                    Text("All").tag("All")
                    Text("Draft").tag("Draft")
                    Text("Sent").tag("Sent")
                    Text("Paid").tag("Paid")
                    Text("Overdue").tag("Overdue")
                }
                .pickerStyle(.segmented)
                .frame(width: 340)
            }

            DashboardCard(title: "Invoice Ledger", subtitle: "Open and settled invoices") {
                DataTable(rows: filteredRows, columns: InvoiceRow.columns)
            }
        }
        .task { viewModel.load() }
    }

    private var filteredRows: [InvoiceRow] {
        let rows = viewModel.invoices.map(InvoiceRow.init)
        return statusFilter == "All" ? rows : rows.filter { $0.status == statusFilter }
    }
}

struct InvoiceRow: Identifiable {
    let id: UUID
    let number: String
    let customer: String
    let amount: String
    let status: String
    let date: String

    init(invoice: Invoice) {
        id = invoice.id
        number = invoice.number
        customer = invoice.customerName
        amount = invoice.totalAmount.currency
        status = invoice.status
        date = invoice.issueDate.shortDate
    }

    static let columns: [TableColumnDefinition<InvoiceRow>] = [
        .init(title: "Invoice #", width: 130, content: { AnyView(Text($0.number).fontWeight(.medium)) }),
        .init(title: "Customer", width: nil, content: { AnyView(Text($0.customer)) }),
        .init(title: "Amount", width: 120, content: { AnyView(Text($0.amount)) }),
        .init(title: "Status", width: 120, content: { AnyView(Text($0.status)) }),
        .init(title: "Date", width: 120, content: { AnyView(Text($0.date).foregroundStyle(.secondary)) }),
        .init(title: "Actions", width: 120, content: { _ in AnyView(Button("View") {}) })
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
