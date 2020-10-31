//
//  File.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 24/09/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import Firebase

class AnalyticsManager {
    static let EVENT_USER_ADDED_BOTTLE_TO_COLLECTION = "collection_bottle_added"
    static let EVENT_USER_REMOVED_BOTTLE_TO_COLLECTION = "collection_bottle_removed"
    static let EVENT_USER_ADDED_BOTTLE_TO_WISHLIST = "wishlist_bottle_added"
    static let EVENT_USER_REMOVED_BOTTLE_TO_WISHLIST = "wishlist_bottle_removed"
    static let EVENT_SCAN_BARCODE_DIALOG_DISPLAYED = "request_barcode_dialog_displayed"
    static let EVENT_SCAN_BARCODE_USER_AGREED = "request_scan_barcode_user_agreed"
    static let EVENT_SCAN_BARCODE_USER_DECLINED = "request_scan_barcode_user_declined"
    static let EVENT_SCAN_BARCODE_USER_UPDATED_BARCODE = "user_updated_barcode"
    static let EVENT_SEARCH_FREE_TEXT = "search_free_text"
    static let EVENT_SEARCH_APPLY_FILTER = "search_apply_filter"
    static let EVENT_SEARCH_BARCODE_SCAN = "search_scan_barcode"
    static let EVENT_SEARCH_RESULTS_RECEIVED = "search_received_results"
    static let EVENT_BOTTLE_CLICKED = "bottle_clicked"
    static let EVENT_SHARE_BOTTLE = "bottle_shared"
    static let EVENT_STORE_CLICKED = "store_clicked"
    static let EVENT_MORE_STORES_CLICKED = "more_stores_clicked"
    static let EVENT_OPEN_BOTTLE_FROM_SHARED_LINK = "view_bottle_from_shared_link"
    
    static let FIELD_BOTTLE_ID = "bottle_id"
    static let FIELD_STORE_NAME = "store_name"
    static let FIELD_URL = "url"
    static let FIELD_COLLECTION_SIZE = "collection_size"
    static let FIELD_WISHLIST_SIZE = "wishlist_size"
    static let FIELD_AGREE_TO_SCAN = "agree_to_scan"
    static let FIELD_BARCODE = "barcode"
    static let FIELD_SEARCH_QUERY = "search_query"
    static let FIELD_RESULT_COUNT = "results_count"
    
    static func setDeliveryCountry(country: String) {
        Analytics.setUserProperty(country, forName: "delivery_country")
    }
    
    static func setCurrency(country: String) {
        Analytics.setUserProperty(country, forName: "currency")
    }
    
    // MARK: Search Flow
    static func performSearch(searchRequest: SearchRequest) {
        if (searchRequest.barcode.count > 0) {
            searchByBarcodeScan(searchRequest: searchRequest)
        } else {
            searchByFreeText(searchRequest: searchRequest)
        }
    }
    
    static func searchByFreeText(searchRequest: SearchRequest) {
        let eventName = EVENT_SEARCH_FREE_TEXT
        let params = [FIELD_SEARCH_QUERY : searchRequest.toJSONString()] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    static func searchByBarcodeScan(searchRequest: SearchRequest) {
        let eventName = EVENT_SEARCH_BARCODE_SCAN
        let params = [FIELD_SEARCH_QUERY : searchRequest.toJSONString(),
                      FIELD_BARCODE : searchRequest.barcode] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    static func searchApplyFilter(searchRequest: SearchRequest) {
        let eventName = EVENT_SEARCH_APPLY_FILTER
        let params = [FIELD_SEARCH_QUERY : searchRequest.toJSONString()] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    static func searchResultsReceived(searchRequest: SearchRequest, count: Int) {
        let eventName = EVENT_SEARCH_APPLY_FILTER
        let params = [FIELD_SEARCH_QUERY : searchRequest.toJSONString(),
                      FIELD_RESULT_COUNT : count] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    static func bottleClicked(bottleId: UInt64) {
        let eventName = EVENT_BOTTLE_CLICKED
        let params = [FIELD_BOTTLE_ID : bottleId] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    static func bottleShared(bottleId: UInt64) {
        let eventName = EVENT_SHARE_BOTTLE
        let params = [FIELD_BOTTLE_ID : bottleId] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    static func storeClicked(bottleId: UInt64, storeName: String, url: String) {
        let eventName = EVENT_STORE_CLICKED
        let params = [FIELD_BOTTLE_ID : bottleId,
                      FIELD_STORE_NAME: storeName,
                      FIELD_URL : url] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    static func moreStoresClicked(bottleId: UInt64) {
        let eventName = EVENT_MORE_STORES_CLICKED
        let params = [FIELD_BOTTLE_ID : bottleId] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    static func viewBottleFromSharedLink(bottleId: UInt64) {
        let eventName = EVENT_OPEN_BOTTLE_FROM_SHARED_LINK
        let params = [FIELD_BOTTLE_ID : bottleId] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: params)
    }
    
    // MARK: Collection actions
    static func userUpdatedCollection(bottleId: UInt64, added: Bool, collectionCount: Int) {
        let eventName = added ? EVENT_USER_ADDED_BOTTLE_TO_COLLECTION : EVENT_USER_REMOVED_BOTTLE_TO_COLLECTION
        let parameters = [FIELD_BOTTLE_ID: bottleId,
                          FIELD_COLLECTION_SIZE: collectionCount] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: parameters)
    }
    
    // MARK: Wishlist actions
    static func userUpdatedWishList(bottleId: UInt64, added: Bool, wishlistCount: Int) {
        let eventName = added ? EVENT_USER_ADDED_BOTTLE_TO_WISHLIST : EVENT_USER_REMOVED_BOTTLE_TO_WISHLIST
        let parameters = [FIELD_BOTTLE_ID: bottleId,
                          FIELD_WISHLIST_SIZE: wishlistCount] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: parameters)
    }
    
    // MARK: Request User To Update Barcode
    static func scanBarcodeDialogDisplayed(bottleId: UInt64) {
        Analytics.logEvent(EVENT_SCAN_BARCODE_DIALOG_DISPLAYED, parameters: nil)
    }
    
    static func scanBarcodeDialogUserAction(bottleId: UInt64, agreed: Bool) {
        let parameters = [FIELD_BOTTLE_ID: bottleId] as [String : Any]
        let eventName = agreed ? EVENT_SCAN_BARCODE_USER_AGREED : EVENT_SCAN_BARCODE_USER_DECLINED
        Analytics.logEvent(eventName, parameters: parameters)
    }
    
    static func userScanedBarcode(bottleId: UInt64, barcode: String) {
        let eventName = EVENT_SCAN_BARCODE_USER_UPDATED_BARCODE
        let parameters = [FIELD_BOTTLE_ID: bottleId,
                          FIELD_BARCODE : barcode] as [String : Any]
        
        Analytics.logEvent(eventName,
                           parameters: parameters)
    }
}
