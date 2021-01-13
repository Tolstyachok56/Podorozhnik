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
    func getTotalAmount(at currentDate: Date = Date()) -> Double {
        return self.getAmount(for: .metro, at: currentDate) + self.getAmount(for: .ground, at: currentDate) + self.calculator.commercialAmount
    }
    func getMissingAmount(at currentDate: Date = Date()) -> Double? {
        let cardBalance = self.transportCard.balance
        let totalAmount = self.getTotalAmount(at: currentDate)
        return (cardBalance < totalAmount) ? (totalAmount - cardBalance) : nil
    }
    
    private func getTripsAtWeekday(for publicTransportType: TransportType) -> Int {
        switch publicTransportType {
        case .metro:
            return self.calculator.tripsByMetroAtWeekday
        case .ground:
            return self.calculator.tripsByGroundAtWeekday
        default:
            return 0
        }
    }
    
    private func getTripsAtRestday(for publicTransportType: TransportType) -> Int {
        switch publicTransportType {
        case .metro:
            return self.calculator.tripsByMetroAtRestday
        case .ground:
            return self.calculator.tripsByGroundAtRestday
        default:
            return 0
        }
    }
    
    private func getAmount(for transportType: TransportType, at currentDate: Date = Date()) -> Double {
        var amount: Double = 0
        
        var startOfNextMonth = currentDate.startOfNextMonth
        
        var currentNumberOfTrips: Int = self.transportCard.getNumberOfTrips(by: transportType, at: currentDate)
        let tripsAtWeekday: Int = self.getTripsAtWeekday(for: transportType)
        let tripsAtRestday: Int = self.getTripsAtRestday(for: transportType)
        
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
