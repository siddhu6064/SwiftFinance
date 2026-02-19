import SwiftUI

struct InvoicesView: View {
    @StateObject private var vm = InvoicesModuleViewModel()
    @State private var selection = Set<UUID>()

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
                    .keyboardShortcut("n", modifiers: [.command]) // ✅ added
            }

            Table(filtered, selection: $selection) {
                TableColumn("Invoice #") { Text($0.number) }
                TableColumn("Customer") { Text($0.customer) }
                TableColumn("Amount") { Text($0.amount, format: .currency(code: "USD")) }
                TableColumn("Status") { Text($0.status) }
                TableColumn("Date") { Text($0.date, format: .dateTime.month().day().year()) }
            }
            .contextMenu(forSelectionType: UUID.self) { ids in
                Button("Delete") {
                    guard !ids.isEmpty else { return } // ✅ added
                    let toDelete = vm.invoices.filter { ids.contains($0.id) }
                    toDelete.forEach { vm.deleteInvoice($0) }
                    selection.removeAll()
                }
            }

            if filtered.isEmpty { // ✅ added
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
    }
}
