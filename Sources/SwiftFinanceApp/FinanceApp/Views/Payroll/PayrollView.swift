import SwiftUI

struct PayrollView: View {
    private let employees: [PayrollEmployeeRow] = [
        .init(name: "Nina Patel", salary: "$8,400", cycle: "Monthly", nextPayDate: "Apr 30"),
        .init(name: "Ryan Brooks", salary: "$9,100", cycle: "Monthly", nextPayDate: "Apr 30"),
        .init(name: "Leah Kim", salary: "$7,900", cycle: "Monthly", nextPayDate: "Apr 30")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Payroll")
                    .font(.largeTitle.weight(.semibold))
                Spacer()
                Button("Run Payroll") {}
                    .buttonStyle(.borderedProminent)
            }

            DashboardCard(title: "Employee Payroll", subtitle: "Upcoming pay run") {
                DataTable(rows: employees, columns: PayrollEmployeeRow.columns)
            }
        }
    }
}

struct PayrollEmployeeRow: Identifiable {
    let id = UUID()
    let name: String
    let salary: String
    let cycle: String
    let nextPayDate: String

    static let columns: [TableColumnDefinition<PayrollEmployeeRow>] = [
        .init(title: "Employee", width: nil, content: { AnyView(Text($0.name)) }),
        .init(title: "Salary", width: 140, content: { AnyView(Text($0.salary).fontWeight(.medium)) }),
        .init(title: "Cycle", width: 140, content: { AnyView(Text($0.cycle)) }),
        .init(title: "Next Pay Date", width: 140, content: { AnyView(Text($0.nextPayDate)) })
    ]
}
