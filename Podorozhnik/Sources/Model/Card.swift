//
//  Card.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

protocol CardDelegate: class {
    func cardBalanceDidBecameLessThanTariff(_ card: Card)
}

class Card {
    
    // MARK: - Properties
    var balance: Double = 0 {
        didSet {
            Defaults.saveCard(self)
        }
    }
    var statistics: [MonthStatistics] = []
    weak var delegate: CardDelegate?
    
    var propertyDictRepresentation: [String: Any] {
        var result: [String: Any] = ["balance": self.balance,
                                     "statistics": []]
        if let encodedStatistics = try? JSONEncoder().encode(self.statistics) {
            result["statistics"] = encodedStatistics
        }
        return result
    }
    
    // MARK: - Initializing
    init() {}
    
    init(dict: [String: Any]) {
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
        let reducedBalance = self.balance - amount
        
        let nextTripTariff: Double = transport.getTariff(numberOfTrip: trips(by: transport) + 2)!
        
        if reducedBalance >= nextTripTariff {
            self.balance = reducedBalance
            completionHandler()
            
        } else if reducedBalance >= 0 {
            self.balance = reducedBalance
            completionHandler()
            self.delegate?.cardBalanceDidBecameLessThanTariff(self)
            
        } else {
            self.delegate?.cardBalanceDidBecameLessThanTariff(self)
        }
    }
    
    func trips(by transport: Transport) -> Int {
        let currentStatistics = self.getCurrentMonthStatistics()
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
        let currentStatistics = self.getCurrentMonthStatistics()
        let amount: Double
        
        switch transport {
        case .metro, .ground:
            amount = transport.getTariff(numberOfTrip: trips(by: transport) + 1)!
        case let .commercial(tariff):
            amount = tariff
        }
        
        if amount > 0 {
            self.reduceBalance(by: amount, transport: transport) {
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
            self.topUpTheBalance(amount: amount)
            
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
                currentStatistics.costByCommercial -= amount
            }
        }
        Defaults.saveCard(self)
    }
    
}
