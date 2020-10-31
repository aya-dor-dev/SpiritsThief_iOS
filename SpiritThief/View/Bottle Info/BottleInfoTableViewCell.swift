//
//  BottleInfoTableViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 24/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class BottleInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(title: String, value: String) {
        self.title.text = title + ":"
        self.value.text = value
    }
}
