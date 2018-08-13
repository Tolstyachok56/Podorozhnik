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
    
    // MARK: -
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 1
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    // MARK: - Methods
    
    func setup(calculator: Calculator) {
        self.calculator = calculator
        setupNotificationHandling()
        update()
    }
    
    @objc func update() {
        if let amount = calculator?.getTotalAmount() {
            self.text = numberFormatter.string(from: amount as NSNumber)
        } else {
            self.text = "0.00"
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
