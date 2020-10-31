//
//  ImageCollectionViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 29/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Alamofire

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    var imageRequest: DataRequest? = nil
    
    func bind(bottleId: UInt64, imageUrl: String) {
        image.load(bottleId: bottleId, imageLink: imageUrl)
//        imageRequest = Alamofire.request(imageUrl).responseImage { response in
//            if let image = response.result.value {
//                self.image.image = image.af_imageAspectScaled(toFit: self.image.layer.bounds.size)
//            } else {
//                Api.repordInvalidImage(bottleId: bottleId, imageUrl: imageUrl)
//            }
//        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        image.layer.cornerRadius = image.frame.size.width / 2
//        image.clipsToBounds = true
        // Initialization code
    }

}
