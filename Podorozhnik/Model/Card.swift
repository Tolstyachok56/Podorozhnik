//
//  Card.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol CardDelegate {
    func cardBalanceDidBecameLessThanTariff(_ card: Card)
}

class Card {
    
    // MARK: - Properties
    
    var number: String = "" { didSet { Defaults.saveCard(self) }}
    var balance: Double = 0 { didSet { Defaults.saveCard(self) }}
    
    // MARK: -
    
    var statistics: [MonthStatistics] = []
    
    // MARK: -
    
    var delegate: CardDelegate?
    
    var propertyDictRepresentation: [String: Any] {
        var result: [String: Any] = ["number": self.number,
                                     "balance": self.balance,
                                     "statistics": []]
        if let encodedStatistics = try? JSONEncoder().encode(self.statistics) {
            result["statistics"] = encodedStatistics
        }
        return result
    }
    
    // MARK: - Initializing
    
    init() {}
    
    init(balance: Double, number: String) {
        self.balance = balance
        self.number = number
    }
    
    init(dict: [String: Any]) {
        self.number = dict["number"] as! String
        self.balance = dict["balance"] as! Double
        if let statistics = dict["statistics"] as? Data,
            let loadedStatistics = try? JSONDecoder().decode([MonthStatistics].self, from: statistics) {
                self.statistics = loadedStatistics
        }
    }
    
    // MARK: - Methods
    
    func getCurrentMonthStatistics() -> MonthStatistics {
        let currentMonth = Date().currentMonthString()
        let monthStatistics = self.statistics.filter { $0.month == currentMonth }
        if monthStatistics.isEmpty {
            let newMonthStatistics = MonthStatistics(month: currentMonth)
            self.statistics.append(newMonthStatistics)
            return newMonthStatistics
        } else {
            return monthStatistics.first!
        }
    }
    
    func topUpTheBalance(amount: Double) {
        self.balance += amount
    }
    
    private func reduceBalance(by amount: Double, transport: Transport, completionHandler: @escaping () -> Void) {
        let reducedBalance = balance - amount
        
        let nextTripTariff: Double = transport.getTariff(numberOfTrip: trips(by: transport) + 2)!
        
        if reducedBalance >= nextTripTariff {
            self.balance = reducedBalance
            completionHandler()
            
        } else if reducedBalance >= 0 {
            self.balance = reducedBalance
            completionHandler()
            delegate?.cardBalanceDidBecameLessThanTariff(self)
            
        } else {
            delegate?.cardBalanceDidBecameLessThanTariff(self)
        }
    }
    
    func trips(by transport: Transport) -> Int {
        let currentStatistics = getCurrentMonthStatistics()
        switch transport {
        case .metro:
            return currentStatistics.tripsByMetro
        case .ground:
            return currentStatistics.tripsByGround
        case .commercial:
            return currentStatistics.tripsByCommercial
        }
    }
    
    func addTrip(by transport: Transport) {
        let currentStatistics = getCurrentMonthStatistics()
        let amount: Double
        
        switch transport {
        case .metro, .ground:
            amount = transport.getTariff(numberOfTrip: trips(by: transport) + 1)!
        case let .commercial(tariff):
            amount = tariff
        }
        
        if amount > 0 {
            reduceBalance(by: amount, transport: transport) {
                switch transport {
                case .metro:
                    currentStatistics.tripsByMetro += 1
                    currentStatistics.costByMetro += amount
                case .ground:
                    currentStatistics.tripsByGround += 1
                    currentStatistics.costByGround += amount
                case .commercial(_):
                    currentStatistics.tripsByCommercial += 1
                    currentStatistics.costByCommercial += amount
                }
            }
        }
        
        Defaults.saveCard(self)
        
    }
    
    func reduceTrip(by transport: Transport) {
        let trips = self.trips(by: transport)
        let amount = transport.getTariff(numberOfTrip: trips)!
        
        if trips - 1 >= 0 && amount != 0 {
            topUpTheBalance(amount: amount)
            
            let currentStatistics = self.getCurrentMonthStatistics()
            switch transport {
            case .metro:
                currentStatistics.tripsByMetro -= 1
                currentStatistics.costByMetro -= amount
            case .ground:
                currentStatistics.tripsByGround -= 1
                currentStatistics.costByGround -= amount
            case .commercial(_):
                currentStatistics.tripsByCommercial -= 1
                currentStatistics.costByCommercial -= 1
            }
        }
        Defaults.saveCard(self)
    }
    
}
