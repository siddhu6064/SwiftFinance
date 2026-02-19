import Foundation

#if canImport(CoreData)
import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init(inMemory: Bool = false) {

        let model = Self.makeModel()

        container = NSPersistentContainer(
            name: "SwiftFinanceModel",
            managedObjectModel: model
        )

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { description, error in

            if let error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }

            print("Core Data store location:",
                  description.url?.path ?? "unknown")
        }

        container.viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func saveIfNeeded() {

        let context = container.viewContext

        guard context.hasChanges else { return }

        do {
            try context.save()
        }
        catch {
            print("Core Data save error:", error)
        }
    }

    // MARK: - Model Definition

    private static func makeModel() -> NSManagedObjectModel {

        let model = NSManagedObjectModel()

        // InvoiceRecord
        let invoice = NSEntityDescription()
        invoice.name = "InvoiceRecord"
        invoice.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        invoice.properties = [
            attribute("id", type: .UUIDAttributeType),
            attribute("number"),
            attribute("customer"),
            attribute("amount", type: .doubleAttributeType),
            attribute("status"),
            attribute("date", type: .dateAttributeType)
        ]

        // ExpenseRecord
        let expense = NSEntityDescription()
        expense.name = "ExpenseRecord"
        expense.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        expense.properties = [
            attribute("id", type: .UUIDAttributeType),
            attribute("vendor"),
            attribute("category"),
            attribute("amount", type: .doubleAttributeType),
            attribute("date", type: .dateAttributeType)
        ]

        // CustomerRecord
        let customer = NSEntityDescription()
        customer.name = "CustomerRecord"
        customer.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        customer.properties = [
            attribute("id", type: .UUIDAttributeType),
            attribute("name"),
            attribute("email"),
            attribute("arBalance", type: .doubleAttributeType)
        ]

        // VendorRecord
        let vendor = NSEntityDescription()
        vendor.name = "VendorRecord"
        vendor.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        vendor.properties = [
            attribute("id", type: .UUIDAttributeType),
            attribute("name"),
            attribute("category"),
            attribute("apBalance", type: .doubleAttributeType)
        ]

        model.entities = [invoice, expense, customer, vendor]

        return model
    }

    private static func attribute(
        _ name: String,
        type: NSAttributeType = .stringAttributeType
    ) -> NSAttributeDescription {

        let attr = NSAttributeDescription()

        attr.name = name
        attr.attributeType = type
        attr.isOptional = false

        return attr
    }
}

#endif
