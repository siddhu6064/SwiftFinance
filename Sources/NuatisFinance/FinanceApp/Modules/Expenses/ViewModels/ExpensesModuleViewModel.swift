import Foundation

@MainActor
final class ExpensesModuleViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var searchText: String = ""
    @Published var isShowingAddExpense: Bool = false

    private let repo: ExpenseRepository

    init(repo: ExpenseRepository = CoreDataExpenseRepository()) {
        self.repo = repo
    }

    func load() {
        do {
            expenses = try repo.fetchExpenses()
        } catch {
            print("Fetch expenses error:", error)
        }
    }

    func applySort(_ order: [KeyPathComparator<Expense>]) {
        expenses.sort(using: order)
    }

    func addExpense(
        vendorName: String,
        category: String,
        amount: Double,
        incurredAt: Date,
        reimbursable: Bool = false
    ) {
        let expense = Expense(
            id: UUID(),
            vendorName: vendorName,
            category: category,
            amount: Decimal(amount),
            incurredAt: incurredAt,
            reimbursable: reimbursable
        )

        do {
            try repo.createExpense(expense)
            load()
        } catch {
            print("Create expense error:", error)
        }
    }

    func updateExpense(_ expense: Expense) {
        do {
            try repo.updateExpense(expense)
            load()
        } catch {
            print("Update expense error:", error)
        }
    }

    func deleteExpense(_ expense: Expense) {
        do {
            try repo.deleteExpense(id: expense.id)
            load()
        } catch {
            print("Delete expense error:", error)
        }
    }
}
