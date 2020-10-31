//
//  StoresTableViewCell.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 29/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
public protocol StoresTableViewCellDelegate {
    func openStoreUrl(urlToOpen: String)
    func viewMoreStores()
}

class StoresTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    var delegate: StoresTableViewCellDelegate? = nil
    var sortedStores = SortedStores(stores: [Store]())
    var stores = [Store]()
    var bottleId: UInt64? = nil
    
    @IBOutlet weak var storeCollectionView: UICollectionView!
    @IBOutlet weak var availabilityIcon: UIImageView!
    @IBOutlet weak var availabilityMessage: UILabel!
    
    func bind(stores: SortedStores) {
        self.sortedStores = stores
        
        if (stores.verified.count > 0) {
            self.stores = stores.verified
            availabilityIcon.image = UIImage(named: "verified")
            availabilityMessage.text = "Item seen in stock in the past 7 days; Price exc. Tax"
        } else if (stores.unverified.count > 0) {
            self.stores = stores.unverified
            availabilityIcon.image = UIImage(named: "unverified")
            availabilityMessage.text = "Store has not been scanned in the past 7 days"
        } else {
            self.stores = stores.unverified
            availabilityIcon.image = UIImage(named: "sold_out")
            availabilityMessage.text = "Item sold out"
        }
        self.storeCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (sortedStores.count() - stores.count > 0) {
            return stores.count + 1
        } else {
            return stores.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row < stores.count) {
            let cell = storeCollectionView.dequeueReusableCell(withReuseIdentifier: "storeCell",
                                                                for: indexPath) as! ShopCollectionViewCell
            
            cell.bind(store: stores[indexPath.row])
            return cell
        } else {
            let cell = storeCollectionView.dequeueReusableCell(withReuseIdentifier: "moreCell",
                                                               for: indexPath) as! ShopMoreCollectionViewCell
            
            cell.bind(count: sortedStores.count() - sortedStores.verified.count,
                      lowestPrice: sortedStores.minPrice)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110.0, height: 120.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row < stores.count) {
            let store = stores[indexPath.row]
            AnalyticsManager.storeClicked(bottleId: bottleId!, storeName: store.name!, url: store.url!)
            delegate?.openStoreUrl(urlToOpen: store.url!)
        } else {
            AnalyticsManager.moreStoresClicked(bottleId: bottleId!)
            delegate?.viewMoreStores()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        storeCollectionView.register(UINib(nibName: "ShopCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "storeCell")
        storeCollectionView.register(UINib(nibName: "ShopMoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "moreCell")
        storeCollectionView.delegate = self
        storeCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
