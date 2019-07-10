//
//  OldCardBalanceTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class OldCardBalanceTextField: UITextField {
    
    // MARK: - Properties
    var card: Card?
    
    // MARK: - Methods
    func setup(card: Card) {
        self.delegate = self
        self.card = card
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.setupNotificationHandling()
        self.update()
    }
    
    func update() {
        if let balance = self.card?.balance {
            self.text = balance.priceFormat()
        } else {
            self.text = Double(0).priceFormat()
        }
    }
    
    // MARK: - Notiification handling
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(updateCardBalance),
                                       name: UITextField.textDidChangeNotification,
                                       object: nil)
    }
    
    @objc private func updateCardBalance() {
        if let balanceText = self.text, !balanceText.isEmpty {
            self.card?.balance = balanceText.double!
        } else {
            self.card?.balance = 0.0
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension OldCardBalanceTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cardBalanceTextField = textField as? OldCardBalanceTextField {
            cardBalanceTextField.update()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        
        // check for decimal digits
        let allowedCharacters = CharacterSet(charactersIn: "1234567890\(decimalSeparator)")
        let characterSet = CharacterSet(charactersIn: string)
        let isNumber = allowedCharacters.isSuperset(of: characterSet)
        
        if !isNumber {
            return false
            
        } else {
            //check for more than one decimal separator
            let hasMoreThanOneDecimalSeparator: Bool
            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else { return true }
            
            let existingTextHasDecimalSeparator = oldText.range(of: decimalSeparator)
            let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
            
            if existingTextHasDecimalSeparator != nil,
                replacementTextHasDecimalSeparator != nil{
                hasMoreThanOneDecimalSeparator = true
            } else {
                hasMoreThanOneDecimalSeparator = false
            }
            
            //get number of decimal digits
            let numberOfDecimalDigits: Int
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            
            if let decimalSeparatorIndex = newText.firstIndex(of: Character(decimalSeparator)){
                numberOfDecimalDigits = newText.distance(from: decimalSeparatorIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return !hasMoreThanOneDecimalSeparator && numberOfDecimalDigits <= 2
        }
    }
    
}

