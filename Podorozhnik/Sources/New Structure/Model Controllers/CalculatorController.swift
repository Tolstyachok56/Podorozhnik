//
//  CalculatorController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/06/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

class CalculatorController {
        
    // MARK: - Properties
    var calculator: Calculator
    var transportCard: TransportCard
    var publicTransportFaresStateController: PublicTransportFaresStateController
    
    private var calculatingDays: Int {
        return Calendar.current.dateComponents([.day], from: self.calculator.startDate, to: self.calculator.endDate).day! + 1
    }
    
    // MARK: - Initializing
    init(calculator: Calculator, transportCard: TransportCard, publicTransportFares: PublicTransportFaresStateController) {
        self.calculator = calculator
        self.transportCard = transportCard
        self.publicTransportFaresStateController = publicTransportFares
    }
    
    // MARK: - Methods
    func getTotalAmount() -> Double {
        return self.getAmount(for: .metro) + self.getAmount(for: .ground) + self.calculator.commercialAmount
    }
    func getMissingAmount() -> Double? {
        let cardBalance = self.transportCard.balance
        let totalAmount = self.getTotalAmount()
        return (cardBalance < totalAmount) ? (totalAmount - cardBalance) : nil
    }
    
    private func getAmount(for transportType: TransportType) -> Double {
        var amount: Double = 0
        
        let today = Date()
        var startOfNextMonth = today.startOfNextMonth
        
        var currentNumberOfTrips: Int
        let tripsAtWeekday: Int
        let tripsAtRestday: Int
        
        switch transportType {
        case .metro:
            currentNumberOfTrips = self.transportCard.numberOfTripsByMetro
            tripsAtWeekday = self.calculator.tripsByMetroAtWeekday
            tripsAtRestday = self.calculator.tripsByMetroAtRestday
        case .ground:
            currentNumberOfTrips = self.transportCard.numberOfTripsByGround
            tripsAtWeekday = self.calculator.tripsByGroundAtWeekday
            tripsAtRestday = self.calculator.tripsByGroundAtRestday
        default:
            fatalError("Unexpected type of transport")
        }
        
        if self.calculatingDays > 0 {
            for numberOfDay in 1...self.calculatingDays {
                let day = self.calculator.startDate.add(days: numberOfDay - 1)
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
                        amount += self.publicTransportFaresStateController.getFare(for: transportType, numberOfTrip: currentNumberOfTrips)
                    }
                }
            }
        }
        return amount
    }
}
