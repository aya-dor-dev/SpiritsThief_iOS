//
//  Constants.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 28/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation

class Constants {
    static let CURRENCIES = ["EUR", "GBP", "USD"]
    static let PREF_COUNTRY = "country"
    static let PREF_CURRENCY = "currency"
    static let PREF_FAVORITES = "favorites"
    static let PREF_COLLECTION = "collection"
    
    
    static func getCurrencySymbol() -> String {
        switch UserDefaults.standard.string(forKey: PREF_CURRENCY) {
        case "EUR":
            return "€"
        case "USD":
            return "$"
        case "GBP":
            return "£"
        default:
            return ""
        }
        
    }
}
