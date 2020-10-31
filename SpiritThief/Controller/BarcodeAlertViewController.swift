//
//  BarcodeAlertViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 22/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

protocol BarcodeAlertViewDelegate: class {
    func barcodeAlertView(_ alertView: BarcodeAlertViewController, scan: Bool)
}

class BarcodeAlertViewController: UIViewController {
    var delegate: BarcodeAlertViewDelegate?
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var sureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let borderColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        sureButton.layer.addBorder(edge: .left, color: borderColor, thickness: 1)
        sureButton.layer.addBorder(edge: .top, color: borderColor, thickness: 1)
        notNowButton.layer.addBorder(edge: .top, color: borderColor, thickness: 1)
        
        mainContainer.clipsToBounds = true
        mainContainer.layer.cornerRadius = 15
        imageContainer.layer.cornerRadius = 36
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    @IBAction func notNow(_ sender: Any) {
        delegate?.barcodeAlertView(self, scan: false)
    }
    
    @IBAction func scan(_ sender: Any) {
        delegate?.barcodeAlertView(self, scan: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
