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
    
    var balance: Double = 0 { didSet { Defaults.saveCard(self) }}
    var number: String = "" { didSet { Defaults.saveCard(self) }}
    
    var tripsByMetro: Int = 0
    
    var delegate: CardDelegate?
    
    // MARK: - Initializing
    
    init() {}
    
    init(balance: Double, number: String, tripsByMetro: Int) {
        self.balance = balance
        self.number = number
        self.tripsByMetro = tripsByMetro
    }
    
    init(dict: [String: Any]) {
        self.balance = dict["balance"] as! Double
        self.number = dict["number"] as! String
        self.tripsByMetro = dict["tripsByMetro"] as! Int
    }
    
    // MARK: - Helpers
    
    var propertyDictRepresentation: [String: Any] {
        var result: [String:Any] = [:]
        for case let (label, value) in Mirror(reflecting: self).children {
            guard let key = label, key != "delegate" else {
                continue
            }
            result.updateValue(value, forKey: key)
        }
        return result
    }
    
    // MARK: - Methods
    
    func addTripsByMetro(_ numberOfTrips: Int) {
        let amount = Double(numberOfTrips) * Fare.metro
        reduceBalance(by: amount) {
            self.tripsByMetro += numberOfTrips
        }
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
    
}
