import SwiftUI

struct EditExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ExpensesModuleViewModel

    let expense: Expense

    @State private var vendorName: String
    @State private var category: String
    @State private var amountText: String
    @State private var incurredAt: Date
    @State private var reimbursable: Bool

    init(vm: ExpensesModuleViewModel, expense: Expense) {
        self.vm = vm
        self.expense = expense
        _vendorName = State(initialValue: expense.vendorName)
        _category = State(initialValue: expense.category)
        _amountText = State(initialValue: "\(expense.amount)")
        _incurredAt = State(initialValue: expense.incurredAt)
        _reimbursable = State(initialValue: expense.reimbursable)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edit Expense").font(.title2).bold()

            Form {
                TextField("Vendor", text: $vendorName)
                TextField("Category", text: $category)
                TextField("Amount", text: $amountText)
                DatePicker("Date", selection: $incurredAt, displayedComponents: [.date])
                Toggle("Reimbursable", isOn: $reimbursable)
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save") {
                    let amount = Decimal(string: amountText) ?? expense.amount
                    let updated = Expense(
                        id: expense.id,
                        vendorName: vendorName,
                        category: category,
                        amount: amount,
                        incurredAt: incurredAt,
                        reimbursable: reimbursable
                    )
                    vm.updateExpense(updated)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(vendorName.isEmpty || category.isEmpty)
            }
        }
        .padding(16)
        .frame(width: 460)
    }
}
