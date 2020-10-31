//
//  Bottler.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class Bottler: Mappable {
    var name: String = ""
    var imageUrl: String? = nil
    var country: String? = nil
    var region: String? = nil
    
    func mapping(map: Map) {
        name <- map["bottler"]
        imageUrl <- map["image_url"]
        country <- map["country"]
        region <- map["region"]
    }
    
    required init?(map: Map) {}
    
}
