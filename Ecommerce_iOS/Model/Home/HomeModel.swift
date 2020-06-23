//
//  HomeModel.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation

// MARK: - HomeModel
struct HomeModel: Codable {
    let status: Bool
    let message: JSONNull?
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let banners: [Banner]
    let products: [Product]
    let ad: String
}

// MARK: - Banner
struct Banner: Codable {
    let id: Int
    let image: String
    let category, product: JSONNull?
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let price, oldPrice: Double
    let discount: Int
    let image: String
    let name, productDescription: String
    let images: [String]
    let inFavorites, inCart: Bool

    enum CodingKeys: String, CodingKey {
        case id, price
        case oldPrice = "old_price"
        case discount, image, name
        case productDescription = "description"
        case images
        case inFavorites = "in_favorites"
        case inCart = "in_cart"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
