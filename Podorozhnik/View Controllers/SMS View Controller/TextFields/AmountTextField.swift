//
//  Amount.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 14.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class AmountTextField: UITextField {

    // MARK: - Properties
    
    var amount: Int?
    
    // MARK: - Methods
    
    func setup(amount: Int) {
        self.delegate = self
        self.amount = amount
        setupNotificationHandling()
        update()
    }
    
    func update() {
        if let amount = self.amount {
            self.text = "\(amount)"
        } else {
            self.text = "0"
        }
    }
    
    // MARK: - Notiification handling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(updateAmount),
                                       name: NSNotification.Name.UITextFieldTextDidChange,
                                       object: nil)
    }
    
    @objc private func updateAmount() {
        if let amountText = self.text, !amountText.isEmpty {
            self.amount = Int(amountText)
        } else {
            self.amount = 0
        }
    }
    
}

extension AmountTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let amountTextField = textField as? AmountTextField {
            amountTextField.update()
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
