//
//  Calculator.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class Calculator {
    var weekdays: Int = 22
    var restDays: Int = 8
    
    var tripsByMetroAtWeekday: Int = 1
    var tripsByMetroAtRestDay: Int = 1
    
    var commercialAmount: Double = 0
    
    init() {}
    
    init(workDays: Int, restDays: Int, tripsByMetroAtWeekday: Int, tripsByMetroAtRestDay: Int) {
        self.weekdays = workDays
        self.restDays = restDays
        self.tripsByMetroAtWeekday = tripsByMetroAtWeekday
        self.tripsByMetroAtRestDay = tripsByMetroAtRestDay
    }
    
    private func getMetroAmount() -> Double {
        var amount: Double = 0
        
        let totalTripsByMetro = weekdays * tripsByMetroAtWeekday + restDays * tripsByMetroAtRestDay
        if totalTripsByMetro != 0 {
            for numberOfTrip in 1...totalTripsByMetro  {
                amount += Fare.metro(numberOfTrip: numberOfTrip)
            }
        }
        return amount
    }
    
    func getAmount() -> Double {
        return getMetroAmount() + commercialAmount
    }
}
