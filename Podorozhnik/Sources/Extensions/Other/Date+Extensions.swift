//
//  Date.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

extension Date {
    
    var monthFormatting: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        return dateFormatter.string(from: self)
    }
    
    var dayFormatting: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    var dayTimeFormatting: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var mediumFormatting: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: self)
    }
    
    var startOfDay: Date {
        return Calendar(identifier: .gregorian).startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        let components = Calendar(identifier: .gregorian).dateComponents([.year, .month], from: self.startOfDay)
        return Calendar(identifier: .gregorian).date(from: components)!
    }
    
    var endOfMonth: Date {
        return self.startOfNextMonth.add(days: -1)
    }
    
    var startOfNextMonth: Date {
        let dayInAMonth = Calendar(identifier: .gregorian).date(byAdding: .month, value: 1, to: self.startOfDay)
        return (dayInAMonth?.startOfMonth)!
    }
    
    var dayOfWeek: Int {
        return Calendar(identifier: .gregorian).component(.weekday, from: self.startOfDay)
    }
    
    func add(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self.startOfDay)!
    }
}
