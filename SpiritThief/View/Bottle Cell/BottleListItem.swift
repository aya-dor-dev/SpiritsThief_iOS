//
//  BottleListItem.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 22/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Alamofire

class BottleListItem: UITableViewCell {
    
    var imageRequest: DataRequest? = nil
    
    @IBOutlet weak var bottleImage: UIImageView!
    @IBOutlet weak var bottleName: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var bottlerLabel: UILabel!
    @IBOutlet weak var caskLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var abv: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var favotiteIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bind(bottle: Bottle) {
        clear()
        
        if FavoritesUtils.isFavorite(bottleId: bottle.id) {
            favotiteIcon.isHidden = false
        }
        
        bottleName.text = bottle.name?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let style = bottle.style {
            styleLabel.text = style.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let bottler = bottle.bottler {
            bottlerLabel.text = bottler.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            bottlerLabel.text = "N/a"
        }
        
        if let price = bottle.avgPrice, let currency = bottle.currency {
            priceLabel.text = currency + String(price)
        } else {
            priceLabel.text = "N/a"
        }
        
        if let abvval = bottle.abv {
            abv.text = abvval.trimmingCharacters(in: .whitespacesAndNewlines) + "%"
        }
        
        if bottle.age > 0 {
            age.text = "\(bottle.age)YO"
        } else {
            age.text = "NAS"
        }
        
        if let btlSize = bottle.size {
            size.text = btlSize.trimmingCharacters(in: .whitespacesAndNewlines) + "cl"
        }
        
        var cask = ""
        if bottle.caskType != nil && !bottle.caskType!.isEmpty {
            cask += bottle.caskType!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if bottle.caskNumber != nil && !bottle.caskNumber!.isEmpty {
            cask += " " + bottle.caskNumber!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if !cask.isEmpty {
            caskLabel.text = "Cask: " + cask.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            caskLabel.text = "N/a"
        }
        
        if let images = bottle.imageUrl {
            if !images.isEmpty {
                self.bottleImage.load(bottleId: bottle.id, imageLink: images[0], placeHolder: UIImage(named: "bottle image place holder"))
            } else {
                bottleImage.image = UIImage(named: "bottle image place holder")
            }
        }
    }
    
    private func clear() {
        imageRequest?.cancel()
        bottleImage.image = nil
        bottleName.text = "";
        styleLabel.text = "";
        bottlerLabel.text = ""
        caskLabel.text = "";
        priceLabel.text = "";
        abv.text = "";
        age.text = "";
        size.text = "";
        favotiteIcon.isHidden = true
    }
}
