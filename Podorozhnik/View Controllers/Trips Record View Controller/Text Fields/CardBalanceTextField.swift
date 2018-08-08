//
//  CardBalanceTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 06.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CardBalanceTextField: UITextField {
    
    // MARK: - Properties
    
    var card: Card?
    
    // MARK: - Methods
    
    func setup(card: Card) {
        self.delegate = self
        self.card = card
        setupNotificationHandling()
        update()
    }
    
    func update() {
        guard let balance = card?.balance else {
            self.text = "\(0.0)"
            return
        }
        self.text = "\(balance)"
    }
    
    // MARK: - Notiification handling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(updateCardBalance),
                                       name: NSNotification.Name.UITextFieldTextDidChange,
                                       object: nil)
    }
    
    @objc private func updateCardBalance() {
        if let balanceText = self.text, !balanceText.isEmpty {
            card?.balance = Double(balanceText)!
        } else {
            card?.balance = 0.0
        }
    }
    
}

// MARK: - UITextFieldDelegate methods

extension CardBalanceTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cardBalanceTextField = textField as? CardBalanceTextField {
            cardBalanceTextField.update()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // check for decimal digits
        let allowedCharacters = CharacterSet(charactersIn: "1234567890.")
        let characterSet = CharacterSet(charactersIn: string)
        let isNumber = allowedCharacters.isSuperset(of: characterSet)
        
        if !isNumber {
            return false
            
        } else {
            //check for more than one decimal separator
            let hasMoreThanOneDecimalSeparator: Bool
            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else { return true }
            
            let existingTextHasDecimalSeparator = oldText.range(of: ".")
            let replacementTextHasDecimalSeparator = string.range(of: ".")
            
            if existingTextHasDecimalSeparator != nil,
                replacementTextHasDecimalSeparator != nil{
                hasMoreThanOneDecimalSeparator = true
            } else {
                hasMoreThanOneDecimalSeparator = false
            }
            
            //get number of decimal digits
            let numberOfDecimalDigits: Int
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            
            if let decimalSeparatorIndex = newText.index(of: "."){
                numberOfDecimalDigits = newText.distance(from: decimalSeparatorIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return !hasMoreThanOneDecimalSeparator && numberOfDecimalDigits <= 2
        }
    }
    
}

