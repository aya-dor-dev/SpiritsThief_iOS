//
//  OnBoardingChoosCurrencyiewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 28/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class OnBoardingChoosCurrencyiewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var delegate: (String) -> Void = {(_) in}
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.dataSource = self
        picker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.CURRENCIES.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = Constants.CURRENCIES[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        return myTitle
    }
    
    @IBAction func done(_ sender: Any) {
        let currency = Constants.CURRENCIES[picker.selectedRow(inComponent: 0)]
        delegate(currency)
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
