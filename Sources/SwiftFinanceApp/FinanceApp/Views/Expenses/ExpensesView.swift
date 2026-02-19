import SwiftUI

struct ExpensesView: View {
    @StateObject private var vm = ExpensesModuleViewModel()
    @State private var selection = Set<UUID>()

    @State private var sortOrder: [KeyPathComparator<ExpenseRow>] = [
        .init(\.date, order: .reverse)
    ]

    @State private var editingExpense: ExpenseRow? = nil

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
                    .keyboardShortcut("e", modifiers: [.command])
            }

            Table(filtered, selection: $selection, sortOrder: $sortOrder) {

                TableColumn("Vendor", value: \.vendor) { row in
                    Text(row.vendor)
                        .onTapGesture(count: 2) { editingExpense = row }
                }
                .width(min: 140, ideal: 240, max: 420)

                TableColumn("Category", value: \.category) { row in
                    Text(row.category)
                        .onTapGesture(count: 2) { editingExpense = row }
                }
                .width(min: 120, ideal: 180, max: 260)

                TableColumn("Amount") { row in
                    Text(row.amount, format: .currency(code: "USD"))
                        .onTapGesture(count: 2) { editingExpense = row }
                }
                .width(min: 90, ideal: 120, max: 160)

                TableColumn("Date", value: \.date) { row in
                    Text(row.date, format: .dateTime.month().day().year())
                        .onTapGesture(count: 2) { editingExpense = row }
                }
                .width(min: 110, ideal: 140, max: 180)
            }
            .onChange(of: sortOrder) { _, newOrder in
                vm.applySort(newOrder)
            }
            .contextMenu(forSelectionType: UUID.self) { ids in
                Button("Edit") {
                    if let first = vm.expenses.first(where: { ids.contains($0.id) }) {
                        editingExpense = first
                    }
                }
                .disabled(ids.count != 1)

                Divider()

                Button("Delete") {
                    guard !ids.isEmpty else { return }
                    let toDelete = vm.expenses.filter { ids.contains($0.id) }
                    toDelete.forEach { vm.deleteExpense($0) }
                    selection.removeAll()
                }
                .keyboardShortcut(.delete, modifiers: [])
            }

            if filtered.isEmpty {
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

        // Add sheet
        .sheet(isPresented: $vm.isShowingAddExpense) {
            AddExpenseSheet(vm: vm)
        }

        // Edit sheet (double-click / context menu)
        .sheet(item: $editingExpense) { expense in
            EditExpenseSheet(vm: vm, expense: expense)
        }
    }
}
