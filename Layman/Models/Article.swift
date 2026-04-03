import Foundation

struct Article: Codable, Identifiable {

    let id = UUID()

    let title: String
    let link: String
    let image_url: String?

    enum CodingKeys: String, CodingKey {

        case title
        case link
        case image_url
    }
}
