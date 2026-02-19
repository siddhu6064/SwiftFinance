import SwiftUI

struct VendorsView: View {
    @StateObject private var viewModel = VendorsModuleViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vendors")
                .font(.largeTitle.weight(.semibold))

            DashboardCard(title: "Vendor Ledger", subtitle: "Accounts payable tracking") {
                DataTable(rows: rows, columns: VendorRow.columns)
            }
        }
        .task { viewModel.load() }
    }

    private var rows: [VendorRow] {
        viewModel.vendors.map(VendorRow.init)
    }
}

struct VendorRow: Identifiable {
    let id: UUID
    let name: String
    let category: String
    let apBalance: String

    init(vendor: Vendor) {
        id = vendor.id
        name = vendor.name
        category = vendor.category
        apBalance = vendor.apBalance.currency
    }

    static let columns: [TableColumnDefinition<VendorRow>] = [
        .init(title: "Vendor", width: nil, content: { AnyView(Text($0.name)) }),
        .init(title: "Category", width: 180, content: { AnyView(Text($0.category).foregroundStyle(.secondary)) }),
        .init(title: "A/P Balance", width: 140, content: { AnyView(Text($0.apBalance).fontWeight(.medium)) })
    ]
}

private extension Decimal {
    var currency: String { "$\(NSDecimalNumber(decimal: self))" }
}
