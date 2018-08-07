//
//  FareLabel.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class FareLabel: UILabel {

    var card: Card?
    var transport: Transport?
    
    func setup() {
        update()
    }
    
    func update() {
        switch transport {
        case .Metro?:
            let fare = Fare.metro(numberOfTrip: (card?.tripsByMetro())! + 1)
            self.text = "next: \(fare)"
        default:
            fatalError("Unexpected type of transport")
        }
    }

}
