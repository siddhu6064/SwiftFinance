import Foundation

struct GetExpensesUseCase {
    let repository: ExpenseRepository

    func execute() -> [Expense] {
        repository.fetchExpenses()
    }
}
