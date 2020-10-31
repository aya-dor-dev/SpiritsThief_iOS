//
//  Slide.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Alamofire

class Slide: UIView {
    
    var url: String = ""
    var bottleId: UInt64 = 0
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func draw(_ rect: CGRect) {
        imageview.load(bottleId: bottleId, imageLink: url)
    }
}
