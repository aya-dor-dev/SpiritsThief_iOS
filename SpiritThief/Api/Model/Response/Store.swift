//
//  Store.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class Store: Mappable {
    static let LAST_UPDATED_THRESHOLD = 7
    
    var price: Double? = nil
    var currency: String? = nil
    var productId: UInt64 = 0
    var storeId: UInt64 = 0
    var url: String? = nil
    var name: String? = nil
    var imageUrl: String? = nil
    var flagImageUrl: String? = nil
    var countryCode = ""
    var lastUpdated: String? = nil
    var valid: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        price <- map["price"]
        currency <- map["currency"]
        productId <- map["product_id"]
        storeId <- map["store_id"]
        url <- map["url"]
        name <- map["name"]
        imageUrl <- map["store_image_url"]
        flagImageUrl <- map["store_flag"]
        countryCode <- map["shop_country"]
        lastUpdated <- map["last_update"]
        valid <- map["valid"]
    }
}
