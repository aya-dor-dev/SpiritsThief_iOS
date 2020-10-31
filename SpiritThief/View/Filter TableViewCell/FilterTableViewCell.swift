//
//  FilterTableViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 29/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func disable() {
        value.isEnabled = false
        title.isEnabled = false
    }
    func enable() {
        value.isEnabled = true
        title.isEnabled = true
    }
}
