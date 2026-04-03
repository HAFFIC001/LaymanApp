import Foundation
import Supabase
import SwiftUI

@MainActor
class BookmarkViewModel: ObservableObject {

    @Published var savedArticles: [Article] = []

    //////////////////////////////////////////////////////////
    // CHECK IF SAVED
    //////////////////////////////////////////////////////////

    func isSaved(_ article: Article) -> Bool {

        savedArticles.contains {
            $0.link == article.link
        }
    }

    //////////////////////////////////////////////////////////
    // LOAD BOOKMARKS
    //////////////////////////////////////////////////////////

    func loadBookmarks() async {

        do {

            let session = try await SupabaseManager
                .shared
                .client
                .auth
                .session

            let response = try await SupabaseManager.shared.client
                .from("bookmarks")
                .select()
                .eq("user_id", value: session.user.id.uuidString)
                .execute()

            let bookmarks = try JSONDecoder().decode(
                [BookmarkRow].self,
                from: response.data
            )

            savedArticles = bookmarks.map {

                Article(
                    title: $0.title,
                    link: $0.link,
                    image_url: $0.image_url
                )
            }

        } catch {

            print("Load bookmarks error:", error.localizedDescription)
        }
    }

    //////////////////////////////////////////////////////////
    // SAVE BOOKMARK
    //////////////////////////////////////////////////////////

    func saveBookmark(article: Article) async {

        do {

            let session = try await SupabaseManager
                .shared
                .client
                .auth
                .session

            try await SupabaseManager.shared.client
                .from("bookmarks")
                .insert([
                    "user_id": session.user.id.uuidString,
                    "title": article.title,
                    "link": article.link,
                    "image_url": article.image_url ?? ""
                ])
                .execute()

            savedArticles.append(article)

        } catch {

            print("Save bookmark error:", error.localizedDescription)
        }
    }

    //////////////////////////////////////////////////////////
    // REMOVE BOOKMARK
    //////////////////////////////////////////////////////////

    func removeBookmark(article: Article) async {

        do {

            try await SupabaseManager.shared.client
                .from("bookmarks")
                .delete()
                .eq("link", value: article.link)
                .execute()

            savedArticles.removeAll {

                $0.link == article.link
            }

        } catch {

            print("Remove bookmark error:", error.localizedDescription)
        }
    }

    //////////////////////////////////////////////////////////
    // TOGGLE BOOKMARK
    //////////////////////////////////////////////////////////

    func toggleBookmark(article: Article) async {

        if isSaved(article) {

            await removeBookmark(article: article)

        } else {

            await saveBookmark(article: article)
        }
    }
}

//////////////////////////////////////////////////////////////
// SUPPORT MODEL
//////////////////////////////////////////////////////////////

struct BookmarkRow: Decodable {

    let title: String
    let link: String
    let image_url: String?
}
