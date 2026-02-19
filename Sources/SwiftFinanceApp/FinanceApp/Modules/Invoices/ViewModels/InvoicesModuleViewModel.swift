import Foundation

@MainActor
final class InvoicesModuleViewModel: ObservableObject {
    @Published private(set) var invoices: [Invoice] = []

    private let getInvoices: GetInvoicesUseCase

    init(getInvoices: GetInvoicesUseCase = .init(repository: CoreDataInvoiceRepository())) {
        self.getInvoices = getInvoices
    }

    func load() {
        invoices = getInvoices.execute()
    }
}
