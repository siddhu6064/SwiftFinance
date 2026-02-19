import SwiftUI

struct CustomersView: View {
    @StateObject private var viewModel = CustomersModuleViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Customers")
                .font(.largeTitle.weight(.semibold))

            DashboardCard(title: "Customer Directory", subtitle: "Accounts receivable overview") {
                DataTable(rows: rows, columns: CustomerRow.columns)
            }
        }
        .task { viewModel.load() }
    }

    private var rows: [CustomerRow] {
        viewModel.customers.map(CustomerRow.init)
    }
}

struct CustomerRow: Identifiable {
    let id: UUID
    let name: String
    let contact: String
    let arBalance: String

    init(customer: Customer) {
        id = customer.id
        name = customer.name
        contact = customer.email
        arBalance = customer.arBalance.currency
    }

    static let columns: [TableColumnDefinition<CustomerRow>] = [
        .init(title: "Name", width: nil, content: { AnyView(Text($0.name)) }),
        .init(title: "Contact", width: nil, content: { AnyView(Text($0.contact).foregroundStyle(.secondary)) }),
        .init(title: "A/R Balance", width: 140, content: { AnyView(Text($0.arBalance).fontWeight(.medium)) })
    ]
}

private extension Decimal {
    var currency: String { "$\(NSDecimalNumber(decimal: self))" }
}
