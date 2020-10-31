//
//  CategoryCollectionViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 24/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        container.layer.cornerRadius = 12
    }
    
    func bind(text: String, iconName: String?, selected: Bool) {
        icon.image = nil
        if iconName != nil {
            let catIcon = UIImage(named: iconName!)!.withRenderingMode(.alwaysTemplate)
            icon.image = catIcon
            icon.tintColor = selected ? UIColor(hexString: "#ffffff") : UIColor(hexString: "#7a7a7a")
        }
        
        label.text = text
        container.backgroundColor = selected ? UIColor(hexString: "#303952") : UIColor(hexString: "#ffffff")
        label.textColor = selected ? UIColor(hexString: "#ffffff") : UIColor(hexString: "#7a7a7a")
        label.font = UIFont(name: selected ? "HelveticaNeue-Bold" : "HelveticaNeue-Thin" , size: 18.0)
        
    }
}

extension CategoryCollectionViewCell {
    static func width(text: String) -> CGFloat {
        return CGFloat(46.0 + CGFloat(text.count) *  14.0)
    }
}
