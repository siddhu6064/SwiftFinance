import CoreData
import XCTest

/// In-memory Core Data stack for InvoiceRecord that matches CoreDataInvoiceRepository keys:
/// id, number, customerName, issueDate, dueDate, totalAmount, status
final class InMemoryInvoiceModelStack {

    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }

    init() {
        let model = Self.makeModel()

        container = NSPersistentContainer(
            name: "NuatisFinanceModel_Test",
            managedObjectModel: model
        )

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.url = URL(fileURLWithPath: "/dev/null")
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                XCTFail("Failed to load in-memory store: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Model

    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let invoice = NSEntityDescription()
        invoice.name = "InvoiceRecord"
        invoice.managedObjectClassName = NSStringFromClass(NSManagedObject.self)

        invoice.properties = [
            requiredAttribute("id", type: .UUIDAttributeType),
            requiredAttribute("number", type: .stringAttributeType),
            requiredAttribute("customerName", type: .stringAttributeType),
            requiredAttribute("issueDate", type: .dateAttributeType),
            requiredAttribute("dueDate", type: .dateAttributeType),
            requiredAttribute("totalAmount", type: .decimalAttributeType),
            requiredAttribute("status", type: .stringAttributeType)
        ]

        model.entities = [invoice]
        return model
    }

    private static func requiredAttribute(_ name: String, type: NSAttributeType) -> NSAttributeDescription {
        let a = NSAttributeDescription()
        a.name = name
        a.attributeType = type
        a.isOptional = false
        return a
    }
}
