import Foundation

struct Invoice {
    let id: UUID
    let number: String
    let customerName: String
    let issueDate: Date
    let dueDate: Date
    let totalAmount: Decimal
    let status: String
}

struct Expense {
    let id: UUID
    let vendorName: String
    let category: String
    let amount: Decimal
    let incurredAt: Date
    let reimbursable: Bool
}

struct Employee {
    let id: UUID
    let fullName: String
    let role: String
    let department: String
    let annualSalary: Decimal
    let startDate: Date
}

struct PayrollRecord {
    let id: UUID
    let periodStart: Date
    let periodEnd: Date
    let grossPay: Decimal
    let deductions: Decimal
    let netPay: Decimal
}


struct Customer {
    let id: UUID
    let name: String
    let email: String
    let arBalance: Decimal
}

struct Vendor {
    let id: UUID
    let name: String
    let category: String
    let apBalance: Decimal
}
