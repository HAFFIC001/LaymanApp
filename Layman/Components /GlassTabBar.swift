import SwiftUI
import UIKit

struct GlassTabBar: View {

    @Binding var selectedTab: Tab
    @Namespace private var animation

    @State private var stretchScale: CGFloat = 1

    var body: some View {

        HStack(spacing: 0) {

            ForEach(Tab.allCases, id: \.self) { tab in

                tabButton(tab)
            }
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 40)
        .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
        .scaleEffect(stretchScale)
    }
}

//////////////////////////////////////////////////////////////
// MARK: TAB BUTTON
//////////////////////////////////////////////////////////////

extension GlassTabBar {

    func tabButton(_ tab: Tab) -> some View {

        Button {

            // HAPTIC FEEDBACK
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

            // STRETCH ANIMATION
            withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                stretchScale = 1.08
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {

                withAnimation(.spring()) {
                    stretchScale = 1
                }
            }

            // TAB SWITCH ANIMATION
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {

                selectedTab = tab
            }

        } label: {

            ZStack {

                if selectedTab == tab {

                    Capsule()
                        .fill(Color.orange.opacity(0.25))
                        .matchedGeometryEffect(
                            id: "TAB",
                            in: animation
                        )
                        .frame(height: 45)
                }

                Image(systemName: tab.icon)
                    .font(.system(size: 20))
                    .foregroundColor(
                        selectedTab == tab
                        ? Color.orange
                        : Color.secondary
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
            }
        }
    }
}
