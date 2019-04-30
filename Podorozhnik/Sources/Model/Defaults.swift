//
//  Defaults.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

struct Defaults {
    
    // MARK: - Static Properties
    static let userDefaults = UserDefaults.standard
    static let userSessionKey = "myPodorozhnik"
    
    
    // MARK: - Static Methods
    static func saveCard(_ card: Card) {
        self.userDefaults.set(card.propertyDictRepresentation, forKey: self.userSessionKey)
        print("Card saved")
    }
    
    static func getCard() -> Card {
        if let dictionary = self.userDefaults.value(forKey: self.userSessionKey) as? [String: Any] {
            return Card(dict: dictionary)
        } else {
            return Card()
        }
    }
    
    static func clear() {
        self.userDefaults.removeObject(forKey: self.userSessionKey)
    }
}
