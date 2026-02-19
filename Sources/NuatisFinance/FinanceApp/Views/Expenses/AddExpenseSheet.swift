import SwiftUI

struct AddExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: ExpensesModuleViewModel

    @State private var vendor = ""
    @State private var category = ""
    @State private var amountText = ""
    @State private var date = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Expense").font(.title2).bold()

            Form {
                TextField("Vendor", text: $vendor)
                TextField("Category", text: $category)
                TextField("Amount", text: $amountText)
                    .textFieldStyle(.roundedBorder)

                DatePicker("Date", selection: $date, displayedComponents: [.date])
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save") {
                    let amount = Double(amountText) ?? 0
                    vm.addExpense(vendor: vendor, category: category, amount: amount, date: date)
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
