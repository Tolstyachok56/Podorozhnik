//
//  TariffLabel.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TariffLabel: UILabel {
    
    // MARK: - Properties

    var card: Card?
    var transport: Transport?
    
    // MARK: -
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 1
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    // MARK: - Methods
    
    func setup(card: Card, transport: Transport) {
        self.card = card
        self.transport = transport
        update()
    }
    
    func update() {
        let numberOfTrip: Int
        switch transport {
        case .metro?:
            numberOfTrip = (card?.trips(by: .metro))! + 1
        case .ground?:
            numberOfTrip = (card?.trips(by: .ground))! + 1
        default:
            fatalError("Unexpected type of transport")
        }
        
        let tariff = transport!.getTariff(numberOfTrip: numberOfTrip)!
        self.text = "next: " + numberFormatter.string(from: tariff as NSNumber)!
    }

}
