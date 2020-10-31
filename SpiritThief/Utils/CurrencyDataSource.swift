//
//  CurrencyDataSource.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 29/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Foundation

class CurrencyDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
   
    let choices = Constants.CURRENCIES
    var pickerSelectedItem = 0
    var textColor: UIColor = UIColor.black
    
    override init() {
        pickerSelectedItem = choices.index(of: UserDefaults.standard.string(forKey: Constants.PREF_CURRENCY)!)!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = choices[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: textColor])
        
        return myTitle
    }
}
