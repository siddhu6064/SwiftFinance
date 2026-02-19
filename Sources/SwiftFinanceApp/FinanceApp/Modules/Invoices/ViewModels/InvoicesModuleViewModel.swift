import Foundation

@MainActor
final class InvoicesModuleViewModel: ObservableObject {
    @Published private(set) var invoices: [Invoice] = []
    @Published var isShowingAddInvoice = false
    @Published var searchText: String = ""

    private let repository: InvoiceRepository

    init(repository: InvoiceRepository = CoreDataInvoiceRepository()) {
        self.repository = repository
    }

    func load() {
        invoices = repository.fetchInvoices()
    }

    // Used by the Table sorting hook in InvoicesView
    func applySort(_ order: [KeyPathComparator<Invoice>]) {
        invoices.sort(using: order)
    }

    func addInvoice(number: String, customer: String, amount: Double, status: String, date: Date) {
        let invoice = Invoice(
            id: UUID(),
            number: number,
            customerName: customer,
            issueDate: date,
            dueDate: date, // you can compute a real due date later
            totalAmount: Decimal(amount),
            status: status
        )
        repository.createInvoice(invoice)
        load()
    }

    // Used by EditInvoiceSheet
    func updateInvoice(_ invoice: Invoice) {
        repository.updateInvoice(invoice)
        load()
    }

    // Used by context menu / Delete key
    func deleteInvoice(_ invoice: Invoice) {
        repository.deleteInvoice(id: invoice.id)
        load()
    }
}
