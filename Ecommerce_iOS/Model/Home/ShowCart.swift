//
//  ShowCart.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/23/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation

import Foundation

// MARK: - HomeModel
struct ShowCart: Codable {
    let status: Bool
    let message: Null?
    let data: ShowCartDataClass
}

// MARK: - DataClass
struct ShowCartDataClass: Codable {
    let cartItems: [CartItem]
    let subTotal, total: Double

    enum CodingKeys: String, CodingKey {
        case cartItems = "cart_items"
        case subTotal = "sub_total"
        case total
    }
}

// MARK: - CartItem
struct CartItem: Codable {
    let id, quantity: Int
    let product: ShowCartProductProduct
}

// MARK: - Product
struct ShowCartProductProduct: Codable {
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

class Null: Codable, Hashable {

    public static func == (lhs: Null, rhs: Null) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(Null.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

 
