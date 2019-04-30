//
//  TripsTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TripsTextField: UITextField {
    
    // MARK: - Properties
    var card: Card?
    var transport: Transport?
    
    // MARK: - Methods
    func setup(card: Card, transport: Transport) {
        self.card = card
        self.transport = transport
        self.update()
    }
    
    func update() {
        switch transport {
        case .metro?:
            self.setTextFrom(card?.trips(by: .metro))
        case .ground?:
            self.setTextFrom(card?.trips(by: .ground))
        case .commercial?:
            self.setTextFrom(card?.trips(by: .commercial(tariff: 0)))
        default:
            fatalError("Unexpected type of transport")
        }
    }
    
    private func setTextFrom(_ trips: Int?) {
        if trips != nil {
            self.text = "\(trips!)"
        } else {
            self.text = "0"
        }
    }
    
}
