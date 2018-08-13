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
    
    var calculatingDays: Int = 30
    
    var tripsByMetroAtWeekday: Int = 2
    var tripsByMetroAtRestday: Int = 0
    
    var tripsByGroundAtWeekday: Int = 2
    var tripsByGroundAtRestday: Int = 0
    
    var commercialAmount: Double = 0.0
    
    // MARK: -
    
    var card: Card?
    
    // MARK: - Initializing
    
    init() {}
    
    init(calculatingDays: Int, tripsByMetroAtWeekday: Int, tripsByMetroAtRestday: Int, tripsByGroundAtWeekday: Int, tripsByGroundAtRestday: Int, commercialAmount: Double) {
        self.calculatingDays = calculatingDays
        
        self.tripsByMetroAtWeekday = tripsByMetroAtWeekday
        self.tripsByMetroAtRestday = tripsByMetroAtRestday
        
        self.tripsByGroundAtWeekday = tripsByGroundAtWeekday
        self.tripsByGroundAtRestday = tripsByGroundAtRestday
        
        self.commercialAmount = commercialAmount
    }
    
    // MARK: - Methods
    
    func getTotalAmount() -> Double {
        // counting of days begins tommorow
        return getMetroAmount() + getGroundAmount() + commercialAmount
    }
    
    func getRoundedTotalAmount() -> Int {
        let roundedTotalAmount = Double(Int(getTotalAmount())) < getTotalAmount() ? Int(getTotalAmount()) + 1 : Int(getTotalAmount())
        return roundedTotalAmount
    }
    
    private func getMetroAmount() -> Double {
        var amount: Double = 0
        
        let today = Date()
        var startOfNextMonth = today.startOfNextMonth()
        
        if calculatingDays > 0 {
            var numberOfTripsInAMonth = (card?.tripsByMetro())!
            
            for numberOfDay in 1...calculatingDays {
                let day = today.add(days: numberOfDay)
                let dayOfWeek = day.dayOfWeek()
                
                switch dayOfWeek {
                    
                case 2...6:
                    if tripsByMetroAtWeekday > 0 {
                        if day < startOfNextMonth {
                            for _ in 1...tripsByMetroAtWeekday {
                                numberOfTripsInAMonth += 1
                                amount += Tariff.metro(numberOfTrip: numberOfTripsInAMonth)
                            }
                        } else {
                            numberOfTripsInAMonth = 1
                            startOfNextMonth = startOfNextMonth.startOfNextMonth()
                            amount += Tariff.metro(numberOfTrip: numberOfTripsInAMonth)
                        }
                    }
                    
                case 1, 7:
                    if tripsByMetroAtRestday > 0 {
                        if day < startOfNextMonth {
                            for _ in 1...tripsByMetroAtRestday {
                                numberOfTripsInAMonth += 1
                                amount += Tariff.metro(numberOfTrip: numberOfTripsInAMonth)
                            }
                        } else {
                            numberOfTripsInAMonth = 1
                            startOfNextMonth = startOfNextMonth.startOfNextMonth()
                            amount += Tariff.metro(numberOfTrip: numberOfTripsInAMonth)
                        }
                    }
                    
                default:
                    fatalError("Unexpected day of week")
                }
                
            }
        }
        
        return amount
    }
    
    private func getGroundAmount() -> Double {
        var amount: Double = 0
        
        let today = Date()
        var startOfNextMonth = today.startOfNextMonth()
    
        if calculatingDays > 0 {
            var numberOfTripsInAMonth = (card?.tripsByGround())!
            
            for numberOfDay in 1...calculatingDays {
                let day = today.add(days: numberOfDay)
                let dayOfWeek = day.dayOfWeek()
                
                switch dayOfWeek {
                    
                case 2...6:
                    if tripsByGroundAtWeekday > 0 {
                        if day < startOfNextMonth {
                            for _ in 1...tripsByGroundAtWeekday {
                                numberOfTripsInAMonth += 1
                                amount += Tariff.ground(numberOfTrip: numberOfTripsInAMonth)
                            }
                        } else {
                            numberOfTripsInAMonth = 1
                            startOfNextMonth = startOfNextMonth.startOfNextMonth()
                            amount += Tariff.ground(numberOfTrip: numberOfTripsInAMonth)
                        }
                    }
                    
                case 1, 7:
                    if tripsByGroundAtRestday > 0 {
                        if day < startOfNextMonth {
                            for _ in 1...tripsByGroundAtRestday {
                                numberOfTripsInAMonth += 1
                                amount += Tariff.ground(numberOfTrip: numberOfTripsInAMonth)
                            }
                        } else {
                            numberOfTripsInAMonth = 1
                            startOfNextMonth = startOfNextMonth.startOfNextMonth()
                            amount += Tariff.ground(numberOfTrip: numberOfTripsInAMonth)
                        }
                    }
                    
                default:
                    fatalError("Unexpected day of week")
                }
                
            }
        }
        
        return amount
    }
    
}
