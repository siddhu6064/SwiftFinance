import SwiftUI

struct ExpensesView: View {
    @StateObject private var vm = ExpensesModuleViewModel()
    @State private var selection = Set<UUID>()

    var filtered: [ExpenseRow] {
        let q = vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty { return vm.expenses }
        return vm.expenses.filter {
            $0.vendor.lowercased().contains(q) ||
            $0.category.lowercased().contains(q)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Expenses").font(.title2).bold()
                Spacer()
                TextField("Search expenses…", text: $vm.searchText)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 280)

                Button("Add Expense") { vm.isShowingAddExpense = true }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut("e", modifiers: [.command]) // ✅ added
            }

            Table(filtered, selection: $selection) {
                TableColumn("Vendor") { Text($0.vendor) }
                TableColumn("Category") { Text($0.category) }
                TableColumn("Amount") { Text($0.amount, format: .currency(code: "USD")) }
                TableColumn("Date") { Text($0.date, format: .dateTime.month().day().year()) }
            }
            .contextMenu(forSelectionType: UUID.self) { ids in
                Button("Delete") {
                    guard !ids.isEmpty else { return } // ✅ added
                    let toDelete = vm.expenses.filter { ids.contains($0.id) }
                    toDelete.forEach { vm.deleteExpense($0) }
                    selection.removeAll()
                }
            }

            if filtered.isEmpty { // ✅ added
                ContentUnavailableView(
                    "No expenses yet",
                    systemImage: "tray",
                    description: Text("Click “Add Expense” to record your first expense.")
                )
                .padding(.top, 8)
            }
        }
        .padding(16)
        .onAppear { vm.load() }
        .sheet(isPresented: $vm.isShowingAddExpense) {
            AddExpenseSheet(vm: vm)
        }
    }
}
