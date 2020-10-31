//
//  ShopMoreCollectionViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 02/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class ShopMoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(count: Int, lowestPrice: Double) {
        countLabel.text = "\(count) More (from \(lowestPrice))"
    }
}
