//
//  TotalAmountLabel.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TotalAmountLabel: UILabel {

    var calculator: Calculator?
    
    func setup(calculator: Calculator) {
        self.calculator = calculator
        update()
    }
    
    func update() {
        if let amount = calculator?.getAmount() {
            self.text = "\(amount)"
        } else {
            self.text = "0.0"
        }
    }

}
