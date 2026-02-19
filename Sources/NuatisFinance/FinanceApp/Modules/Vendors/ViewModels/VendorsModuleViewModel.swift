import Foundation

@MainActor
final class VendorsModuleViewModel: ObservableObject {
    @Published private(set) var vendors: [Vendor] = []

    private let getVendors: GetVendorsUseCase

    init(getVendors: GetVendorsUseCase = .init(repository: CoreDataVendorRepository())) {
        self.getVendors = getVendors
    }

    func load() {
        vendors = getVendors.execute()
    }
}
