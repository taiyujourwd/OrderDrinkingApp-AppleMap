//
//  UpdateOrderInfo.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/9.
//

import Foundation

struct UpdateOrderInfo: Codable {
    var fields: Fields
    
    struct Fields: Codable {
        var name: String
        var price: Int
        var iceDegree: String
        var sugarDegree: String
        var cupAmount: Int
        var comment: String
        var userName: String
        var userPhone: String
        var totalAmount: Int
        var updateTime: String
        var storeName: String
    }
}
