//
//  BaseApiRequest.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 19/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseApiRequest: Mappable {
    
    var sortBy: String = ""
    var sortOrder: String = "ASC"
    var category: [String] = ["Whisky"]
    var subcategory: [String] = []
    var country: [String] = []
    var region: [String] = []
    var brand: [String] = []
    var currency: String = ""
    var deliveryCountry: [String] = []
    
    init() {
        if let currency = UserDefaults.standard.string(forKey: Constants.PREF_CURRENCY) {
            self.currency = currency
        }
        if let deliveryCountry = UserDefaults.standard.string(forKey: Constants.PREF_COUNTRY) {
            self.deliveryCountry.removeAll()
            if !deliveryCountry.isEmpty {
                self.deliveryCountry.append(deliveryCountry)
            }
        }
    }
    
    required init?(map: Map) {
    }
    
    
    func setDeliveryCountry() {
//        if let deliveryCountry = UserDefaults.standard.string(forKey: Constants.PREF_COUNTRY) {
//            self.deliveryCountry.removeAll()
//            if !deliveryCountry.isEmpty {
//                self.deliveryCountry.append(deliveryCountry)
//            }
//        }
//
//        if let currency = UserDefaults.standard.string(forKey: Constants.PREF_CURRENCY) {
//            if !currency.isEmpty {
//                self.currency.removeAll()
//                self.currency.append(currency)
//            }
//        }
    }
    
    func mapping(map: Map) {
        sortBy <- map["sort"]
        sortOrder <- map["sort_order"]
        category <- map["category"]
        subcategory <- map["subcategory"]
        country <- map["country"]
        region <- map["region"]
        brand <- map["brand"]
        currency <- map["currency"]
        deliveryCountry <- map["delivery_country"]
    }
}
