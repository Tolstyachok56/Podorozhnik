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
        
        var nextTripTariff: Double
        switch transport {
        case .metro:
            nextTripTariff = Tariff.metro(numberOfTrip: tripsByMetro() + 2)
        case .ground:
            nextTripTariff = Tariff.ground(numberOfTrip: tripsByGround() + 2)
        case .commercial:
            nextTripTariff = amount
        }
        
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
    
    func tripsByMetro() -> Int {
        let currentStatistics = getCurrentMonthStatistics()
        return currentStatistics.tripsByMetro
    }
    
    func tripsByGround() -> Int {
        let currentStatistics = getCurrentMonthStatistics()
        return currentStatistics.tripsByGround
    }
    
    func tripsByCommercial() -> Int {
        let currentStatistics = getCurrentMonthStatistics()
        return currentStatistics.tripsByCommercial
    }
    
    func addTripByMetro() {
        let amount = Tariff.metro(numberOfTrip: tripsByMetro() + 1)
        
        reduceBalance(by: amount, transport: .metro) {
            
            let currentStatistics = self.getCurrentMonthStatistics()
            currentStatistics.tripsByMetro += 1
            currentStatistics.costByMetro += amount
        }
        Defaults.saveCard(self)
    }
    
    func addTripByGround() {
        let amount = Tariff.ground(numberOfTrip: tripsByGround() + 1)
        
        reduceBalance(by: amount, transport: .metro) {
            
            let currentStatistics = self.getCurrentMonthStatistics()
            currentStatistics.tripsByGround += 1
            currentStatistics.costByGround += amount
        }
        Defaults.saveCard(self)
    }
    
    func addTripByCommercial(tariff: Double) {
        if tariff != 0 {
            reduceBalance(by: tariff, transport: .commercial) {
                let currentStatistics = self.getCurrentMonthStatistics()
                currentStatistics.tripsByCommercial += 1
                currentStatistics.costByCommercial += tariff
            }
        }
        Defaults.saveCard(self)
    }
    
    func reduceTripByMetro() {
        if self.tripsByMetro() - 1 >= 0 {
            let amount = Tariff.metro(numberOfTrip: tripsByMetro())
            topUpTheBalance(amount: amount)
            
            let currentStatistics = self.getCurrentMonthStatistics()
            currentStatistics.tripsByMetro -= 1
            currentStatistics.costByMetro -= amount
        }
        Defaults.saveCard(self)
    }
    
    func reduceTripByGround() {
        if self.tripsByGround() - 1 >= 0 {
            let amount = Tariff.ground(numberOfTrip: tripsByGround())
            topUpTheBalance(amount: amount)
            
            let currentStatistics = self.getCurrentMonthStatistics()
            currentStatistics.tripsByGround -= 1
            currentStatistics.costByGround -= amount
        }
        Defaults.saveCard(self)
    }
    
    func reduceTripByCommercial(tariff: Double) {
        if self.tripsByCommercial() - 1 >= 0, tariff != 0 {
            topUpTheBalance(amount: tariff)
            
            let currentStatistics = self.getCurrentMonthStatistics()
            currentStatistics.tripsByCommercial -= 1
            currentStatistics.costByCommercial -= tariff
        }
        Defaults.saveCard(self)
    }
    
}
