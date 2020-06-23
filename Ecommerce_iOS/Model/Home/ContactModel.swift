//
//  ContactModel.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/23/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
// MARK: - ContactModel
struct ContactModel: Codable {
    let status: Bool?
    let message: JN?
    let data: ContactModelDataClass
}

// MARK: - DataClass
struct ContactModelDataClass: Codable {
    let currentPage: Int?
    let data: [ContactModelDatum]
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let nextPageURL: JSONNull?
    let path: String?
    let perPage: Int?
    let prevPageURL: JSONNull?
    let to, total: Int

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
struct ContactModelDatum: Codable {
    let id, type: Int?
    let value: String?
    let image: String?
}

// MARK: - Encode/decode helpers

class JN: Codable, Hashable {

    public static func == (lhs: JN, rhs: JN) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JN.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
