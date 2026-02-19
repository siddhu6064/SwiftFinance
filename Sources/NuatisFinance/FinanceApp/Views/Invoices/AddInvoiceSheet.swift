import SwiftUI

struct AddInvoiceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: InvoicesModuleViewModel

    @State private var number = ""
    @State private var customer = ""
    @State private var amountText = ""
    @State private var status = "Draft"
    @State private var date = Date()

    private let statuses = ["Draft", "Sent", "Paid", "Overdue"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("New Invoice").font(.title2).bold()

            Form {
                TextField("Invoice #", text: $number)
                TextField("Customer", text: $customer)
                TextField("Amount", text: $amountText)
                    .textFieldStyle(.roundedBorder)

                Picker("Status", selection: $status) {
                    ForEach(statuses, id: \.self) { Text($0) }
                }

                DatePicker("Date", selection: $date, displayedComponents: [.date])
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Create") {
                    let amount = Double(amountText) ?? 0
                    vm.addInvoice(number: number, customer: customer, amount: amount, status: status, date: date)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(number.isEmpty || customer.isEmpty)
            }
        }
        .padding(16)
        .frame(width: 420)
    }
}
