//
//  ShopStatTableViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 18/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class ShopStatTableViewCell: UITableViewCell {

    @IBOutlet weak var uiStoreName: UILabel!
    @IBOutlet weak var uiLinksCount: UILabel!
    @IBOutlet weak var uiFlagIcon: UILabel!
    @IBOutlet weak var iconAspect: NSLayoutConstraint!
    
    func bind(storeName: String, countryCode: String, links: Int){
        uiFlagIcon.text = ""
        uiStoreName.text = storeName
        uiLinksCount.text = String(links)
        
        if (!countryCode.isEmpty) {
            uiFlagIcon.isHidden = false
            uiFlagIcon.text = ImageUtils.getFlagEmoji(forCountryCode: countryCode)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
