//
//  FilterRangeViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 01/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

enum RangeType {
    case YEAR
    case PRICE
    case ABV
    case AGE
}

class FilterRangeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var rangeDelegate: (Int, Int) -> Void = {(_, _) in}
    
    var min = 0
    var max = 0
    var pickerData = [[String]]()
    var rangeType: RangeType = .YEAR
    
    @IBOutlet weak var rangePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangePicker.dataSource = self
        rangePicker.delegate = self
        
        switch rangeType {
        case .PRICE:
            var prices = [String]()
            
            prices.append("Any")
            for i in 1...100 {
                prices.append(String(i * 10))
            }
            
            for i in 11...1000 {
                prices.append(String(i * 100))
            }
            
            pickerData.append(prices)
            pickerData.append(prices)
            break
        case .YEAR:
            var years = [String]()
            let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
            
            years.append("Any")
            for i in 1920...currentYearInt {
                years.append(String(i))
            }
            
            pickerData.append(years)
            pickerData.append(years)
            break
        case.ABV:
            var abvs = [String]()
            
            abvs.append("Any")
            for i in 12...98 {
                abvs.append(String(i))
            }
            
            pickerData.append(abvs)
            pickerData.append(abvs)
            break
        case .AGE:
            var ages = [String]()
            let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
            let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
            ages.append("Any")
            for i in 0...currentYearInt - 1920 {
                ages.append(String(i))
            }
            
            pickerData.append(ages)
            pickerData.append(ages)
            break
        default:
            break
        }
        
        var selectedMin = 0
        var selectedMax = 0
        
        if (min > -1) {
            selectedMin = pickerData[0].index(of: String(min))!
        }
        if (max > -1) {
            selectedMax = pickerData[1].index(of: String(max))!
        }
        
        rangePicker.selectRow(selectedMin, inComponent: 0, animated: false)
        rangePicker.selectRow(selectedMax, inComponent: 1, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var suffix = ""
        if (row > 0) {
            switch rangeType {
            case .ABV:
                suffix = "%"
                break
            case .AGE:
                suffix = "yo"
                break
            default:
                break
            }
        }
        let prefix = (rangeType == .PRICE && row > 0) ? Constants.getCurrencySymbol() : ""
        return prefix + pickerData[component][row] + suffix
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(120.0)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            if (row != 0 && row > pickerView.selectedRow(inComponent: 1) && pickerView.selectedRow(inComponent: 1) != 0) {
                pickerView.selectRow(row, inComponent: 1, animated: true)
            }
        } else {
            if (row != 0 && row < pickerView.selectedRow(inComponent: 0) && pickerView.selectedRow(inComponent: 0) != 0) {
                pickerView.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }
    
    func getSelection() -> (min: Int, max: Int) {
        let min = rangePicker.selectedRow(inComponent: 0) == 0 ? -1 : Int(pickerData[0][rangePicker.selectedRow(inComponent: 0)])!
        let max = rangePicker.selectedRow(inComponent: 1) == 0 ? -1 : Int(pickerData[0][rangePicker.selectedRow(inComponent: 1)])!
        return (min, max)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
