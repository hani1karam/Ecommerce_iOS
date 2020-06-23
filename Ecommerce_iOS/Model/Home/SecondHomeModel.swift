//
//  SecondHomeModel.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
// MARK: - SecondHomeModel
struct SecondHomeModel: Codable {
    let status: Bool?
    let message: JSON?
    let data: SecondHomeModelDataClass?
}

// MARK: - DataClass
struct SecondHomeModelDataClass: Codable {
    let currentPage: Int?
    let data: [Datum]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let nextPageURL: JSON?
    let path: String?
    let perPage: Int?
    let prevPageURL: JSON?
    let to, total: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int?
    let price, oldPrice: Double
    let discount: Int?
    let image: String?
    let name, datumDescription: String?
    let images: [String]
    let inFavorites, inCart: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, price
        case oldPrice = "old_price"
        case discount, image, name
        case datumDescription = "description"
        case images
        case inFavorites = "in_favorites"
        case inCart = "in_cart"
    }
}

// MARK: - Encode/decode helpers

class JSON: Codable, Hashable {
    
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSON.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
