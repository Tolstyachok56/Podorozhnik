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
    
    // MARK: - Methods
    
    func setup(calculator: Calculator) {
        self.delegate = self
        self.calculator = calculator
        setupNotificationHandling()
        update()
    }
    
    func update() {
        setTextFrom(calculator?.calculatingDays)
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
        if let daysText = self.text, !daysText.isEmpty {
            calculator?.calculatingDays = Int(daysText)!
        } else {
            calculator?.calculatingDays = 0
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
