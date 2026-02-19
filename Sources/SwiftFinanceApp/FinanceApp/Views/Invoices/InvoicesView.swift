import SwiftUI

struct InvoicesView: View {
    @StateObject private var vm = InvoicesModuleViewModel()

    @State private var selection = Set<UUID>()
    @State private var sortOrder: [KeyPathComparator<Invoice>] = [
        .init(\.issueDate, order: .reverse)
    ]
    @State private var editingInvoice: Invoice? = nil

    private var filtered: [Invoice] {
        let q = vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty { return vm.invoices }
        return vm.invoices.filter {
            $0.number.lowercased().contains(q) ||
            $0.customerName.lowercased().contains(q) ||
            $0.status.lowercased().contains(q)
        }
    }

    private var selectedInvoice: Invoice? {
        guard selection.count == 1, let id = selection.first else { return nil }
        return vm.invoices.first(where: { $0.id == id })
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

                TableColumn("Customer", value: \.customerName) { row in
                    Text(row.customerName)
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 140, ideal: 240, max: 420)

                TableColumn("Amount") { row in
                    Text(row.totalAmount, format: .currency(code: "USD"))
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 90, ideal: 120, max: 180)

                TableColumn("Status", value: \.status) { row in
                    Text(row.status)
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 90, ideal: 110, max: 160)

                TableColumn("Issue Date", value: \.issueDate) { row in
                    Text(row.issueDate, format: .dateTime.month().day().year())
                        .onTapGesture(count: 2) { editingInvoice = row }
                }
                .width(min: 120, ideal: 150, max: 200)
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
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        vm.isShowingAddInvoice = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .keyboardShortcut("=", modifiers: [.command]) // quick entry Cmd+=

                    Button {
                        if let inv = selectedInvoice { editingInvoice = inv }
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .disabled(selectedInvoice == nil)

                    Button(role: .destructive) {
                        let ids = selection
                        let toDelete = vm.invoices.filter { ids.contains($0.id) }
                        toDelete.forEach { vm.deleteInvoice($0) }
                        selection.removeAll()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .disabled(selection.isEmpty)
                }
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
        .sheet(isPresented: $vm.isShowingAddInvoice) {
            AddInvoiceSheet(vm: vm)
        }
        .sheet(item: $editingInvoice) { invoice in
            EditInvoiceSheet(vm: vm, invoice: invoice)
        }
    }
}
