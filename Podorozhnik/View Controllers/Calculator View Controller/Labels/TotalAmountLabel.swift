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

    var calculator: Calculator?
    
    // MARK: - Methods
    
    func setup(calculator: Calculator) {
        self.calculator = calculator
        setupNotificationHandling()
        update()
    }
    
    @objc func update() {
        if let amount = calculator?.getAmount() {
            self.text = "\(amount)"
        } else {
            self.text = "0.0"
        }
    }
    
    // MARK: - Notification hadling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(update),
                                       name: NSNotification.Name.UITextFieldTextDidChange,
                                       object: nil)
    }

}
