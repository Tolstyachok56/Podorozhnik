//
//  Card.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 03.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

class Card {
    
    // MARK: - Properties
    
    var balance: Double = 0 { didSet { Defaults.saveCard(self) }}
    var number: String = "" { didSet { Defaults.saveCard(self) }}
    
    var tripsByMetro: Int = 0
    
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
            guard let key = label else{
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
        if reducedBalance >= 0 {
            self.balance = reducedBalance
            completionHandler()
        } else {
            print("Balance can't be less than 0")
        }
    }
    
}

struct Defaults {
    
    // MARK: - Static properties
    
    static let userDefaults = UserDefaults.standard
    static let userSessionKey = "myPodorozhnik"
    
    
    // MARK: - Static methods
    
    static func saveCard(_ card: Card) {
        userDefaults.set(card.propertyDictRepresentation, forKey: userSessionKey)
    }
    
    static func getCard() -> Card {
        if let dictionary = userDefaults.value(forKey: userSessionKey) as? [String: Any] {
            return Card(dict: dictionary)
        } else {
            return Card()
        }
    }
    
    static func clear() {
        userDefaults.removeObject(forKey: userSessionKey)
    }
    
}


