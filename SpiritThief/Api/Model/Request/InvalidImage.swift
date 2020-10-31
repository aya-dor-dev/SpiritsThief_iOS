//
//  InvalidImage.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 13/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class InvalidImage: Mappable {
    var id: String = ""
    var url: String = ""
    
    init(bottleId: String, imageUrl: String) {
        id = bottleId
        url = imageUrl
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["ID"]
        url <- map["url"]
    }
}
