import Foundation
import CoreData

protocol ExpenseRepository {
    func fetchExpenses() throws -> [ExpenseRow]
    func createExpense(_ expense: ExpenseRow) throws
    func updateExpense(_ expense: ExpenseRow) throws
    func deleteExpense(id: UUID) throws
}

final class CoreDataExpenseRepository: ExpenseRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext) {
        self.context = context
    }

    func fetchExpenses() throws -> [ExpenseRow] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "ExpenseRecord")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let results = try context.fetch(request)

        return results.map { obj in
            ExpenseRow(
                id: (obj.value(forKey: "id") as? UUID) ?? UUID(),
                vendor: obj.string("vendor"),
                category: obj.string("category"),
                amount: obj.double("amount"),
                date: obj.date("date")
            )
        }
    }

    func createExpense(_ expense: ExpenseRow) throws {
        let entity = NSEntityDescription.entity(forEntityName: "ExpenseRecord", in: context)!
        let obj = NSManagedObject(entity: entity, insertInto: context)

        obj.setValue(expense.id, forKey: "id")
        obj.setValue(expense.vendor, forKey: "vendor")
        obj.setValue(expense.category, forKey: "category")
        obj.setValue(expense.amount, forKey: "amount")
        obj.setValue(expense.date, forKey: "date")

        try context.save()
    }

    func updateExpense(_ expense: ExpenseRow) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "ExpenseRecord")
        request.predicate = NSPredicate(format: "id == %@", expense.id as CVarArg)
        request.fetchLimit = 1

        guard let obj = try context.fetch(request).first else { return }

        obj.setValue(expense.vendor, forKey: "vendor")
        obj.setValue(expense.category, forKey: "category")
        obj.setValue(expense.amount, forKey: "amount")
        obj.setValue(expense.date, forKey: "date")

        try context.save()
    }

    func deleteExpense(id: UUID) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "ExpenseRecord")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        let results = try context.fetch(request)
        results.forEach { context.delete($0) }

        try context.save()
    }
}
