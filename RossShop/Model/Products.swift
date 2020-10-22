import Foundation

// MARK: - Products
struct Products: Codable {
    var data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    var products: [Product]?
    var totalPages, totalCount: Int?
}

// MARK: - Product
struct Product: Codable {
    var brand: String?
    var brandID: Int?
    var caption: String?
    var averageRating: Double?
    var totalReviews, id, rossnetID: Int?
    var eanNumber: [String]?
    var navigateURL, name: String?
    var price: Double?
    var pricePerUnit: String?
    var vat, dimensional: Int?
    var pictures: [Picture]?
    var hasRichContent: Bool?
    var category: String?

    enum CodingKeys: String, CodingKey {
        case brand
        case brandID
        case caption,averageRating, totalReviews, id
        case rossnetID
        case eanNumber
        case navigateURL
        case name, price, pricePerUnit, vat, dimensional, pictures, hasRichContent, category
    }
}

// MARK: - Picture
struct Picture: Codable {
    var id: Int?
    var mini, medium, small, large: String?
    var type: Int?
}
