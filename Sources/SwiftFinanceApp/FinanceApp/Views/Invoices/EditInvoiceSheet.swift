import SwiftUI

struct EditInvoiceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: InvoicesModuleViewModel

    let invoice: InvoiceRow

    @State private var number: String
    @State private var customer: String
    @State private var amountText: String
    @State private var status: String
    @State private var date: Date

    init(vm: InvoicesModuleViewModel, invoice: InvoiceRow) {
        self.vm = vm
        self.invoice = invoice
        _number = State(initialValue: invoice.number)
        _customer = State(initialValue: invoice.customer)
        _amountText = State(initialValue: String(invoice.amount))
        _status = State(initialValue: invoice.status)
        _date = State(initialValue: invoice.date)
    }

    private let statuses = ["Draft", "Sent", "Paid", "Overdue"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edit Invoice").font(.title2).bold()

            Form {
                TextField("Invoice #", text: $number)
                TextField("Customer", text: $customer)
                TextField("Amount", text: $amountText)

                Picker("Status", selection: $status) {
                    ForEach(statuses, id: \.self) { Text($0) }
                }

                DatePicker("Date", selection: $date, displayedComponents: [.date])
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save") {
                    let amount = Double(amountText) ?? invoice.amount
                    vm.updateInvoice(
                        InvoiceRow(id: invoice.id, number: number, customer: customer, amount: amount, status: status, date: date)
                    )
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
