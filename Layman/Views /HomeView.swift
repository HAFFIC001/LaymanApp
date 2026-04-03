import SwiftUI

struct HomeView: View {

    @State private var articles: [Article] = []
    @State private var currentIndex = 0

    let service = NewsService()

    var body: some View {

        NavigationStack {

            ZStack {

                // MARK: Background Color (Matches Mock)

                AppColors.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {

                    VStack(spacing: 22) {

                        header

                        if articles.isEmpty {

                            ProgressView()
                                .padding(.top, 120)

                        } else {

                            featuredCarousel

                            pageDots

                            todaysPicks
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
            .task {

                articles = await service.fetchArticles()
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// HEADER
//////////////////////////////////////////////////////////////

extension HomeView {

    var header: some View {

        HStack {

            Text("Layman")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundColor(.black)
        }
        .padding(.horizontal)
    }
}

//////////////////////////////////////////////////////////////
// FEATURED CAROUSEL
//////////////////////////////////////////////////////////////

extension HomeView {

    var featuredCarousel: some View {

        TabView(selection: $currentIndex) {

            ForEach(Array(articles.prefix(5).enumerated()), id: \.offset) { index, article in

                ZStack(alignment: .bottomLeading) {

                    AsyncImage(url: URL(string: article.image_url ?? "")) { image in

                        image
                            .resizable()
                            .scaledToFill()

                    } placeholder: {

                        Color.gray.opacity(0.25)
                    }

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.65)],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    Text(article.title)
                        .foregroundColor(.white)
                        .font(.headline)
                        .lineLimit(2)
                        .padding()
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal)
                .tag(index)
            }
        }
        .frame(height: 200)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

//////////////////////////////////////////////////////////////
// PAGE DOTS
//////////////////////////////////////////////////////////////

extension HomeView {

    var pageDots: some View {

        HStack(spacing: 6) {

            ForEach(0..<min(5, articles.count), id: \.self) { index in

                Circle()
                    .fill(index == currentIndex
                          ? Color.orange
                          : Color.gray.opacity(0.25))
                    .frame(width: 6, height: 6)
            }
        }
    }
}

//////////////////////////////////////////////////////////////
// TODAY'S PICKS HEADER
//////////////////////////////////////////////////////////////

extension HomeView {

    var todaysPicks: some View {

        VStack(spacing: 16) {

            HStack {

                Text("Today's Picks")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                Text("View All")
                    .font(.system(size: 14))
                    .foregroundColor(
                        Color(red: 0.86, green: 0.43, blue: 0.22)
                    )
            }
            .padding(.horizontal)

            articleList
        }
    }
}

//////////////////////////////////////////////////////////////
// ARTICLE LIST CARDS
//////////////////////////////////////////////////////////////

extension HomeView {

    var articleList: some View {

        VStack(spacing: 14) {

            ForEach(articles) { article in

                NavigationLink {

                    ArticleDetailView(article: article)

                } label: {

                    HStack(spacing: 14) {

                        AsyncImage(
                            url: URL(string: article.image_url ?? "")
                        ) { image in

                            image
                                .resizable()
                                .scaledToFill()

                        } placeholder: {

                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        Text(article.title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                            .lineLimit(2)

                        Spacer()
                    }
                    .padding()
                    .background(
                        AppColors.card                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                }
            }
        }
    }
}
