//
//  String+RublesFormatting.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 21/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

extension String {
    
    fileprivate var rublesFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var rublesFormatting: String? {
        guard let double = self.double else { return nil }
        let formatter = self.rublesFormatter
        formatter.groupingSeparator = ""
        return formatter.string(from: NSNumber(value: double))!
    }
    
    var rublesGroupedFormatting: String? {
        guard let double = self.double else { return nil }
        let formatter = self.rublesFormatter
        formatter.groupingSeparator = Locale.current.groupingSeparator ?? " "
        return formatter.string(from: NSNumber(value: double))!
    }
    
    var double: Double? {
        let string = self.replacingOccurrences(of: Locale.current.groupingSeparator ?? " ", with: "")
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        if let result = formatter.number(from: string) {
            print(result.doubleValue)
            return result.doubleValue
        } else {
            formatter.decimalSeparator = ","
            return formatter.number(from: string)?.doubleValue
        }
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
