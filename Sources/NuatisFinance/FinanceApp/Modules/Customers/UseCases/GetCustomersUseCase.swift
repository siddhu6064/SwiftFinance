import Foundation

struct GetCustomersUseCase {
    let repository: CustomerRepository

    func execute() -> [Customer] {
        repository.fetchCustomers()
    }
}
