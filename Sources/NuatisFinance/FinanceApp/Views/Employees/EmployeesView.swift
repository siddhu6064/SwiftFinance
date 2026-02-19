import SwiftUI

struct EmployeesView: View {
    private let employees: [EmployeeRow] = [
        .init(name: "Nina Patel", role: "Product Designer", department: "Product"),
        .init(name: "Ryan Brooks", role: "iOS Engineer", department: "Engineering"),
        .init(name: "Leah Kim", role: "Operations", department: "Finance")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Employees")
                .font(.largeTitle.weight(.semibold))

            DashboardCard(title: "Employee Directory", subtitle: "Headcount and org data") {
                DataTable(rows: employees, columns: EmployeeRow.columns)
            }
        }
    }
}

struct EmployeeRow: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let department: String

    static let columns: [TableColumnDefinition<EmployeeRow>] = [
        .init(title: "Name", width: nil, content: { AnyView(Text($0.name)) }),
        .init(title: "Role", width: nil, content: { AnyView(Text($0.role).foregroundStyle(.secondary)) }),
        .init(title: "Department", width: 180, content: { AnyView(Text($0.department)) })
    ]
}
