//
//  Defaults.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

struct Defaults {
    
    // MARK: - Static properties
    
    static let userDefaults = UserDefaults.standard
    static let userSessionKey = "myPodorozhnik"
    
    
    // MARK: - Static methods
    
    static func saveCard(_ card: Card) {
        userDefaults.set(card.propertyDictRepresentation, forKey: userSessionKey)
        print("Card saved")
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
