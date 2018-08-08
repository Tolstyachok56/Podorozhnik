//
//  CalculatorDaysTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorDaysTextField: UITextField {
    
    // MARK: - Properties

    var calculator: Calculator?
    var dayOfWeek: DayOfWeek?
    
    // MARK: - Methods
    
    func setup(calculator: Calculator, dayOfWeek: DayOfWeek) {
        self.delegate = self
        self.calculator = calculator
        self.dayOfWeek = dayOfWeek
        setupNotificationHandling()
        update()
    }
    
    func update() {
        switch dayOfWeek {
        case .Weekday?:
            setTextFrom(calculator?.weekdays)
        case .Restday?:
            setTextFrom(calculator?.restdays)
        default:
            fatalError("Unexpected day of week")
        }
    }
    
    private func setTextFrom(_ days: Int?) {
        if days != nil {
            self.text = "\(days!)"
        } else {
            self.text = "0"
        }
    }
    
    // MARK: - Notification handling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(updateCalculatorDays),
                                       name: NSNotification.Name.UITextFieldTextDidChange,
                                       object: nil)
    }
    
    @objc private func updateCalculatorDays() {
        
        switch dayOfWeek {
        case .Weekday?:
            if let daysText = self.text, !daysText.isEmpty {
                calculator?.weekdays = Int(daysText)!
            } else {
                calculator?.weekdays = 0
            }
        case .Restday?:
            if let daysText = self.text, !daysText.isEmpty {
                calculator?.restdays = Int(daysText)!
            } else {
                calculator?.restdays = 0
            }
        default:
            fatalError("Unexpected day of week")
        }
    }

}

// MARK: - UITextFieldDelegate methods

extension CalculatorDaysTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let daysTextField = textField as? CalculatorDaysTextField {
            daysTextField.update()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // check for decimal digits
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        let isIntNumber = allowedCharacters.isSuperset(of: characterSet)
        
        return isIntNumber
    }
    
}
