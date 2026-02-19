import Foundation

struct GetVendorsUseCase {
    let repository: VendorRepository

    func execute() -> [Vendor] {
        repository.fetchVendors()
    }
}
