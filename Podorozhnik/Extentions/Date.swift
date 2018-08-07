//
//  Date.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

extension Date {
    
    static func currentMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        
        let str = dateFormatter.string(from: Date())
        return str
    }
    
}
