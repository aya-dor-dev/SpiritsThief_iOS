//
//  ShopStat.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 18/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class ShopStats: Stats {
    var name: String = ""
    var countryCode = ""
    var storeFlag = ""
    
    override func mapping(map: Map) {
        links <- map["num_links"]
        name <- map["name"]
        countryCode <- map["country"]
        storeFlag <- map["store_flag"]
    }
}
