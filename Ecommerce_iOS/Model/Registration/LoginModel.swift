//
//  LoginModel.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
// MARK: - LoginModel
struct LoginModel: Codable {
    let status: Bool?
    let message: String?
    let data: LoginModelDataClass?
}

// MARK: - DataClass
struct LoginModelDataClass: Codable {
    let id: Int?
    let name, email, phone: String?
    let image: String?
    let points: Int?
    let credit: Double?
    let token: String?
}
