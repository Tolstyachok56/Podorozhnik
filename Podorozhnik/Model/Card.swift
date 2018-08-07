//
//  Card.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol CardDelegate {
    func cardBalanceDidBecameLessThanFare(_ card: Card)
}

class Card {
    
    // MARK: - Properties
    
    var number: String = "" { didSet { Defaults.saveCard(self) }}
    var balance: Double = 0 { didSet { Defaults.saveCard(self) }}
    
    // MARK: -
    
    var tripsByMetro: Int = 0
    var statistics: [MonthStatistics] = []
    
    // MARK: -
    
    var delegate: CardDelegate?
    
    var propertyDictRepresentation: [String: Any] {
        var result: [String: Any] = ["number": self.number,
                                     "balance": self.balance,
                                     "tripsByMetro": self.tripsByMetro,
                                     "statistics": []]
        if let encodedStatistics = try? JSONEncoder().encode(self.statistics) {
            result["statistics"] = encodedStatistics
        }
        return result
    }
    
    // MARK: - Initializing
    
    init() {}
    
    init(balance: Double, number: String, tripsByMetro: Int) {
        self.balance = balance
        self.number = number
        self.tripsByMetro = tripsByMetro
    }
    
    init(dict: [String: Any]) {
        self.number = dict["number"] as! String
        self.balance = dict["balance"] as! Double
        self.tripsByMetro = dict["tripsByMetro"] as! Int
        if let statistics = dict["statistics"] as? Data,
            let loadedStatistics = try? JSONDecoder().decode([MonthStatistics].self, from: statistics) {
                self.statistics = loadedStatistics
        }
    }
    
    // MARK: - Methods
    
    func topUpTheBalance(amount: Double) {
        self.balance += amount
    }
    
    private func reduceBalance(by amount: Double, completionHandler: @escaping () -> Void) {
        let reducedBalance = balance - amount
        if reducedBalance >= Fare.metro{
            self.balance = reducedBalance
            completionHandler()
        } else if reducedBalance >= 0 {
            self.balance = reducedBalance
            completionHandler()
            delegate?.cardBalanceDidBecameLessThanFare(self)
        } else {
            delegate?.cardBalanceDidBecameLessThanFare(self)
        }
    }
    
    func addTripsByMetro(_ numberOfTrips: Int) {
        let amount = Double(numberOfTrips) * Fare.metro
        reduceBalance(by: amount) {
            self.tripsByMetro += numberOfTrips
            let currentMonth = Date.currentMonthString()
            let monthStatistics = self.statistics.filter {$0.month == currentMonth}
            if monthStatistics.isEmpty {
                self.statistics.append(MonthStatistics(month: currentMonth, tripsByMetro: 1, costByMetro: Fare.metro))
                //
                let statistics = monthStatistics.first
                print("month: \((statistics?.month)!), trips: \((statistics?.tripsByMetro)!), cost: \((statistics?.costByMetro)!)")
            } else {
                let statistics = monthStatistics.first
                statistics?.tripsByMetro += numberOfTrips
                statistics?.costByMetro += amount
                print("month: \((statistics?.month)!), trips: \((statistics?.tripsByMetro)!), cost: \((statistics?.costByMetro)!)")
            }
        }
        Defaults.saveCard(self)
    }
    
    func reduceTripsByMetro(_ numberOfTrips: Int) {
        if self.tripsByMetro - numberOfTrips >= 0 {
            let amount = Double(numberOfTrips) * Fare.metro
            topUpTheBalance(amount: amount)
            self.tripsByMetro -= numberOfTrips
            let currentMonth = Date.currentMonthString()
            let monthStatistics = self.statistics.filter {$0.month == currentMonth}
            if !monthStatistics.isEmpty {
                let statistics = monthStatistics.first
                statistics?.tripsByMetro -= numberOfTrips
                statistics?.costByMetro -= amount
                print("month: \((statistics?.month)!), trips: \((statistics?.tripsByMetro)!), cost: \((statistics?.costByMetro)!)")
            }
        }
        Defaults.saveCard(self)
    }
    
}
