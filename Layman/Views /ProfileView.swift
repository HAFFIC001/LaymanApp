import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var bookmarkVM: BookmarkViewModel
    @EnvironmentObject var authVM: AuthViewModel

    @AppStorage("readingStreak") private var readingStreak = 1
    @AppStorage("lastOpenedDate") private var lastOpenedDate = ""

    var body: some View {

        NavigationStack {

            ZStack {

                AppColors.background
                    .ignoresSafeArea()

                ScrollView {

                    VStack(spacing: 24) {

                        profileHeader

                        streakCard

                        savedArticlesCard

                        signOutButton
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Profile")
            .onAppear {

                updateReadingStreak()
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// PROFILE HEADER
//////////////////////////////////////////////////////////////

extension ProfileView {

    var profileHeader: some View {

        VStack(spacing: 12) {

            Circle()
                .fill(AppColors.accent.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 34))
                        .foregroundColor(AppColors.accent)
                )

            Text("Krishna Gupta")
                .font(.title2.bold())

            Text("krishna@email.com")
                .foregroundColor(.secondary)
                .font(.subheadline)
        }
    }
}

//////////////////////////////////////////////////////////////
// READING STREAK CARD
//////////////////////////////////////////////////////////////

extension ProfileView {

    var streakCard: some View {

        HStack {

            VStack(alignment: .leading, spacing: 6) {

                Text("Reading Streak")
                    .font(.headline)

                Text("\(readingStreak) day\(readingStreak > 1 ? "s" : "")")
                    .font(.title.bold())
                    .foregroundColor(AppColors.accent)
            }

            Spacer()

            Image(systemName: "flame.fill")
                .font(.system(size: 32))
                .foregroundColor(.orange)
        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}

//////////////////////////////////////////////////////////////
// SAVED ARTICLES CARD
//////////////////////////////////////////////////////////////

extension ProfileView {

    var savedArticlesCard: some View {

        HStack {

            VStack(alignment: .leading, spacing: 6) {

                Text("Saved Articles")
                    .font(.headline)

                Text("\(bookmarkVM.savedArticles.count)")
                    .font(.title.bold())
                    .foregroundColor(AppColors.accent)
            }

            Spacer()

            Image(systemName: "bookmark.fill")
                .font(.system(size: 28))
                .foregroundColor(AppColors.accent)
        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}

//////////////////////////////////////////////////////////////
// SIGN OUT BUTTON (WORKING VERSION)
//////////////////////////////////////////////////////////////

extension ProfileView {

    var signOutButton: some View {

        Button {

            Task {

                await authVM.signOut()
            }

        } label: {

            Text("Sign Out")
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.red)
                .clipShape(
                    RoundedRectangle(cornerRadius: 28)
                )
                .padding(.horizontal)
        }
        .padding(.top, 10)
    }
}

//////////////////////////////////////////////////////////////
// STREAK LOGIC
//////////////////////////////////////////////////////////////

extension ProfileView {

    func updateReadingStreak() {

        let today = Date().formatted(date: .numeric, time: .omitted)

        if lastOpenedDate.isEmpty {

            lastOpenedDate = today
            return
        }

        if lastOpenedDate != today {

            readingStreak += 1
            lastOpenedDate = today
        }
    }
}
