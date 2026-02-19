import XCTest
@testable import NuatisFinanceApp

final class InvoicesModuleViewModelTests: XCTestCase {

    func test_addInvoice_createsInvoice() async {

        let repo = FakeInvoiceRepository()

        let vm = await InvoicesModuleViewModel(repository: repo)

        await vm.addInvoice(
            number: "INV-001",
            customer: "Test Customer",
            amount: 100.0,
            status: "Draft",
            date: Date()
        )

        XCTAssertEqual(repo.created.count, 1)
        XCTAssertEqual(repo.created.first?.number, "INV-001")
    }
}

final class FakeInvoiceRepository: InvoiceRepository {

    var created: [Invoice] = []

    func fetchInvoices() -> [Invoice] {
        created
    }

    func createInvoice(_ invoice: Invoice) {
        created.append(invoice)
    }

    func updateInvoice(_ invoice: Invoice) {}

    func deleteInvoice(id: UUID) {}
}
