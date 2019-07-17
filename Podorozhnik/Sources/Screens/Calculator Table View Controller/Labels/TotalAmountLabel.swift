//
//  TotalAmountLabel.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class TotalAmountLabel: UILabel {
    
    // MARK: - Properties
    var calculator: CalculatorOld?
    
    // MARK: - Methods
    func setup(calculator: CalculatorOld) {
        self.calculator = calculator
        self.setupNotificationHandling()
        self.update()
    }
    
    @objc func update() {
        if let amount = self.calculator?.getTotalAmount() {
            self.text = amount.priceFormat()
        } else {
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