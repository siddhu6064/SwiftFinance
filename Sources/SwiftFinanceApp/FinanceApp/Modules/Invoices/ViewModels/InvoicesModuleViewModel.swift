import Foundation

@MainActor
final class InvoicesModuleViewModel: ObservableObject {
    @Published var invoices: [InvoiceRow] = []
    @Published var searchText: String = ""
    @Published var isShowingAddInvoice: Bool = false

    private let repo: InvoiceRepository

    init(repo: InvoiceRepository = CoreDataInvoiceRepository()) {
        self.repo = repo
    }

    func load() {
        do { invoices = try repo.fetchInvoices() }
        catch { print("Fetch invoices error:", error) }
    }

    func addInvoice(number: String, customer: String, amount: Double, status: String, date: Date) {
        let invoice = InvoiceRow(id: UUID(), number: number, customer: customer, amount: amount, status: status, date: date)
        do {
            try repo.createInvoice(invoice)
            load()
        } catch {
            print("Create invoice error:", error)
        }
    }

    func deleteInvoice(_ invoice: InvoiceRow) {
        do {
            try repo.deleteInvoice(id: invoice.id)
            load()
        } catch {
            print("Delete invoice error:", error)
        }
    }
}
