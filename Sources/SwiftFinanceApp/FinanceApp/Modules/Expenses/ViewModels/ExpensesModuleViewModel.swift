import Foundation

@MainActor
final class ExpensesModuleViewModel: ObservableObject {
    @Published var expenses: [ExpenseRow] = []
    @Published var searchText: String = ""
    @Published var isShowingAddExpense: Bool = false

    private let repo: ExpenseRepository

    init(repo: ExpenseRepository = CoreDataExpenseRepository()) {
        self.repo = repo
    }

    func load() {
        do { expenses = try repo.fetchExpenses() }
        catch { print("Fetch expenses error:", error) }
    }

    func addExpense(vendor: String, category: String, amount: Double, date: Date) {
        let expense = ExpenseRow(id: UUID(), vendor: vendor, category: category, amount: amount, date: date)
        do {
            try repo.createExpense(expense)
            load()
        } catch {
            print("Create expense error:", error)
        }
    }

    func deleteExpense(_ expense: ExpenseRow) {
        do {
            try repo.deleteExpense(id: expense.id)
            load()
        } catch {
            print("Delete expense error:", error)
        }
    }
}
