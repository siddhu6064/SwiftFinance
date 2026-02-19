import Foundation

protocol ExpenseRepository {
    func fetchExpenses() -> [Expense]
}

struct CoreDataExpenseRepository: ExpenseRepository {
    func fetchExpenses() -> [Expense] {
        [
            Expense(id: UUID(), vendorName: "CloudOps", category: "Infrastructure", amount: 2140, incurredAt: .now, reimbursable: false),
            Expense(id: UUID(), vendorName: "Office Hub", category: "Operations", amount: 720, incurredAt: .now.addingTimeInterval(-86400), reimbursable: false),
            Expense(id: UUID(), vendorName: "Adflow", category: "Marketing", amount: 1200, incurredAt: .now.addingTimeInterval(-86400 * 2), reimbursable: false)
        ]
    }
}
