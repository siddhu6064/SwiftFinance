import Foundation

@MainActor
final class InvoicesModuleViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    @Published var searchText: String = ""
    @Published var isShowingAddInvoice: Bool = false

    private let repo: InvoiceRepository

    init(repo: InvoiceRepository = CoreDataInvoiceRepository()) {
        self.repo = repo
    }

    func load() {
        do {
            invoices = try repo.fetchInvoices()
        } catch {
            print("Fetch invoices error:", error)
        }
    }

    func applySort(_ order: [KeyPathComparator<Invoice>]) {
        invoices.sort(using: order)
    }

    func addInvoice(
        number: String,
        customerName: String,
        amount: Double,
        status: String,
        issueDate: Date,
        dueDate: Date? = nil
    ) {
        let invoice = Invoice(
            id: UUID(),
            number: number,
            customerName: customerName,
            issueDate: issueDate,
            dueDate: dueDate ?? issueDate,
            totalAmount: Decimal(amount),
            status: status
        )

        do {
            try repo.createInvoice(invoice)
            load()
        } catch {
            print("Create invoice error:", error)
        }
    }

    func updateInvoice(_ invoice: Invoice) {
        do {
            try repo.updateInvoice(invoice)
            load()
        } catch {
            print("Update invoice error:", error)
        }
    }

    func deleteInvoice(_ invoice: Invoice) {
        do {
            try repo.deleteInvoice(id: invoice.id)
            load()
        } catch {
            print("Delete invoice error:", error)
        }
    }
}
