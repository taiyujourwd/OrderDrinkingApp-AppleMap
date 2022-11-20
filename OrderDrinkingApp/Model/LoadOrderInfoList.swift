//
//  LoadOrderInfoList.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/7.
//

import Foundation

struct LoadOrderInfoList: Codable {
    var records: [Records]
    
    struct Records: Codable {
        var id: String
        var createdTime: Date
        var fields: Fields
    }
    
    struct Fields: Codable {
        var name: String
        var price: Double
        var iceDegree: String
        var sugarDegree: String
        var cupAmount: Int
        var comment: String
        var userName: String
        var userPhone: String
        var totalAmount: Int
        var storeName: String
    }
}
