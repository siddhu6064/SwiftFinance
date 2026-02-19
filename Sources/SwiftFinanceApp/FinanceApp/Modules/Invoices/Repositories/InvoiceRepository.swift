import Foundation

protocol InvoiceRepository {
    func fetchInvoices() -> [Invoice]
}

struct CoreDataInvoiceRepository: InvoiceRepository {
    func fetchInvoices() -> [Invoice] {
        // Phase 1: returns seeded values until full CRUD forms are wired.
        [
            Invoice(id: UUID(), number: "INV-2041", customerName: "Northstar Labs", issueDate: .now, dueDate: .now.addingTimeInterval(86400 * 15), totalAmount: 9200, status: "Sent"),
            Invoice(id: UUID(), number: "INV-2038", customerName: "Glacier Tech", issueDate: .now.addingTimeInterval(-86400 * 2), dueDate: .now.addingTimeInterval(86400 * 10), totalAmount: 4550, status: "Paid"),
            Invoice(id: UUID(), number: "INV-2036", customerName: "Helio Studio", issueDate: .now.addingTimeInterval(-86400 * 8), dueDate: .now.addingTimeInterval(-86400), totalAmount: 2140, status: "Overdue")
        ]
    }
}
