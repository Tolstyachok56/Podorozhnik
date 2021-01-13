//
//  Double+RublesFormattting.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 20/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

extension Double {
    
    var rublesGroupedFormatting: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: self))!
    }
    
}
