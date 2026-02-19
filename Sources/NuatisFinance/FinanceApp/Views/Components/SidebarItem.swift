import SwiftUI

struct SidebarItem: View {
    let title: String
    let icon: String
    let selected: Bool
    let action: () -> Void

    @State private var hovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .frame(width: 18)
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                Spacer()
            }
            .foregroundStyle(selected ? .primary : .secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
        .onHover { hovered = $0 }
    }

    private var background: some ShapeStyle {
        if selected { return AnyShapeStyle(.ultraThinMaterial) }
        if hovered { return AnyShapeStyle(.quaternary) }
        return AnyShapeStyle(.clear)
    }
}
