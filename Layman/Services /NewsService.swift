import Foundation

class NewsService {

    func fetchArticles() async -> [Article] {

        let apiKey = "pub_e8dc3b0c890d4223999e98c9026805fe"

        let urlString =
        "https://newsdata.io/api/1/news?apikey=\(apiKey)&category=technology,science,business&language=en"

        guard let url = URL(string: urlString) else {

            print("Invalid URL")

            return []
        }

        do {

            let (data, _) = try await URLSession.shared.data(from: url)

            let decoded = try JSONDecoder().decode(
                NewsResponse.self,
                from: data
            )

            return decoded.results.filter {

                $0.image_url != nil
            }

        } catch {

            print("API ERROR:", error)

            return []
        }
    }
}
