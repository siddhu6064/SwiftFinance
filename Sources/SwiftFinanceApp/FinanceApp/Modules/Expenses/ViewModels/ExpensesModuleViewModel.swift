import Foundation

@MainActor
final class ExpensesModuleViewModel: ObservableObject {
    @Published private(set) var expenses: [Expense] = []

    private let getExpenses: GetExpensesUseCase

    init(getExpenses: GetExpensesUseCase = .init(repository: CoreDataExpenseRepository())) {
        self.getExpenses = getExpenses
    }

    func load() {
        expenses = getExpenses.execute()
    }
}
