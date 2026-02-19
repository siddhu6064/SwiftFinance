import Foundation

enum AppSection: String, CaseIterable, Hashable, Identifiable {
    case dashboard, invoices, expenses, income, customers, vendors, payroll, employees, reports, taxes, settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dashboard: "Dashboard"
        case .invoices: "Invoices"
        case .expenses: "Expenses"
        case .income: "Income"
        case .customers: "Customers"
        case .vendors: "Vendors"
        case .payroll: "Payroll"
        case .employees: "Employees"
        case .reports: "Reports"
        case .taxes: "Taxes"
        case .settings: "Settings"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: "square.grid.2x2"
        case .invoices: "doc.text"
        case .expenses: "creditcard"
        case .income: "arrow.down.left.arrow.up.right"
        case .customers: "person.2"
        case .vendors: "building.2"
        case .payroll: "banknote"
        case .employees: "person.text.rectangle"
        case .reports: "chart.bar"
        case .taxes: "percent"
        case .settings: "gearshape"
        }
    }
}
