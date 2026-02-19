import SwiftUI

struct EditExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ExpensesModuleViewModel

    let expense: ExpenseRow

    @State private var vendor: String
    @State private var category: String
    @State private var amountText: String
    @State private var date: Date

    init(vm: ExpensesModuleViewModel, expense: ExpenseRow) {
        self.vm = vm
        self.expense = expense
        _vendor = State(initialValue: expense.vendor)
        _category = State(initialValue: expense.category)
        _amountText = State(initialValue: String(expense.amount))
        _date = State(initialValue: expense.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edit Expense").font(.title2).bold()

            Form {
                TextField("Vendor", text: $vendor)
                TextField("Category", text: $category)
                TextField("Amount", text: $amountText)
                DatePicker("Date", selection: $date, displayedComponents: [.date])
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save") {
                    let amount = Double(amountText) ?? expense.amount
                    vm.updateExpense(
                        ExpenseRow(id: expense.id, vendor: vendor, category: category, amount: amount, date: date)
                    )
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(vendor.isEmpty || category.isEmpty)
            }
        }
        .padding(16)
        .frame(width: 420)
    }
}
