//
//  TripsTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TripsTextField: UITextField {

    var card: Card?
    var transport: Transport?
    
    func setup(card: Card, transport: Transport) {
        self.card = card
        self.transport = transport
        update()
    }
    
    func update() {
        switch transport {
        case .Metro?:
            setTextFrom(card?.tripsByMetro())
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
