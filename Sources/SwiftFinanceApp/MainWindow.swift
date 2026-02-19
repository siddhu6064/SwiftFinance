import SwiftUI

struct MainWindow: View {
    @State private var selection: AppSection = .dashboard
    @State private var searchText = ""
    @State private var company = "SwiftFinance LLC"

    var body: some View {
        HStack(spacing: 0) {
            SidebarView(selection: $selection)
                .frame(width: 240)
                .background(.thickMaterial)

            VStack(spacing: 0) {
                HeaderBar(
                    appTitle: selection.title,
                    companyName: company,
                    searchText: $searchText
                )

                ScrollView {
                    Group {
                        switch selection {
                        case .dashboard: DashboardView()
                        case .invoices: InvoicesView()
                        case .expenses: ExpensesView()
                        case .income: IncomeView()
                        case .customers: CustomersView()
                        case .vendors: VendorsView()
                        case .payroll: PayrollView()
                        case .employees: EmployeesView()
                        case .reports: ReportsView()
                        case .taxes: TaxesView()
                        case .settings: SettingsView()
                        }
                    }
                    .frame(maxWidth: 1320)
                    .padding(24)
                    .frame(maxWidth: .infinity)
                }
                .background(Color(nsColor: .windowBackgroundColor))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: selection)
    }
}

#Preview {
    MainWindow()
}
