//
//  MissingBarcode.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 27/09/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class MissingBarcode: Mappable {
    var items: [Item]? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}

class Item: Mappable {
    var title: String? = nil
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
    }
}
