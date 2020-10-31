//
//  ShopTableViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 03/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var storeFlagLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
