//
//  DateIntervalLabel.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 22.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class DateIntervalLabel: UILabel {

    // MARK: - Properties
    
    var calculator: Calculator?
    
    // MARK: -
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: - Methods
    
    func setup(calculator: Calculator) {
        self.calculator = calculator
        setupNotificationHandling()
        update()
    }
    
    @objc func update() {
        if let days = calculator?.calculatingDays, days > 0{
            let firstDate = dateFormatter.string(from: Date().add(days: 1))
            let lastDate = dateFormatter.string(from: Date().add(days: days))
            self.text = "\(firstDate) - \(lastDate)"
        } else {
            self.text = "-"
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
