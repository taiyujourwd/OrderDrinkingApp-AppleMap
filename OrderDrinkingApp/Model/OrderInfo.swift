//
//  OrderInfo.swift
//  OrderDrinkingApp
//  下載訂單資訊
//
//  Created by Tai on 2022/11/6.
//

import Foundation

struct OrderInfo: Codable {
    var id: String
    var createdTime: Date
    var fields: Fields
    
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
    }
}
