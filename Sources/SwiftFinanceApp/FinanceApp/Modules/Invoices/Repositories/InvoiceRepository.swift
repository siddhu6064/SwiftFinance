import Foundation
import CoreData

protocol InvoiceRepository {
    func fetchInvoices() throws -> [InvoiceRow]
    func createInvoice(_ invoice: InvoiceRow) throws
    func updateInvoice(_ invoice: InvoiceRow) throws
    func deleteInvoice(id: UUID) throws
}

final class CoreDataInvoiceRepository: InvoiceRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext) {
        self.context = context
    }

    func fetchInvoices() throws -> [InvoiceRow] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "InvoiceRecord")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let results = try context.fetch(request)

        return results.map { obj in
            InvoiceRow(
                id: (obj.value(forKey: "id") as? UUID) ?? UUID(),
                number: obj.string("number"),
                customer: obj.string("customer"),
                amount: obj.double("amount"),
                status: obj.string("status"),
                date: obj.date("date")
            )
        }
    }

    func createInvoice(_ invoice: InvoiceRow) throws {
        let entity = NSEntityDescription.entity(forEntityName: "InvoiceRecord", in: context)!
        let obj = NSManagedObject(entity: entity, insertInto: context)

        obj.setValue(invoice.id, forKey: "id")
        obj.setValue(invoice.number, forKey: "number")
        obj.setValue(invoice.customer, forKey: "customer")
        obj.setValue(invoice.amount, forKey: "amount")
        obj.setValue(invoice.status, forKey: "status")
        obj.setValue(invoice.date, forKey: "date")

        try context.save()
    }

    func updateInvoice(_ invoice: InvoiceRow) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "InvoiceRecord")
        request.predicate = NSPredicate(format: "id == %@", invoice.id as CVarArg)
        request.fetchLimit = 1

        guard let obj = try context.fetch(request).first else { return }

        obj.setValue(invoice.number, forKey: "number")
        obj.setValue(invoice.customer, forKey: "customer")
        obj.setValue(invoice.amount, forKey: "amount")
        obj.setValue(invoice.status, forKey: "status")
        obj.setValue(invoice.date, forKey: "date")

        try context.save()
    }

    func deleteInvoice(id: UUID) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "InvoiceRecord")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        let results = try context.fetch(request)
        results.forEach { context.delete($0) }

        try context.save()
    }
}
