import Foundation

@MainActor
final class ExpensesModuleViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []
    @Published var isShowingAddExpense = false

    private let repository: ExpenseRepository

    init(repository: ExpenseRepository = CoreDataExpenseRepository()) {
        self.repository = repository
    }

    func load() {
        expenses = repository.fetchExpenses()
    }

    func addExpense(vendor: String, category: String, amount: Double, date: Date) {
        let expense = Expense(
            id: UUID(),
            vendorName: vendor,
            category: category,
            amount: Decimal(amount),
            incurredAt: date,
            reimbursable: false
        )
        repository.createExpense(expense)
        load()
    }
}
