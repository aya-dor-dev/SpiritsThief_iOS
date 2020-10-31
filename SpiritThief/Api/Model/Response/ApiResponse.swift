//
//  Response.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiResponse<T: Mappable>: Mappable {
    var meta: Meta? = nil
    var results: [T]? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        meta <- map["meta"]
        results <- map["results"]
    }
}

class Meta: Mappable {
    var count: Int = -1
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        count <- map["count"]
    }
}
