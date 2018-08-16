//
//  Calculator.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

enum DayOfWeek {
    case weekday
    case restday
}

class Calculator {
    
    // MARK: - Properties
    
    var calculatingDays: Int = 30
    
    var tripsByMetroAtWeekday: Int = 2
    var tripsByMetroAtRestday: Int = 0
    
    var tripsByGroundAtWeekday: Int = 2
    var tripsByGroundAtRestday: Int = 0
    
    var commercialAmount: Double = 0.0
    
    // MARK: -
    
    var card: Card?
    
    // MARK: - Methods
    
    func getTotalAmount() -> Double {
        return getAmount(transport: .metro) + getAmount(transport: .ground) + commercialAmount
    }
    
    func getRoundedTotalAmount() -> Int {
        let roundedTotalAmount = Double(Int(getTotalAmount())) < getTotalAmount() ? Int(getTotalAmount()) + 1 : Int(getTotalAmount())
        return roundedTotalAmount
    }
    
    private func getAmount(transport: Transport) -> Double {
        var amount: Double = 0
        
        let today = Date()
        var startOfNextMonth = today.startOfNextMonth()
        
        let currentNumberOfTrips: Int
        let tripsAtWeekday: Int
        let tripsAtRestday: Int
        
        switch transport {
        case .metro:
            currentNumberOfTrips = (card?.trips(by: .metro))!
            tripsAtWeekday = tripsByMetroAtWeekday
            tripsAtRestday = tripsByMetroAtRestday
        case .ground:
            currentNumberOfTrips = (card?.trips(by: .ground))!
            tripsAtWeekday = tripsByGroundAtWeekday
            tripsAtRestday = tripsByGroundAtRestday
        default:
            fatalError("Unexpected type of transport")
        }
        
        if calculatingDays > 0 {
            var numberOfTripsInAMonth = currentNumberOfTrips
            
            for numberOfDay in 1...calculatingDays {
                let day = today.add(days: numberOfDay) // counting of days begins tommorow
                let dayOfWeek = day.dayOfWeek()
                let trips: Int
                
                switch dayOfWeek {
                case 2...6:
                    trips = tripsAtWeekday
                case 1, 7:
                    trips = tripsAtRestday
                default:
                    fatalError("Unexpected day of week")
                }
                
                if trips > 0 {
                    if day < startOfNextMonth {
                        for _ in 1...trips {
                            numberOfTripsInAMonth += 1
                            amount += transport.getTariff(numberOfTrip: numberOfTripsInAMonth)!
                        }
                    } else {
                        numberOfTripsInAMonth = 1
                        startOfNextMonth = startOfNextMonth.startOfNextMonth()
                        amount += transport.getTariff(numberOfTrip: numberOfTripsInAMonth)!
                    }
                }
            }
        }
        
        return amount
    }
    
}
