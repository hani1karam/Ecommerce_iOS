//
//  FavModel.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
 
// MARK: - HomeModel
struct FavModel: Codable {
    let status: Bool
    let message: String
    let data: FavModelDataClass
}

// MARK: - DataClass
struct FavModelDataClass: Codable {
    let id: Int
    let product: FavProduct
}

// MARK: - Product
struct FavProduct: Codable {
    let id: Int
    let price, oldPrice: Double
    let discount: Int
    let image: String

    enum CodingKeys: String, CodingKey {
        case id, price
        case oldPrice = "old_price"
        case discount, image
    }
}
