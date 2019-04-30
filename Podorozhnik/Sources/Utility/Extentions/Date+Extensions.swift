//
//  Date.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

extension Date {
    
    func currentMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        let str = dateFormatter.string(from: self)
        return str
    }
    
    func startOfDay() -> Date {
        return Calendar(identifier: .gregorian).startOfDay(for: self)
    }
    
    func add(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self.startOfDay())!
    }
    
    func startOfMonth() -> Date {
        let components = Calendar(identifier: .gregorian).dateComponents([.year, .month], from: self.startOfDay())
        return Calendar(identifier: .gregorian).date(from: components)!
    }
    
    func endOfMonth() -> Date {
        return self.startOfNextMonth().add(days: -1)
    }
    
    func startOfNextMonth() -> Date {
        let dayInAMonth = Calendar(identifier: .gregorian).date(byAdding: .month, value: 1, to: self.startOfDay())
        return (dayInAMonth?.startOfMonth())!
    }
    
    func dayOfWeek() -> Int {
        return Calendar(identifier: .gregorian).component(.weekday, from: self.startOfDay())
    }
    
    func mediumFormat() -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: self)
    }
    
}
