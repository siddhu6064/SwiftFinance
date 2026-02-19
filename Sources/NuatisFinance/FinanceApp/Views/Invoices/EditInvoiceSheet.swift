import SwiftUI

struct EditInvoiceSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: InvoicesModuleViewModel

    let invoice: Invoice

    @State private var number: String
    @State private var customerName: String
    @State private var amountText: String
    @State private var status: String
    @State private var issueDate: Date
    @State private var dueDate: Date

    init(vm: InvoicesModuleViewModel, invoice: Invoice) {
        self.vm = vm
        self.invoice = invoice
        _number = State(initialValue: invoice.number)
        _customerName = State(initialValue: invoice.customerName)
        _amountText = State(initialValue: "\(invoice.totalAmount)")
        _status = State(initialValue: invoice.status)
        _issueDate = State(initialValue: invoice.issueDate)
        _dueDate = State(initialValue: invoice.dueDate)
    }

    private let statuses = ["Draft", "Sent", "Paid", "Overdue"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edit Invoice").font(.title2).bold()

            Form {
                TextField("Invoice #", text: $number)
                TextField("Customer", text: $customerName)
                TextField("Amount", text: $amountText)

                Picker("Status", selection: $status) {
                    ForEach(statuses, id: \.self) { Text($0) }
                }

                DatePicker("Issue Date", selection: $issueDate, displayedComponents: [.date])
                DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
            }

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button("Save") {
                    let amount = Decimal(string: amountText) ?? invoice.totalAmount
                    let updated = Invoice(
                        id: invoice.id,
                        number: number,
                        customerName: customerName,
                        issueDate: issueDate,
                        dueDate: dueDate,
                        totalAmount: amount,
                        status: status
                    )
                    vm.updateInvoice(updated)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(number.isEmpty || customerName.isEmpty)
            }
        }
        .padding(16)
        .frame(width: 460)
    }
}
