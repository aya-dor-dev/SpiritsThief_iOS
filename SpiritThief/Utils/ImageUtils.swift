//
//  ImageUtils.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 18/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
class ImageUtils {
    static func getFlagEmoji(forCountryCode code:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
