//
//  SimpleLableTableViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 28/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class SimpleLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
