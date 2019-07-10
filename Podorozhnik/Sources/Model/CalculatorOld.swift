//
//  CalculatorOld.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 27.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class CalculatorOld {
    
    // MARK: - Properties
    var startDate: Date = Date()
    var endDate: Date!
    
    var tripsByMetroAtWeekday: Int = 0
    var tripsByMetroAtRestday: Int = 0
    
    var tripsByGroundAtWeekday: Int = 0
    var tripsByGroundAtRestday: Int = 0
    
    var commercialAmount: Double = 0.0
    
    var calculatingDays: Int {
        return Calendar.current.dateComponents([.day], from: self.startDate.startOfDay, to: self.endDate.startOfDay).day! + 1
    }
    var card: Card?
    
    // MARK: - Initializing
    init() {
        self.endDate = Date().endOfMonth
    }
    
    // MARK: - Methods
    func getTotalAmount() -> Double {
        return self.getAmount(transport: .metro) + self.getAmount(transport: .ground) + self.commercialAmount
    }
    
    private func getAmount(transport: Transport) -> Double {
        var amount: Double = 0
        
        let today = Date()
        var startOfNextMonth = today.startOfNextMonth
        
        var currentNumberOfTrips: Int
        let tripsAtWeekday: Int
        let tripsAtRestday: Int
        
        switch transport {
        case .metro:
            currentNumberOfTrips = (card?.trips(by: .metro))!
            tripsAtWeekday = self.tripsByMetroAtWeekday
            tripsAtRestday = self.tripsByMetroAtRestday
        case .ground:
            currentNumberOfTrips = (card?.trips(by: .ground))!
            tripsAtWeekday = self.tripsByGroundAtWeekday
            tripsAtRestday = self.tripsByGroundAtRestday
        default:
            fatalError("Unexpected type of transport")
        }
        
        if self.calculatingDays > 0 {
            for numberOfDay in 1...self.calculatingDays {
                let day = self.startDate.add(days: numberOfDay - 1)
                let dayOfWeek = day.dayOfWeek
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
                        startOfNextMonth = startOfNextMonth.startOfNextMonth
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
