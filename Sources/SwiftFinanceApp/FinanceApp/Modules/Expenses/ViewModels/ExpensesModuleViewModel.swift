import Foundation

@MainActor
final class ExpensesModuleViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []
    @Published var isShowingAddExpense: Bool = false
    @Published var searchText: String = ""

    private let repository: ExpenseRepository

    init(repository: ExpenseRepository = CoreDataExpenseRepository()) {
        self.repository = repository
    }

    func load() {
        expenses = repository.fetchExpenses()
    }

    // Used by the Table sorting hook in ExpensesView
    func applySort(_ order: [KeyPathComparator<Expense>]) {
        expenses.sort(using: order)
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

    // Used by EditExpenseSheet
    func updateExpense(_ expense: Expense) {
        repository.updateExpense(expense)
        load()
    }

    // Used by context menu / Delete key
    func deleteExpense(_ expense: Expense) {
        repository.deleteExpense(id: expense.id)
        load()
    }
}
