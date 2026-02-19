import SwiftUI

struct DashboardViewModel {
    let metrics: [DashboardMetric]
    let recentActivity: [DashboardActivity]
    let reportingHighlights: [String]

    static let sample = DashboardViewModel(
        metrics: [
            DashboardMetric(title: "Outstanding Invoices", value: "$12,450", trend: "+8.2%", footnote: "17 open invoices", systemImage: "doc.text.magnifyingglass", tint: .blue),
            DashboardMetric(title: "This Month Expenses", value: "$6,230", trend: "-2.1%", footnote: "vs last month", systemImage: "creditcard.fill", tint: .orange),
            DashboardMetric(title: "Net Cash Position", value: "$28,910", trend: "+5.4%", footnote: "after payroll reserve", systemImage: "dollarsign.circle.fill", tint: .green),
            DashboardMetric(title: "Next Payroll Run", value: "Apr 30", trend: "+4 days", footnote: "Estimated $9,840", systemImage: "calendar", tint: .purple)
        ],
        recentActivity: [
            DashboardActivity(title: "Invoice INV-1024 marked paid", subtitle: "Acme Design • $2,300 • Today"),
            DashboardActivity(title: "Expense added: Cloud hosting", subtitle: "Infrastructure • $189 • Yesterday"),
            DashboardActivity(title: "Employee onboarded", subtitle: "Nina Patel • Product Designer • 2 days ago")
        ],
        reportingHighlights: [
            "P&L indicates 21% net margin month-to-date",
            "Operating expenses are within budget targets",
            "Accounts receivable aging: 2 invoices over 30 days"
        ]
    )
}

struct DashboardMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let trend: String
    let footnote: String
    let systemImage: String
    let tint: Color
}

struct DashboardActivity: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}
