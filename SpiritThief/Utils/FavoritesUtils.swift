//
//  FavoritesUtils.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 02/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation

class FavoritesListHolder {
    var favorites: [UInt64]
    
    init(list: [UInt64]) {
        self.favorites = list
    }
}

class FavoritesUtils {
    
    private static var holder: FavoritesListHolder? = nil
    
    static func isFavorite(bottleId: UInt64) -> Bool {
        return getFavoriteBottlesIds().favorites.contains(bottleId)
    }
    
    static func getFavoriteBottlesIds() -> FavoritesListHolder {
        if holder == nil {
            var list = UserDefaults.standard.array(forKey: Constants.PREF_FAVORITES) as? [UInt64]
            if list == nil {
                list = [UInt64]()
            }
            
            holder  = FavoritesListHolder(list: list!)
        }
        
        return holder!
    }
    
    static func addOrRemove(bottleId: UInt64) {
        var listHolder = getFavoriteBottlesIds()
        var added = false;
        
        if let itemIndex = listHolder.favorites.index(of: bottleId) {
            listHolder.favorites.remove(at: itemIndex)
            added = false
        } else {
            listHolder.favorites.append(bottleId)
            added = true
        }
        
        AnalyticsManager.userUpdatedWishList(bottleId: bottleId, added: added, wishlistCount: listHolder.favorites.count)
        
        UserDefaults.standard.set(listHolder.favorites, forKey: Constants.PREF_FAVORITES)
    }
}
