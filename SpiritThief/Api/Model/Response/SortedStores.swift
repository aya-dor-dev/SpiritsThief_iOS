//
//  SortedStores.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 02/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation

class SortedStores {
    var verified = [Store]()
    var unverified = [Store]()
    var soldOut = [Store]()
    var maxPrice = 0.0
    var minPrice = 0.0
    
    init(stores: [Store]) {
        if (stores.isEmpty) { return }
        
        minPrice = stores.last!.price!
        maxPrice = stores[0].price!
        
        for store in stores {
            if store.valid == 0 {
                soldOut.append(store)
            } else if let lastUpdate = store.lastUpdated {
                if (Int(lastUpdate)! <= Store.LAST_UPDATED_THRESHOLD) {
                    verified.append(store)
                } else {
                    unverified.append(store)
                }
            } else {
                unverified.append(store)
            }
            
            let price = store.price!
            if (price > maxPrice) { maxPrice = price}
            if (price > 0 && price < minPrice) { minPrice = price}
        }
    }
    
    func count() -> Int {
        return verified.count + unverified.count + soldOut.count
    }
}
