//
//  MissingAmountLabel.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 29.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class MissingAmountLabel: UILabel {

    // MARK: - Properties
    var calculator: CalculatorOld?
    
    // MARK: - Methods
    func setup(calculator: CalculatorOld) {
        self.calculator = calculator
        self.setupNotificationHandling()
        self.update()
    }
    
    @objc func update() {
        if let amount = self.calculator?.getTotalAmount(),
            let cardBalance = self.calculator?.card?.balance,
            amount > cardBalance {
            self.textColor = UIColor.red
            self.text = (amount - cardBalance).priceFormat()
        } else {
            self.textColor = UIColor.black
            self.text = Double(0).priceFormat()
        }
    }
    
    // MARK: - Notification hadling
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(update),
                                       name: UITextField.textDidChangeNotification,
                                       object: nil)
    }

}
