//
//  UploadOrderData.swift
//  OrderDrinkingApp
//  上傳訂單資訊到Airtable
//
//  Created by Tai on 2022/11/6.
//

import Foundation

struct UploadOrderData: Codable {
    var records: [Records]
    
    struct Records: Codable {
        var fields: Fields
    }
    
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
        var storeName: String
    }
}
