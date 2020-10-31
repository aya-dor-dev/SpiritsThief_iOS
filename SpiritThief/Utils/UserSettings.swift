//
//  UserSettings.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 07/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation

class UserSettings {
    
    static func getDeliveryCountryName() -> String {
        let countryCode = UserDefaults.standard.string(forKey: Constants.PREF_COUNTRY)
        
        return getCountryName(for: countryCode)
    }
    
    static func getCountryName(for cc: String?) -> String {
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            if code == cc {
                return name
            }
        }
        
        return "Any"
    }
}
