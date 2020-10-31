//
//  FilterOptionTableViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 30/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class FilterOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
}
