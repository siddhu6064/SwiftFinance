import Foundation
import CoreData

protocol InvoiceRepository {
    func fetchInvoices() throws -> [Invoice]
    func createInvoice(_ invoice: Invoice) throws
    func updateInvoice(_ invoice: Invoice) throws
    func deleteInvoice(id: UUID) throws
}

struct CoreDataInvoiceRepository: InvoiceRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext) {
        self.context = context
    }

    func fetchInvoices() throws -> [Invoice] {
        let req = NSFetchRequest<NSManagedObject>(entityName: "InvoiceRecord")
        req.sortDescriptors = [NSSortDescriptor(key: "issueDate", ascending: false)]

        let results = try context.fetch(req)
        return results.map {
            Invoice(
                id: ($0.value(forKey: "id") as? UUID) ?? UUID(),
                number: ($0.value(forKey: "number") as? String) ?? "",
                customerName: ($0.value(forKey: "customerName") as? String) ?? "",
                issueDate: ($0.value(forKey: "issueDate") as? Date) ?? .now,
                dueDate: ($0.value(forKey: "dueDate") as? Date) ?? .now,
                totalAmount: ($0.value(forKey: "totalAmount") as? Decimal) ?? 0,
                status: ($0.value(forKey: "status") as? String) ?? "Draft"
            )
        }
    }

    func createInvoice(_ invoice: Invoice) throws {
        let entity = NSEntityDescription.entity(forEntityName: "InvoiceRecord", in: context)!
        let obj = NSManagedObject(entity: entity, insertInto: context)

        obj.setValue(invoice.id, forKey: "id")
        obj.setValue(invoice.number, forKey: "number")
        obj.setValue(invoice.customerName, forKey: "customerName")
        obj.setValue(invoice.issueDate, forKey: "issueDate")
        obj.setValue(invoice.dueDate, forKey: "dueDate")
        obj.setValue(invoice.totalAmount, forKey: "totalAmount")
        obj.setValue(invoice.status, forKey: "status")

        try saveIfNeeded()
    }

    func updateInvoice(_ invoice: Invoice) throws {
        let req = NSFetchRequest<NSManagedObject>(entityName: "InvoiceRecord")
        req.predicate = NSPredicate(format: "id == %@", invoice.id as CVarArg)
        req.fetchLimit = 1

        guard let obj = try context.fetch(req).first else { return }

        obj.setValue(invoice.number, forKey: "number")
        obj.setValue(invoice.customerName, forKey: "customerName")
        obj.setValue(invoice.issueDate, forKey: "issueDate")
        obj.setValue(invoice.dueDate, forKey: "dueDate")
        obj.setValue(invoice.totalAmount, forKey: "totalAmount")
        obj.setValue(invoice.status, forKey: "status")

        try saveIfNeeded()
    }

    func deleteInvoice(id: UUID) throws {
        let req = NSFetchRequest<NSManagedObject>(entityName: "InvoiceRecord")
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        let results = try context.fetch(req)
        results.forEach { context.delete($0) }

        try saveIfNeeded()
    }

    // MARK: - Local save using injected context (critical for tests)

    private func saveIfNeeded() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
