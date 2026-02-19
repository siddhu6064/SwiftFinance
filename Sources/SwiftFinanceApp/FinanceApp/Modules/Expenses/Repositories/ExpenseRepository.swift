import Foundation
import CoreData

protocol ExpenseRepository {
    func fetchExpenses() -> [Expense]
    func createExpense(_ expense: Expense)
    func updateExpense(_ expense: Expense)
    func deleteExpense(id: UUID)
}

struct CoreDataExpenseRepository: ExpenseRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext) {
        self.context = context
    }

    func fetchExpenses() -> [Expense] {
        let req = NSFetchRequest<NSManagedObject>(entityName: "ExpenseRecord")
        req.sortDescriptors = [NSSortDescriptor(key: "incurredAt", ascending: false)]

        let results = (try? context.fetch(req)) ?? []
        return results.map {
            Expense(
                id: ($0.value(forKey: "id") as? UUID) ?? UUID(),
                vendorName: ($0.value(forKey: "vendorName") as? String) ?? "",
                category: ($0.value(forKey: "category") as? String) ?? "",
                amount: ($0.value(forKey: "amount") as? Decimal) ?? 0,
                incurredAt: ($0.value(forKey: "incurredAt") as? Date) ?? .now,
                reimbursable: ($0.value(forKey: "reimbursable") as? Bool) ?? false
            )
        }
    }

    func createExpense(_ expense: Expense) {
        let entity = NSEntityDescription.entity(forEntityName: "ExpenseRecord", in: context)!
        let obj = NSManagedObject(entity: entity, insertInto: context)

        obj.setValue(expense.id, forKey: "id")
        obj.setValue(expense.vendorName, forKey: "vendorName")
        obj.setValue(expense.category, forKey: "category")
        obj.setValue(expense.amount, forKey: "amount")
        obj.setValue(expense.incurredAt, forKey: "incurredAt")
        obj.setValue(expense.reimbursable, forKey: "reimbursable")

        CoreDataStack.shared.saveIfNeeded()
    }

    func updateExpense(_ expense: Expense) {
        let req = NSFetchRequest<NSManagedObject>(entityName: "ExpenseRecord")
        req.predicate = NSPredicate(format: "id == %@", expense.id as CVarArg)
        req.fetchLimit = 1

        guard let obj = (try? context.fetch(req))?.first else { return }

        obj.setValue(expense.vendorName, forKey: "vendorName")
        obj.setValue(expense.category, forKey: "category")
        obj.setValue(expense.amount, forKey: "amount")
        obj.setValue(expense.incurredAt, forKey: "incurredAt")
        obj.setValue(expense.reimbursable, forKey: "reimbursable")

        CoreDataStack.shared.saveIfNeeded()
    }

    func deleteExpense(id: UUID) {
        let req = NSFetchRequest<NSManagedObject>(entityName: "ExpenseRecord")
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        let results = (try? context.fetch(req)) ?? []
        results.forEach { context.delete($0) }

        CoreDataStack.shared.saveIfNeeded()
    }
}
