import SwiftUI

struct TableColumnDefinition<RowData: Identifiable> {
    let title: String
    let width: CGFloat?
    let content: (RowData) -> AnyView
}

struct DataTable<RowData: Identifiable>: View {
    let rows: [RowData]
    let columns: [TableColumnDefinition<RowData>]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(columns.enumerated()), id: \.offset) { _, col in
                    Text(col.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: col.width ?? .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }
            }
            .background(.thinMaterial)

            ForEach(rows) { row in
                HStack(spacing: 0) {
                    ForEach(Array(columns.enumerated()), id: \.offset) { _, col in
                        col.content(row)
                            .frame(maxWidth: col.width ?? .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                    }
                }
                Divider()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
}
