//
//  ChooseCountryViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 28/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Firebase



class ChooseCountryViewController: UIViewController, UIPickerViewDelegate {
    var delegate: (String) -> Void = {(_) in}
    let dataSource = DeliveryCountryDataSource()
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.textColor = UIColor.white
        picker.dataSource = dataSource
        picker.delegate = dataSource
    }
    
    @IBAction func next(_ sender: Any) {
        let countryCode = dataSource.getCountryCode(forRow: picker.selectedRow(inComponent: 0))
        delegate(countryCode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
