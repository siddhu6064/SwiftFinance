import Foundation
@testable import NuatisFinanceApp

enum InvoiceTestFactory {
    static func make(
        id: UUID = UUID(),
        number: String = "INV-001",
        customerName: String = "Test Customer",
        issueDate: Date = Date(timeIntervalSince1970: 1_700_000_000),
        dueDate: Date = Date(timeIntervalSince1970: 1_700_086_400),
        totalAmount: Decimal = 100,
        status: String = "Draft"
    ) -> Invoice {
        Invoice(
            id: id,
            number: number,
            customerName: customerName,
            issueDate: issueDate,
            dueDate: dueDate,
            totalAmount: totalAmount,
            status: status
        )
    }
}
