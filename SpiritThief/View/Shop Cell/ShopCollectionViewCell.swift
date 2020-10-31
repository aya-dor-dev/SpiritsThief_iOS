//
//  ShopCollectionViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 24/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Alamofire

class ShopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storeIcon: UIImageView!
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var verifiedIcon: UIImageView!
    @IBOutlet weak var soldout: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        soldout.rotate(angle: -30)
    }
    
    func bind(store: Store) {
        self.viewWithTag(3)?.removeFromSuperview()
        storeIcon.image = nil
        flagLabel.text = ImageUtils.getFlagEmoji(forCountryCode: store.countryCode)
        if let price = store.price, let currency = store.currency {
            self.price.text = currency + String(price)
        }
        storeName.text = store.name!
        
        if (store.valid == 1) {
            if let lastUpdated = store.lastUpdated {
                if Int(lastUpdated)! > Store.LAST_UPDATED_THRESHOLD {
                    verifiedIcon.image = UIImage(named: "unverified")
                } else {
                    verifiedIcon.image = UIImage(named: "verified")
                }
            } else {
                verifiedIcon.image = UIImage(named: "unverified")
            }
        } else {
            verifiedIcon.image = UIImage(named: "sold_out")
        }
        
        if let imageUrl = store.imageUrl {
            storeIcon.load(bottleId: 0, imageLink: imageUrl)
//            Alamofire.request(imageUrl).responseImage { response in
//                let size = CGSize(width: 88, height: 62)
//                if let image = response.result.value {
//                    self.storeIcon.image = image.af_imageAspectScaled(toFit: size)
//                } else if let image = response.data {
//                    if let uiImage = UIImage(data: image) {
//                        self.storeIcon.image = uiImage.af_imageAspectScaled(toFit: size)
//                    }
//                } else {
//                    self.storeIcon.image = UIImage(named: "store")
//                }
//            }
        } else {
            storeIcon.image = UIImage(named: "store")
        }
        
        soldOut(store.valid == 0)
    }
    
    func soldOut(_ so: Bool) {
        if (so) {
            soldout.layer.borderWidth = 2
            soldout.layer.borderColor = soldout.textColor.cgColor
            soldout.isHidden = false
            verifiedIcon.isHidden = true
        } else {
            soldout.isHidden = true
            verifiedIcon.isHidden = false
        }
    }
    
}
