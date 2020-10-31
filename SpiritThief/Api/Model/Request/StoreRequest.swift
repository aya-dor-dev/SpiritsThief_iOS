//
//  StoreRequest.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreRequest: BaseApiRequest {
    var productId: UInt64 = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        productId <- map["product_id"]
    }
    
}
