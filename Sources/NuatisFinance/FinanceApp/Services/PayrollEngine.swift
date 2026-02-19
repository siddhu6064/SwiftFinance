import Foundation

struct PayrollEngine {
    func calculateNetPay(grossPay: Decimal, deductions: Decimal) -> Decimal {
        max(0, grossPay - deductions)
    }
}
