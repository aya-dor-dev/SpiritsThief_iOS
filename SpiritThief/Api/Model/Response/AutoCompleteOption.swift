//
//  AutoCompleteOption.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class AutoCompleteOption: Mappable {
    var name: String = ""
    var type: Int = -1
    var category: String = ""
    
    func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
        category <- map["category"]
    }
    
    required init?(map: Map) {
    }
    
}
