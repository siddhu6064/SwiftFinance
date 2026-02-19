import Foundation

protocol VendorRepository {
    func fetchVendors() -> [Vendor]
}

struct CoreDataVendorRepository: VendorRepository {
    func fetchVendors() -> [Vendor] {
        [
            Vendor(id: UUID(), name: "CloudOps", category: "Infrastructure", apBalance: 2140),
            Vendor(id: UUID(), name: "Office Hub", category: "Office", apBalance: 720),
            Vendor(id: UUID(), name: "Adflow", category: "Marketing", apBalance: 1200)
        ]
    }
}
