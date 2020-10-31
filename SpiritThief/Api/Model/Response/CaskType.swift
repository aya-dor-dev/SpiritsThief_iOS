//
//  CaskType.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class CaskType: Mappable {
    var exLiquid: [String]? = nil
    var caskSize: [String]? = nil
    var wood: [String]? = nil
    var refill: [String]? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        exLiquid <- map["ex_liquid"]
        caskSize <- map["casksize"]
        wood <- map["wood"]
        refill <- map["refill"]
    }
    
}
