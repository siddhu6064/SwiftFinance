import SwiftUI

struct SidebarView: View {
    @Binding var selection: AppSection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FinanceApp")
                .font(.title3.weight(.semibold))
                .padding(.horizontal, 16)
                .padding(.top, 18)

            Divider().padding(.horizontal, 8)

            ScrollView {
                VStack(spacing: 4) {
                    ForEach(AppSection.allCases) { section in
                        SidebarItem(
                            title: section.title,
                            icon: section.icon,
                            selected: selection == section
                        ) {
                            selection = section
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 8)
            }

            Spacer(minLength: 0)
        }
    }
}
