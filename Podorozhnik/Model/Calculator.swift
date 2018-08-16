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
        return getPublicTransportAmount(transport: .metro)
    }
    
    private func getGroundAmount() -> Double {
        return getPublicTransportAmount(transport: .ground)
    }
    
    // MARK: - Helper methods
    
    private func getPublicTransportAmount(transport: Transport) -> Double {
        var amount: Double = 0
        
        let today = Date()
        var startOfNextMonth = today.startOfNextMonth()
        
        let currentNumberOfTrips: Int
        let tripsAtWeekday: Int
        let tripsAtRestday: Int
        
        switch transport {
        case .metro:
            currentNumberOfTrips = (card?.tripsByMetro())!
            tripsAtWeekday = tripsByMetroAtWeekday
            tripsAtRestday = tripsByMetroAtRestday
        case .ground:
            currentNumberOfTrips = (card?.tripsByGround())!
            tripsAtWeekday = tripsByGroundAtWeekday
            tripsAtRestday = tripsByGroundAtRestday
        default:
            fatalError("Unexpected type of transport")
        }
        
        if calculatingDays > 0 {
            var numberOfTripsInAMonth = currentNumberOfTrips
            
            for numberOfDay in 1...calculatingDays {
                let day = today.add(days: numberOfDay)
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
                            amount += getPublicTransportTariff(transport: transport, numberOfTrip: numberOfTripsInAMonth)
                        }
                    } else {
                        numberOfTripsInAMonth = 1
                        startOfNextMonth = startOfNextMonth.startOfNextMonth()
                        amount += getPublicTransportTariff(transport: transport, numberOfTrip: numberOfTripsInAMonth)
                    }
                }
            }
        }
        
        return amount
    }
    
    private func getPublicTransportTariff(transport: Transport, numberOfTrip: Int) -> Double {
        switch transport {
        case .metro:
            return Tariff.metro(numberOfTrip: numberOfTrip)
        case .ground:
            return Tariff.ground(numberOfTrip: numberOfTrip)
        case .commercial:
            print("Commercial transport has no constant tariff")
            return 0
        }
    }
    
}
