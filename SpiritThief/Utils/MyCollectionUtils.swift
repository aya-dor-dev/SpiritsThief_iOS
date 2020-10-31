//
//  MyCollectionUtils.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 17/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation

class CollectionListHolder {
    var collected: [UInt64]
    
    init(list: [UInt64]) {
        self.collected = list
    }
}

class MyCollecyionUtils {
    
    private static var holder: CollectionListHolder? = nil
    
    static func isCollected(bottleId: UInt64) -> Bool {
        return getCollectionBottlesIds().collected.contains(bottleId)
    }
    
    static func getCollectionBottlesIds() -> CollectionListHolder {
        if holder == nil {
            var list = UserDefaults.standard.array(forKey: Constants.PREF_COLLECTION) as? [UInt64]
            if list == nil {
                list = [UInt64]()
            }
            
            holder  = CollectionListHolder(list: list!)
        }
        
        return holder!
    }
    
    static func addOrRemove(bottleId: UInt64) -> Bool {
        var added = false
        var listHolder = getCollectionBottlesIds()
        
        if let itemIndex = listHolder.collected.index(of: bottleId) {
            listHolder.collected.remove(at: itemIndex)
        } else {
            listHolder.collected.append(bottleId)
            added = true
        }
        
        AnalyticsManager.userUpdatedCollection(bottleId: bottleId, added: added, collectionCount: listHolder.collected.count)
        UserDefaults.standard.set(listHolder.collected, forKey: Constants.PREF_COLLECTION)
        return added
    }
}
