import Foundation

struct GetInvoicesUseCase {
    let repository: InvoiceRepository

    func execute() -> [Invoice] {
        repository.fetchInvoices()
    }
}
