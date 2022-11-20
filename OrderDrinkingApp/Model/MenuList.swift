//
//  MenuList.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/4.
//

import UIKit

struct MenuList: Codable {
    var records: [DrinkingRecords]
}

struct DrinkingRecords: Codable {
    var fields: DrinkingDetail
}

struct DrinkingDetail: Codable {
    var price: Int
    var name: String
    var image: [imageDeatil]
    var iceHotKind: [String]
    var category: String
    
    struct imageDeatil: Codable {
        var url: URL
    }
}

