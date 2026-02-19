import SwiftUI

struct ExpensesView: View {
    @StateObject private var vm = ExpensesModuleViewModel()

    @State private var selection = Set<UUID>()
    @State private var sortOrder: [KeyPathComparator<Expense>] = [
        .init(\.incurredAt, order: .reverse)
    ]
    @State private var editingExpense: Expense? = nil

    private var filtered: [Expense] {
        let q = vm.searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if q.isEmpty { return vm.expenses }
        return vm.expenses.filter {
            $0.vendorName.lowercased().contains(q) ||
            $0.category.lowercased().contains(q)
        }
    }

    private var selectedExpense: Expense? {
        guard selection.count == 1, let id = selection.first else { return nil }
        return vm.expenses.first(where: { $0.id == id })
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
                TableColumn("Vendor", value: \.vendorName) { row in
                    Text(row.vendorName)
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
                .width(min: 90, ideal: 120, max: 180)

                TableColumn("Date", value: \.incurredAt) { row in
                    Text(row.incurredAt, format: .dateTime.month().day().year())
                        .onTapGesture(count: 2) { editingExpense = row }
                }
                .width(min: 120, ideal: 150, max: 200)
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
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        vm.isShowingAddExpense = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .keyboardShortcut("=", modifiers: [.command]) // quick entry Cmd+=

                    Button {
                        if let exp = selectedExpense { editingExpense = exp }
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .disabled(selectedExpense == nil)

                    Button(role: .destructive) {
                        let ids = selection
                        let toDelete = vm.expenses.filter { ids.contains($0.id) }
                        toDelete.forEach { vm.deleteExpense($0) }
                        selection.removeAll()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .disabled(selection.isEmpty)
                }
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
        .sheet(isPresented: $vm.isShowingAddExpense) {
            AddExpenseSheet(vm: vm)
        }
        .sheet(item: $editingExpense) { expense in
            EditExpenseSheet(vm: vm, expense: expense)
        }
    }
}
