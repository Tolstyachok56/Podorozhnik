//
//  CardNumberTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 14.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CardNumberTextField: UITextField {

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
        if let cardNumber = card?.number {
            self.text = cardNumber
        } else {
            self.text = ""
        }
    }
    
    // MARK: - Notiification handling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(updateCardNumber),
                                       name: NSNotification.Name.UITextFieldTextDidChange,
                                       object: nil)
    }
    
    @objc private func updateCardNumber() {
        if let cardNumberText = self.text, !cardNumberText.isEmpty {
            card?.number = cardNumberText
        } else {
            card?.number = ""
        }
    }
    
}

extension CardNumberTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cardNumberTextField = textField as? CardNumberTextField {
            cardNumberTextField.update()
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
