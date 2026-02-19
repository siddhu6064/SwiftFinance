import Foundation

@MainActor
final class CustomersModuleViewModel: ObservableObject {
    @Published private(set) var customers: [Customer] = []

    private let getCustomers: GetCustomersUseCase

    init(getCustomers: GetCustomersUseCase = .init(repository: CoreDataCustomerRepository())) {
        self.getCustomers = getCustomers
    }

    func load() {
        customers = getCustomers.execute()
    }
}
