//
//  RepositoryModel.swift
//  PPCurrencyConversion
//
//  Created by Jeremy Lua on 22/1/22.
//  Copyright © 2022 Jeremy Lua. All rights reserved.
//

import UIKit

struct RepositoryModel: Codable {
    var items: [Item]
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct Item: Codable {
    var identifier: Int
    var full_name: String
    var html_url: String
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case full_name
        case html_url
    }
    
}
