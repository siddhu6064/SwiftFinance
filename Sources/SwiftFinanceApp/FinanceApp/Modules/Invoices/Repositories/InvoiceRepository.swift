import Foundation
import CoreData

protocol InvoiceRepository {
    func fetchInvoices() -> [Invoice]
    func createInvoice(_ invoice: Invoice)
}

struct CoreDataInvoiceRepository: InvoiceRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext) {
        self.context = context
    }

    func fetchInvoices() -> [Invoice] {
        let req = NSFetchRequest<NSManagedObject>(entityName: "InvoiceRecord")
        req.sortDescriptors = [NSSortDescriptor(key: "issueDate", ascending: false)]

        let results = (try? context.fetch(req)) ?? []
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

    func createInvoice(_ invoice: Invoice) {
        let entity = NSEntityDescription.entity(forEntityName: "InvoiceRecord", in: context)!
        let obj = NSManagedObject(entity: entity, insertInto: context)

        obj.setValue(invoice.id, forKey: "id")
        obj.setValue(invoice.number, forKey: "number")
        obj.setValue(invoice.customerName, forKey: "customerName")
        obj.setValue(invoice.issueDate, forKey: "issueDate")
        obj.setValue(invoice.dueDate, forKey: "dueDate")
        obj.setValue(invoice.totalAmount, forKey: "totalAmount")
        obj.setValue(invoice.status, forKey: "status")

        CoreDataStack.shared.saveIfNeeded()
    }
}
