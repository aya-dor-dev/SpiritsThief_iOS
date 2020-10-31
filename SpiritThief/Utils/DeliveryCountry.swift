//
//  Utils.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 21/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import UIKit

fileprivate let specialCountryCodes = ["FR", "GB", "US", "CA", "DE", "NL", "SP", "JP", "IT", "BE"]

class DeliveryCountryDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let DIVIDER = "--------"
    var countries = [String: String]()
    var countriesNames = [String]()
    var textColor: UIColor = UIColor.black
    
    override init() {
        super.init()
        let options = getOptions()
        
        countries["Any"] = ""
        countriesNames.append("Any")
        countriesNames.append(DIVIDER)
        options.special.forEach { (dc) in
            countriesNames.append(dc.name)
            countries[dc.name] = dc.code
        }
        countriesNames.append(DIVIDER)
        options.other.forEach { (dc) in
            countriesNames.append(dc.name)
            countries[dc.name] = dc.code
        }
    }
    
    func getCountryCode(forRow: Int) -> String {
        return countries[countriesNames[forRow]]!
    }

    func getOptions() -> (special: [DeliveryCountry], other: [DeliveryCountry]){
        var specialCountries = [DeliveryCountry]()
        var countries = [DeliveryCountry]()
        
        for code in NSLocale.isoCountryCodes as [String] {
            var code = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: code) ?? "Country not found for code: \(code)"
            code.removeFirst()
            let dc = DeliveryCountry(name: name, code: code)
            if (specialCountryCodes.contains(code)) {
                specialCountries.append(dc)
            } else {
                countries.append(dc)
            }
        }
        
        specialCountries.sort { (a, b) -> Bool in
            a.name < b.name
        }
        
        countries.sort { (a, b) -> Bool in
            a.name < b.name
        }
        
        return (specialCountries, countries)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countriesNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = countriesNames[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: textColor])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (countriesNames[row] == DIVIDER) {
            pickerView.selectRow(row - 1, inComponent: 0, animated: true)
        }
    }
}

class DeliveryCountry {
    let name: String
    let code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}
