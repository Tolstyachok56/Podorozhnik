//
//  CommercialTariffTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 10.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CommercialTariffTextField: UITextField {

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
        update()
    }
    
    func update() {
        self.text = getTariff().priceFormat()
    }
    
    // MARK: - Helper methods
    
    func getTariff() -> Double {
        var commercialTariff: Double = 0.00
        if let commercialTariffText = self.text, !commercialTariffText.isEmpty {
            commercialTariff = commercialTariffText.double()!
        }
        return commercialTariff
    }

}

extension CommercialTariffTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let commercialTariffTextField = textField as? CommercialTariffTextField {
            commercialTariffTextField.update()
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
            
            if let decimalSeparatorIndex = newText.index(of: Character(decimalSeparator)){
                numberOfDecimalDigits = newText.distance(from: decimalSeparatorIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return !hasMoreThanOneDecimalSeparator && numberOfDecimalDigits <= 2
        }
    }
    
}
