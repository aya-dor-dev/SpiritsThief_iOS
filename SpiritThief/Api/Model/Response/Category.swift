//
//  Category.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class Category: Mappable {
    var name: String? = nil
    var subcategories: [String]? = nil
    var iconName: String? = nil
    var width: CGFloat = 0.0
    
    init(name: String, iconName: String?, width: CGFloat) {
        self.name = name
        self.iconName = iconName
        self.width = width
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["category"]
        subcategories <- map["subcategory"]
    }
    
}
