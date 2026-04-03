import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var bookmarkVM: BookmarkViewModel
    @State private var selectedTab: Tab = .home

    var body: some View {

        ZStack(alignment: .bottom) {

            //////////////////////////////////////////////////////////
            // SCREEN CONTENT
            //////////////////////////////////////////////////////////

            Group {

                switch selectedTab {

                case .home:
                    HomeView()

                case .saved:
                    SavedView()

                case .profile:
                    ProfileView()
                }
            }

            //////////////////////////////////////////////////////////
            // GLASS TAB BAR
            //////////////////////////////////////////////////////////

            GlassTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 10)
        }
        .ignoresSafeArea(.keyboard)

        //////////////////////////////////////////////////////////
        // LOAD BOOKMARKS FROM SUPABASE
        //////////////////////////////////////////////////////////

        .task {

            await bookmarkVM.loadBookmarks()
        }
    }
}

//////////////////////////////////////////////////////////////
// MARK: TAB ENUM
//////////////////////////////////////////////////////////////

enum Tab: CaseIterable {

    case home
    case saved
    case profile

    var icon: String {

        switch self {

        case .home:
            return "house.fill"

        case .saved:
            return "bookmark.fill"

        case .profile:
            return "person.fill"
        }
    }

    var title: String {

        switch self {

        case .home:
            return "Home"

        case .saved:
            return "Saved"

        case .profile:
            return "Profile"
        }
    }
}
