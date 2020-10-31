//
//  Bottle.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class Bottle: Mappable {
    var id: UInt64 = 0
    var region: String? = nil
    var style: String? = nil
    var imageUrl: [String]? = nil
    var distillery: String? = nil
    var bottlingDate: UInt64? = nil
    var bottler: String? = nil
    var series: String? = nil
    var name: String? = nil
    var colouring: String? = nil
    var size: String? = nil
    var barcode: String? = nil
    var caskType: String? = nil
    var exLiquid: [String]? = nil
    var caskSize: [String]? = nil
    var caskWood: [String]? = nil
    var refill: [String]? = nil
    var caskNumber: String?  = nil
    var country: String? = nil
    var vintage: String? = nil
    var age: Int = 0
    var numberOfBottles: String? = nil
    var abv: String? = nil
    var avgPrice: Double? = nil
    var currency: String? = nil
    
    func mapping(map: Map) {
        id <- map["id"]
        region <- map["region"]
        style <- map["style"]
        imageUrl <- map["image_urls"]
        distillery <- map["brand"]
        bottlingDate <- map["bottlingyear"]
        bottler <- map["bottler"]
        series <- map["series"]
        name <- map["name"]
        colouring <- map["colouring"]
        size <- map["size"]
        caskType <- map["casktype"]
        exLiquid <- map["ex_liquid"]
        caskSize <- map["casksize"]
        caskWood <- map["wood"]
        refill <- map["refill"]
        caskNumber <- map["casknumber"]
        country <- map["country"]
        vintage <- map["vintage"]
        age <- map["age"]
        numberOfBottles <- map["nobottles"]
        abv <- map["strength"]
        avgPrice <- map["price"]
        currency <- map["currency"]
    }
    
    required init?(map: Map) {
    }
}
