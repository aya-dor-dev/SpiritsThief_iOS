//
//  BaseSearchRequest.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 19/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchRequest: BaseApiRequest {
    var id: [UInt64] = []
    var barcode:String = ""
    var name: String = ""
    var bottler: [String] = []
    var exLiquid: [String] = []
    var caskSize: [String] = []
    var wood: [String] = []
    var refill: [String] = []
    var minPrice: Int = -1
    var maxPrice: Int = -1
    var minABV: Int = -1
    var maxABV: Int = -1
    var minAge: Int = -1
    var maxAge: Int = -1
    var includingNas: Bool = true
    var onlyCaskStrength: Bool = false
    var onlySingleCask: Bool = false
    var minDistillationYear: Int = -1
    var maxDistillationYear: Int = -1
    var minBottlingYear: Int = -1
    var maxBottlingYear: Int = -1
    var limit: Int = 20
    var offset: Int = 0
    var calculateCount: Bool = false
    var allowSoldOut = 0
    
    func filterCount() -> Int {
        var count = 0
        
        if !subcategory.isEmpty { count+=1 }
        if !country.isEmpty { count+=1 }
        if !region.isEmpty { count+=1 }
        if !brand.isEmpty { count+=1 }
        if !bottler.isEmpty { count+=1 }
        if !exLiquid.isEmpty { count+=1 }
        if !caskSize.isEmpty { count+=1 }
        if !wood.isEmpty { count+=1 }
        if !refill.isEmpty { count+=1 }
        if minPrice > -1 || maxPrice > -1 { count+=1 }
        if minABV > -1 || maxABV > -1 { count+=1 }
        if minAge > -1 || maxAge > -1 { count+=1 }
        if minDistillationYear > -1 || maxDistillationYear > -1 { count+=1 }
        if minBottlingYear > -1 || maxBottlingYear > -1 { count+=1 }
        if !includingNas { count+=1 }
        if onlySingleCask { count+=1 }
        if onlyCaskStrength { count+=1 }
        
        return count
    }
    
    func clone() -> SearchRequest {
        var clone = SearchRequest(JSON: self.toJSON())!
        return clone
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["ID"]
        barcode <- map["barcode"]
        name <- map["name"]
        bottler <- map["bottler"]
        exLiquid <- map["ex_liquid"]
        caskSize <- map["casksize"]
        wood <- map["wood"]
        refill <- map["refill"]
        minPrice <- map["minPrice"]
        maxPrice <- map["maxPrice"]
        minABV <- map["minABV"]
        maxABV <- map["maxABV"]
        minAge <- map["minAge"]
        maxAge <- map["maxAge"]
        includingNas <- map["includingNas"]
        onlyCaskStrength <- map["onlyCaskStrength"]
        onlySingleCask <- map["onlySingleCask"]
        minDistillationYear <- map["minDistillationYear"]
        maxDistillationYear <- map["maxDistillationYear"]
        minBottlingYear <- map["minBottlingYear"]
        maxBottlingYear <- map["maxBottlingYear"]
        limit <- map["limit"]
        offset <- map["offset"]
        calculateCount <- map["count_needed"]
        allowSoldOut <- map["allow_null_price"]
    }
    
    func setSort(sort: SORT) {
        switch sort {
        case .NAME_ASC:
            sortBy = "name"
            sortOrder = "ASC"
        case .NAME_DESC:
            sortBy = "name"
            sortOrder = "DESC"
        case .PRICE_ASC:
            sortBy = "price"
            sortOrder = "ASC"
        case .PRICE_DESC:
            sortBy = "price"
            sortOrder = "DESC"
        case .AGE_ASC:
            sortBy = "age"
            sortOrder = "ASC"
        case .AGE_DESC:
            sortBy = "age"
            sortOrder = "DESC"
        }
    }
}

enum SORT {
    case NAME_ASC
    case NAME_DESC
    case PRICE_ASC
    case PRICE_DESC
    case AGE_ASC
    case AGE_DESC
    
    func title() -> String {
        switch self {
        case .NAME_ASC:
            return "A..Z"
        case .NAME_DESC:
            return "Z..A"
        case .PRICE_ASC:
            return "Cheapest"
        case .PRICE_DESC:
            return "Most Expensive"
        case .AGE_ASC:
            return "Youngest"
        case .AGE_DESC:
            return "Oldest"
        }
    }
}
