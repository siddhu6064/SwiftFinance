import Foundation

struct PayrollViewModel {
    let nextRunDate: String
    let estimatedPayout: String
    let pendingApprovals: String
    let runs: [PayrollRunRow]

    static let sample = PayrollViewModel(
        nextRunDate: "Apr 30",
        estimatedPayout: "$9,840",
        pendingApprovals: "2",
        runs: [
            PayrollRunRow(period: "Apr 1 - Apr 15", employees: "14 employees", total: "$9,120", status: "Processed"),
            PayrollRunRow(period: "Mar 16 - Mar 31", employees: "13 employees", total: "$8,780", status: "Processed"),
            PayrollRunRow(period: "Mar 1 - Mar 15", employees: "13 employees", total: "$8,640", status: "Pending")
        ]
    )
}

struct PayrollRunRow: Identifiable {
    let id = UUID()
    let period: String
    let employees: String
    let total: String
    let status: String
}
