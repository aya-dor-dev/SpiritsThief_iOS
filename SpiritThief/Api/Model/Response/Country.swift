//
//  Country.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class Country: Mappable {
    var name: String? = nil
    var count: Int = -1
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["country"]
        count <- map["count"]
    }

}
