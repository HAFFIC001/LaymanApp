import SwiftUI

@main
struct LaymanApp: App {

    @StateObject var authVM = AuthViewModel()
    @StateObject var bookmarkVM = BookmarkViewModel()

    var body: some Scene {

        WindowGroup {

            if authVM.isLoggedIn {

                MainTabView()
                    .environmentObject(authVM)
                    .environmentObject(bookmarkVM)
                    .preferredColorScheme(.light)

            } else {

                WelcomeView()
                    .environmentObject(authVM)
                    .environmentObject(bookmarkVM)
                    .preferredColorScheme(.light)
            }
        }
    }
}
