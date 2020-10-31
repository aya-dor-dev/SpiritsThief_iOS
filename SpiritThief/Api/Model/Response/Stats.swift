//
//  Stats.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class Stats: Mappable {
    var brands: Int = 0
    var links: Int = 0
    var bottlers: Int = 0
    var products: Int = 0
    var stores: String = "0"
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        brands <- map["num_distilleries"]
        links <- map["num_links"]
        bottlers <- map["num_bottler"]
        products <- map["num_products"]
        stores <- map["num_stores"]
    }
}
