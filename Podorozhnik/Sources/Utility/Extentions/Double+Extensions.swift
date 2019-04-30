//
//  Double.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 27.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

extension Double {
    
    func priceFormat() -> String? {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 1
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf.string(from: self as NSNumber)
    }
    
}
