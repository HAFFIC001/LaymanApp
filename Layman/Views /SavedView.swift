import SwiftUI

struct SavedView: View {

    @EnvironmentObject var bookmarkVM: BookmarkViewModel

    var body: some View {

        NavigationStack {

            ZStack {

                AppColors.background
                    .ignoresSafeArea()

                if bookmarkVM.savedArticles.isEmpty {

                    emptyState

                } else {

                    savedList
                }
            }
            .navigationTitle("Saved")
            .task {

                await bookmarkVM.loadBookmarks()
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// SAVED ARTICLES LIST
//////////////////////////////////////////////////////////////

extension SavedView {

    var savedList: some View {

        ScrollView {

            LazyVStack(spacing: 16) {

                ForEach(bookmarkVM.savedArticles, id: \.link) { article in

                    NavigationLink {

                        ArticleDetailView(article: article)

                    } label: {

                        savedCard(article)
                    }
                }
            }
            .padding()
        }
    }

    func savedCard(_ article: Article) -> some View {

        HStack(spacing: 14) {

            AsyncImage(url: URL(string: article.image_url ?? "")) {

                $0.resizable().scaledToFill()

            } placeholder: {

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 90, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(article.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(3)

            Spacer()

            Button {

                Task {

                    await bookmarkVM.removeBookmark(article: article)
                }

            } label: {

                Image(systemName: "bookmark.fill")
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

//////////////////////////////////////////////////////////////
// EMPTY STATE
//////////////////////////////////////////////////////////////

extension SavedView {

    var emptyState: some View {

        VStack(spacing: 14) {

            Image(systemName: "bookmark")
                .font(.system(size: 44))
                .foregroundColor(.gray)

            Text("No saved articles yet")
                .font(.headline)

            Text("Tap the bookmark icon on any article to save it here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
