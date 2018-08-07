//
//  CardBalanceTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CardBalanceTextField: UITextField {
    
    var card: Card?
    
    func setup() {
        update()
    }
    
    func update() {
        guard let balance = card?.balance else {
            self.text = "\(0.0)"
            return
        }
        self.text = "\(balance)"
    }
    
}
