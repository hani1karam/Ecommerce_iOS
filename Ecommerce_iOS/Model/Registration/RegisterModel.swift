//
//  RegisterModel.swift
//  Ecommerce_iOS
//
//  Created by Hany Karam on 6/22/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
struct RegisterModel: Codable {
    let status: Bool?
    let message: String?
    let data: RegisterModelDataClass?
}

// MARK: - DataClass
struct RegisterModelDataClass: Codable {
    let name, phone, email: String?
    let id: Int?
    let image: String?
    let token: String?
}
