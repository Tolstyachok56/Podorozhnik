//
//  Calculator.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class Calculator {
    
    // MARK: - Properties
    
    var weekdays: Int = 22
    var restdays: Int = 8
    
    var tripsByMetroAtWeekday: Int = 0
    var tripsByMetroAtRestday: Int = 0
    
    var tripsByGroundAtWeekday: Int = 0
    var tripsByGroundAtRestday: Int = 0
    
    var commercialAmount: Double = 0.0
    
    // MARK: - Initializing
    
    init() {}
    
    init(weekdays: Int, restdays: Int, tripsByMetroAtWeekday: Int, tripsByMetroAtRestday: Int, tripsByGroundAtWeekday: Int, tripsByGroundAtRestday: Int, commercialAmount: Double) {
        self.weekdays = weekdays
        self.restdays = restdays
        
        self.tripsByMetroAtWeekday = tripsByMetroAtWeekday
        self.tripsByMetroAtRestday = tripsByMetroAtRestday
        
        self.tripsByGroundAtWeekday = tripsByGroundAtWeekday
        self.tripsByGroundAtRestday = tripsByGroundAtRestday
        
        self.commercialAmount = commercialAmount
    }
    
    // MARK: - Methods
    
    func getAmount() -> Double {
        return getMetroAmount() + getGroundAmount() + commercialAmount
    }
    
    func getRoundedAmount() -> Int {
        let roundedAmount = Double(Int(getAmount())) < getAmount() ? Int(getAmount()) + 1 : Int(getAmount())
        return roundedAmount
    }
    
    private func getMetroAmount() -> Double {
        var amount: Double = 0
        
        let totalTripsByMetro = weekdays * tripsByMetroAtWeekday + restdays * tripsByMetroAtRestday
        if totalTripsByMetro != 0 {
            for numberOfTrip in 1...totalTripsByMetro  {
                amount += Tariff.metro(numberOfTrip: numberOfTrip)
            }
        }
        return amount
    }
    
    private func getGroundAmount() -> Double {
        var amount: Double = 0
        
        let totalTripsByGround = weekdays * tripsByGroundAtWeekday + restdays * tripsByGroundAtRestday
        if totalTripsByGround != 0 {
            for numberOfTrip in 1...totalTripsByGround  {
                amount += Tariff.ground(numberOfTrip: numberOfTrip)
            }
        }
        return amount
    }
    
}
