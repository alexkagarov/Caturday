//
//  Extensions.swift
//  Caturday
//
//  Created by Cryptoshell on 21.05.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import Foundation

extension String {
    func ISO2EmojiRepresentation(_ countryCodeISO2: String) -> String {
        let base: UInt32 = 127397
        
        var s = ""
        
        for v in countryCodeISO2.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        
        return s
    }
}
