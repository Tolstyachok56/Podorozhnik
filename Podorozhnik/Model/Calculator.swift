//
//  Calculator.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 27.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

enum DayOfWeek {
    case weekday
    case restday
}

class Calculator {
    
    // MARK: - Properties
    
    var startDate: Date = Date()
    var endDate: Date!
    
    var tripsByMetroAtWeekday: Int = 0
    var tripsByMetroAtRestday: Int = 0
    
    var tripsByGroundAtWeekday: Int = 0
    var tripsByGroundAtRestday: Int = 0
    
    var commercialAmount: Double = 0.0
    
    var calculatingDays: Int {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)
        
        return Calendar.current.dateComponents([.day], from: start, to: end).day! + 1
    }
    
    // MARK: -
    
    var card: Card?
    
    init() {
        self.endDate = Date().endOfMonth()
    }
    
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
        
        var currentNumberOfTrips: Int
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
            for numberOfDay in 1...calculatingDays {
                let day = startDate.add(days: numberOfDay - 1)
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
                    if day >= startOfNextMonth {
                        currentNumberOfTrips = 0
                        startOfNextMonth = startOfNextMonth.startOfNextMonth()
                    }
                    
                    for _ in 1...trips {
                        currentNumberOfTrips += 1
                        amount += transport.getTariff(numberOfTrip: currentNumberOfTrips)!
                    }
                }
            }
        }
        
        return amount
    }
    
}
