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
    var restdays: Int = 8
    
    var tripsByMetroAtWeekday: Int = 1
    var tripsByMetroAtRestday: Int = 1
    
    var commercialAmount: Double = 0.5
    
    init() {}
    
    init(weekdays: Int, restdays: Int, tripsByMetroAtWeekday: Int, tripsByMetroAtRestday: Int) {
        self.weekdays = weekdays
        self.restdays = restdays
        self.tripsByMetroAtWeekday = tripsByMetroAtWeekday
        self.tripsByMetroAtRestday = tripsByMetroAtRestday
    }
    
    private func getMetroAmount() -> Double {
        var amount: Double = 0
        
        let totalTripsByMetro = weekdays * tripsByMetroAtWeekday + restdays * tripsByMetroAtRestday
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
