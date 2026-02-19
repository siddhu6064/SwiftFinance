import Foundation

@MainActor
final class InvoicesModuleViewModel: ObservableObject {
    @Published private(set) var invoices: [Invoice] = []
    @Published var isShowingAddInvoice = false

    private let repository: InvoiceRepository

    init(repository: InvoiceRepository = CoreDataInvoiceRepository()) {
        self.repository = repository
    }

    func load() {
        invoices = repository.fetchInvoices()
    }

    func addInvoice(number: String, customer: String, amount: Double, status: String, date: Date) {
        let invoice = Invoice(
            id: UUID(),
            number: number,
            customerName: customer,
            issueDate: date,
            dueDate: date,            // or compute due date
            totalAmount: Decimal(amount),
            status: status
        )
        repository.createInvoice(invoice)
        load()
    }
}
