//
//  OnBoardingProductAvailability.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 13/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class OnBoardingProductAvailability: UIViewController {
    var delegate: (String) -> Void = {(_) in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        delegate("")
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
