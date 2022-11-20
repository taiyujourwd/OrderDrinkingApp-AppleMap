//
//  StoreInfo.swift
//  OrderDrinkingApp
//
//  Created by Tai on 2022/11/10.
//

import Foundation

struct StoreInfo: Codable {
    var results: [StoreDetail]
    
    struct StoreDetail: Codable {
        var geometry: Location
        var name: String
        var vicinity: String
        
        struct Location: Codable {
            var location: LatLng
            
            struct LatLng: Codable {
                var lat: Double
                var lng: Double
            }
        }
    }
}
