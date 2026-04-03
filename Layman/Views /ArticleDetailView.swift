import SwiftUI
import SafariServices

struct ArticleDetailView: View {

    let article: Article

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var bookmarkVM: BookmarkViewModel

    @State private var showChat = false
    @State private var summaries: [String] = []
    @State private var currentCard = 0
    @State private var showSafari = false
    @State private var isLoading = true

    let aiService = AIService()

    var body: some View {

        ZStack {

            //////////////////////////////////////////////////////////
            // BACKGROUND
            //////////////////////////////////////////////////////////

            Color(red: 0.98, green: 0.95, blue: 0.90)
                .ignoresSafeArea()

            //////////////////////////////////////////////////////////
            // MAIN CONTENT
            //////////////////////////////////////////////////////////

            ScrollView {

                VStack(alignment: .leading, spacing: 24) {

                    topBar

                    headline

                    articleImage

                    if isLoading {

                        loadingView

                    } else {

                        summarySection
                    }

                    Spacer(minLength: 160)
                }
                .padding(.horizontal, 22)
                .padding(.top, 12)
            }

            askLaymanButton
        }
        .navigationBarBackButtonHidden(true)

        //////////////////////////////////////////////////////////
        // SAFARI VIEW
        //////////////////////////////////////////////////////////

        .sheet(isPresented: $showSafari) {

            SafariView(url: URL(string: article.link)!)
        }

        //////////////////////////////////////////////////////////
        // CHAT VIEW
        //////////////////////////////////////////////////////////

        .sheet(isPresented: $showChat) {

            ChatView(article: article)
        }

        //////////////////////////////////////////////////////////
        // LOAD SUMMARIES RELIABLY
        //////////////////////////////////////////////////////////

        .task {

            await loadSummaries()
        }
    }
}

//////////////////////////////////////////////////////////////
// LOAD SUMMARIES FUNCTION
//////////////////////////////////////////////////////////////

extension ArticleDetailView {

    func loadSummaries() async {

        isLoading = true

        let result = await aiService.generateSummaries(
            title: article.title,
            url: article.link
        )

        if result.count >= 3 {

            summaries = result

        } else {

            summaries = fallbackSummaries
        }

        isLoading = false
    }
}

//////////////////////////////////////////////////////////////
// TOP BAR
//////////////////////////////////////////////////////////////

extension ArticleDetailView {

    var topBar: some View {

        HStack {

            Button {

                dismiss()

            } label: {

                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }

            Spacer()

            HStack(spacing: 22) {

                Button {

                    showSafari = true

                } label: {

                    Image(systemName: "link")
                }

                Button {

                    Task {

                        await bookmarkVM.toggleBookmark(article: article)
                    }

                } label: {

                    Image(systemName:
                        bookmarkVM.isSaved(article)
                        ? "bookmark.fill"
                        : "bookmark"
                    )
                }

                Button {

                    shareArticle()

                } label: {

                    Image(systemName: "square.and.arrow.up")
                }
            }
            .foregroundColor(.black)
        }
    }

    func shareArticle() {

        guard let url = URL(string: article.link) else { return }

        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}

//////////////////////////////////////////////////////////////
// HEADLINE
//////////////////////////////////////////////////////////////

extension ArticleDetailView {

    var headline: some View {

        Text(article.title)
            .font(.system(size: 26, weight: .bold))
            .lineSpacing(4)
            .foregroundColor(.black)
            .fixedSize(horizontal: false, vertical: true)
    }
}


//////////////////////////////////////////////////////////////
// ARTICLE IMAGE (FIXED SIZE + CONSISTENT LAYOUT)
//////////////////////////////////////////////////////////////

extension ArticleDetailView {

    var articleImage: some View {

        ZStack {

            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.12))

            AsyncImage(url: URL(string: article.image_url ?? "")) { image in

                image
                    .resizable()
                    .scaledToFit()   // ✅ prevents expansion

            } placeholder: {

                ProgressView()
            }
            .padding(12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)   // ✅ fixed universal height
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 4, y: 2)
    }
}

//////////////////////////////////////////////////////////////
// LOADING VIEW
//////////////////////////////////////////////////////////////

extension ArticleDetailView {

    var loadingView: some View {

        VStack {

            ProgressView()

            Text("Generating summaries...")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(height: 150)
    }
}

//////////////////////////////////////////////////////////////
// SUMMARY SECTION
//////////////////////////////////////////////////////////////

extension ArticleDetailView {

    var summarySection: some View {

        VStack(spacing: 14) {

            TabView(selection: $currentCard) {

                ForEach(Array(summaries.enumerated()), id: \.offset) {

                    index, summary in

                    summaryCard(summary)
                        .tag(index)
                }
            }
            .frame(height: 150)
            .tabViewStyle(.page(indexDisplayMode: .never))

            indicatorDots
        }
    }

    func summaryCard(_ text: String) -> some View {

        Text(text)
            .font(.system(size: 15))
            .lineSpacing(4)
            .foregroundColor(.black.opacity(0.85))
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 0.95, green: 0.90, blue: 0.82))
            )
            .padding(.horizontal, 6)
    }

    var indicatorDots: some View {

        HStack(spacing: 6) {

            ForEach(0..<summaries.count, id: \.self) {

                index in

                Circle()
                    .fill(
                        index == currentCard
                        ? Color.orange
                        : Color.gray.opacity(0.3)
                    )
                    .frame(width: 6, height: 6)
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// ASK LAYMAN BUTTON
//////////////////////////////////////////////////////////////

extension ArticleDetailView {

    var askLaymanButton: some View {

        VStack {

            Spacer()

            Button {

                showChat = true

            } label: {

                Text("Ask Layman")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.86, green: 0.43, blue: 0.22))
                    .clipShape(Capsule())
                    .padding(.horizontal, 28)
                    .shadow(
                        color: Color.orange.opacity(0.25),
                        radius: 10,
                        y: 6
                    )
            }
            .padding(.bottom, 110)
        }
    }
}

//////////////////////////////////////////////////////////////
// FALLBACK SUMMARIES
//////////////////////////////////////////////////////////////

extension ArticleDetailView {

    var fallbackSummaries: [String] {

        [

            "This article explains the key development happening right now.",

            "It highlights why this news matters in business or technology.",

            "It suggests what could happen next in this situation."
        ]
    }
}

//////////////////////////////////////////////////////////////
// SAFARI VIEW
//////////////////////////////////////////////////////////////

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: Context)
        -> SFSafariViewController {

        SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _ controller: SFSafariViewController,
        context: Context
    ) {}
}
