//
//  CollectionViewBottleCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 16/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Alamofire

class CollectionViewBottleCell: UICollectionViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var bottleImage: UIImageView!
    @IBOutlet weak var bottleNameLabel: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    
    var imageRequest: DataRequest? = nil
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
//        labelContainer.roundCorners(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: 5.0)
        container.clipsToBounds = true
        container.layer.cornerRadius = 5
        container.layer.borderColor = UIColor(hexString: "#596275").cgColor
        container.layer.borderWidth = 1
        
//        container.layer.shadowColor = UIColor.black.cgColor
//        container.layer.shadowOffset = CGSize(width: 2, height: 2)
//        container.layer.shadowOpacity = 0.7
//        container.layer.shadowRadius = 5.0
    }

    func bind(bottle: Bottle) {
        imageRequest?.cancel()
        self.bottleImage.image = UIImage(named: "bottle image place holder")
        if let images = bottle.imageUrl {
            if !images.isEmpty {
                bottleImage.load(bottleId: bottle.id, imageLink: images[0])
            }
        }
        
        bottleNameLabel.text = bottle.name
        container.bringSubview(toFront: bottleNameLabel)
    }
}
