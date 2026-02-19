import Foundation

protocol CustomerRepository {
    func fetchCustomers() -> [Customer]
}

struct CoreDataCustomerRepository: CustomerRepository {
    func fetchCustomers() -> [Customer] {
        [
            Customer(id: UUID(), name: "Northstar Labs", email: "ops@northstar.com", arBalance: 9200),
            Customer(id: UUID(), name: "Glacier Tech", email: "finance@glacier.com", arBalance: 0),
            Customer(id: UUID(), name: "Helio Studio", email: "billing@helio.com", arBalance: 2140)
        ]
    }
}
