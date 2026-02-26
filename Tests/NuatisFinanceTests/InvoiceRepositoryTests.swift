import XCTest
import CoreData
@testable import NuatisFinanceApp

final class InvoiceRepositoryTests: XCTestCase {

    private var stack: CoreDataStack!
    private var repo: CoreDataInvoiceRepository!

    override func setUp() {
        super.setUp()
        stack = CoreDataStack(inMemory: true)
        repo = CoreDataInvoiceRepository(context: stack.context)
    }

    override func tearDown() {
        repo = nil
        stack = nil
        super.tearDown()
    }

    func test_createInvoice_persistsAndFetchReturnsIt() throws {
        let inv = Invoice(
            id: UUID(),
            number: "INV-100",
            customerName: "Acme LLC",
            issueDate: Date(timeIntervalSince1970: 100),
            dueDate: Date(timeIntervalSince1970: 200),
            totalAmount: 250,
            status: "Draft"
        )

        try repo.createInvoice(inv)

        let all = try repo.fetchInvoices()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all[0].id, inv.id)
        XCTAssertEqual(all[0].number, "INV-100")
        XCTAssertEqual(all[0].customerName, "Acme LLC")
        XCTAssertEqual(all[0].status, "Draft")
    }

    func test_fetchInvoices_sortedByIssueDate_descending() throws {
          let a = Invoice(
            id: UUID(), number: "A", customerName: "C1",
            issueDate: Date(timeIntervalSince1970: 100),
            dueDate: nil, totalAmount: 10, status: "Draft"
        )
        let b = Invoice(
            id: UUID(), number: "B", customerName: "C2",
            issueDate: Date(timeIntervalSince1970: 300),
            dueDate: nil, totalAmount: 20, status: "Draft"
        )
        let c = Invoice(
            id: UUID(), number: "C", customerName: "C3",
            issueDate: Date(timeIntervalSince1970: 200),
            dueDate: nil, totalAmount: 30, status: "Draft"
        )

        try repo.createInvoice(a)
        try repo.createInvoice(b)
        try repo.createInvoice(c)

        let results = try repo.fetchInvoices()
        let numbers = results.map { $0.number }

        // Repository sorts by key "issueDate" descending :contentReference[oaicite:4]{index=4}
        XCTAssertEqual(numbers, ["B", "C", "A"])
    }

    func test_updateInvoice_updatesExistingRecord() throws {
        let original = Invoice(
            id: UUID(),
            number: "INV-1",
            customerName: "Old Name",
            issueDate: Date(timeIntervalSince1970: 100),
            dueDate: nil,
            totalAmount: 10,
            status: "Draft"
        )
        try repo.createInvoice(original)

        let updated = Invoice(
            id: original.id,
            number: "INV-1-UPDATED",
            customerName: "New Name",
            issueDate: original.issueDate,
            dueDate: original.dueDate,
            totalAmount: 999,
            status: "Sent"
        )

        try repo.updateInvoice(updated)

        let results = try repo.fetchInvoices()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].id, original.id)
        XCTAssertEqual(results[0].number, "INV-1-UPDATED")
        XCTAssertEqual(results[0].customerName, "New Name")
        XCTAssertEqual(results[0].status, "Sent")
    }

     func test_deleteInvoice_removesRecord() throws {
        let inv = Invoice(
            id: UUID(),
            number: "INV-DEL",
            customerName: "Test",
            issueDate: Date(timeIntervalSince1970: 100),
            dueDate: nil,
            totalAmount: 1,
            status: "Draft"
        )

        try repo.createInvoice(inv)
        try repo.deleteInvoice(id: inv.id)

        let results = try repo.fetchInvoices()
        XCTAssertEqual(results.count, 0)
    }
}