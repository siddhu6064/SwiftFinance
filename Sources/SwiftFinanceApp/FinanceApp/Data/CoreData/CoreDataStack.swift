import Foundation

#if canImport(CoreData)
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        let model = Self.makeModel()
        container = NSPersistentContainer(name: "SwiftFinanceModel", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Core Data failed to load: \(error.localizedDescription)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveIfNeeded() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        try? context.save()
    }

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let invoice = NSEntityDescription()
        invoice.name = "InvoiceRecord"
        invoice.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        invoice.properties = [
            attribute("id", type: .UUIDAttributeType),
            attribute("number"),
            attribute("customerName"),
            attribute("issueDate", type: .dateAttributeType),
            attribute("dueDate", type: .dateAttributeType),
            attribute("totalAmount"),
            attribute("status")
        ]

        let expense = NSEntityDescription()
        expense.name = "ExpenseRecord"
        expense.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        expense.properties = [
            attribute("id", type: .UUIDAttributeType),
            attribute("vendorName"),
            attribute("category"),
            attribute("amount"),
            attribute("incurredAt", type: .dateAttributeType),
            attribute("reimbursable", type: .booleanAttributeType)
        ]

        let customer = NSEntityDescription()
        customer.name = "CustomerRecord"
        customer.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        customer.properties = [
            attribute("id", type: .UUIDAttributeType),
            attribute("name"),
            attribute("email"),
            attribute("arBalance")
        ]

        let vendor = NSEntityDescription()
        vendor.name = "VendorRecord"
        vendor.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        vendor.properties = [
            attribute("id", type: .UUIDAttributeType),
            attribute("name"),
            attribute("category"),
            attribute("apBalance")
        ]

        model.entities = [invoice, expense, customer, vendor]
        return model
    }

    private static func attribute(_ name: String, type: NSAttributeType = .stringAttributeType) -> NSAttributeDescription {
        let attr = NSAttributeDescription()
        attr.name = name
        attr.attributeType = type
        attr.isOptional = false
        return attr
    }
}

#else

final class CoreDataStack {
    static let shared = CoreDataStack()
    private init() {}
    func saveIfNeeded() {}
}

#endif
