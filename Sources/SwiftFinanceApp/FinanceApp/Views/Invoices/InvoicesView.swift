import SwiftUI

struct InvoicesView: View {
    @StateObject private var vm = InvoicesModuleViewModel()
    @State private var selection = Set<UUID>()

    @State private var sortOrder: [KeyPathComparator<InvoiceRow>] = [
        .init(\.date, order: .reverse)
    ]

    @State private var editingInvoice: InvoiceRow? = nil

    var filtered: [InvoiceRow] {
        let q = vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty { return vm.invoices }
        return vm.invoices.filter {
            $0.number.lowercased().contains(q) ||
            $0.customer.lowercased().contains(q) ||
            $0.status.lowercased().contains(q)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Invoices").font(.title2).bold()
                Spacer()

                TextField("Search invoices…", text: $vm.searchText)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 280)

                Button("New Invoice") { vm.isShowingAddInvoice = true }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut("n", modifiers: [.command])
            }

            Table(filtered, selection: $selection, sortOrder: $sortOrder) {

                TableColumn("Invoice #", value: \.number) { row in
                    Text(row.number)
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 110, ideal: 140, max: 220)

                TableColumn("Customer", value: \.customer) { row in
                    Text(row.customer)
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 140, ideal: 240, max: 420)

                TableColumn("Amount") { row in
                    Text(row.amount, format: .currency(code: "USD"))
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 90, ideal: 120, max: 160)

                TableColumn("Status", value: \.status) { row in
                    Text(row.status)
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 90, ideal: 110, max: 160)

                TableColumn("Date", value: \.date) { row in
                    Text(row.date, format: .dateTime.month().day().year())
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 110, ideal: 140, max: 180)
            }
            .onChange(of: sortOrder) { _, newOrder in
                vm.applySort(newOrder)
            }
            .contextMenu(forSelectionType: UUID.self) { ids in
                Button("Edit") {
                    if let first = vm.invoices.first(where: { ids.contains($0.id) }) {
                        editingInvoice = first
                    }
                }
                .disabled(ids.count != 1)

                Divider()

                Button("Delete") {
                    guard !ids.isEmpty else { return }
                    let toDelete = vm.invoices.filter { ids.contains($0.id) }
                    toDelete.forEach { vm.deleteInvoice($0) }
                    selection.removeAll()
                }
                .keyboardShortcut(.delete, modifiers: [])
            }

            if filtered.isEmpty {
                ContentUnavailableView(
                    "No invoices yet",
                    systemImage: "doc.text",
                    description: Text("Click “New Invoice” to create your first invoice.")
                )
                .padding(.top, 8)
            }
        }
        .padding(16)
        .onAppear { vm.load() }

        // Add sheet
        .sheet(isPresented: $vm.isShowingAddInvoice) {
            AddInvoiceSheet(vm: vm)
        }

        // Edit sheet (double-click / context menu)
        .sheet(item: $editingInvoice) { invoice in
            EditInvoiceSheet(vm: vm, invoice: invoice)
        }
    }
}
