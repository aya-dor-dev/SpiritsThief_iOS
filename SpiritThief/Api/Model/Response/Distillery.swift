//
//  Distillery.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class Distillery: Mappable {
    var name: String? = nil
    var imageUrl: String? = nil
    var country: String? = nil
    var region: String? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["brand"]
        imageUrl <- map["image_url"]
        country <- map["country"]
        region <- map["region"]
    }
    
}
