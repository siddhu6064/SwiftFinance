import SwiftUI

struct HeaderBar: View {
    let appTitle: String
    let companyName: String
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            Text(appTitle)
                .font(.title2.weight(.semibold))

            Picker("Company", selection: .constant(companyName)) {
                Text(companyName).tag(companyName)
            }
            .pickerStyle(.menu)
            .frame(width: 190)

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search invoices, customers, payroll...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(width: 330)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            Button {
            } label: {
                Label("Add", systemImage: "plus")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.borderedProminent)

            Button { } label: {
                Image(systemName: "bell")
            }
            .buttonStyle(.bordered)

            Circle()
                .fill(.quaternary)
                .overlay(Text("SF").font(.caption.weight(.semibold)))
                .frame(width: 30, height: 30)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(.bar)
        .overlay(alignment: .bottom) { Divider() }
    }
}
