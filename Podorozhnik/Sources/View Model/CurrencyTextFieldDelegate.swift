//
//  CurrencyTextFieldDelegate.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol TransportCardBalanceDelegate: class {
    func transportCardBalanceTextField(_ textField: UITextField, cardBalanceDidEndEditing newBalance: Double)
}
protocol CalculatorCommercialAmountDelegate: class {
    func calculatorCommercialAmountTextField(_ textField: UITextField, commercialAmountDidEndEditing newAmount: Double)
}

class CurrencyTextFieldDelegate: NSObject {
    weak var transportCardBalanceDelegate: TransportCardBalanceDelegate?
    weak var calculatorCommercialAmountDelegate: CalculatorCommercialAmountDelegate?
    
    enum Tag: Int {
        case defaultTag = 0
        case transportCardBalance, calculatorCommercialAmount
    }
}

extension CurrencyTextFieldDelegate: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            let currencyText = text.rublesFormatting {
            textField.text = currencyText
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField.tag == Tag.transportCardBalance.rawValue,
            let balance = text.double {
            self.transportCardBalanceDelegate?.transportCardBalanceTextField(textField, cardBalanceDidEndEditing: balance)
        }
        
        if textField.tag == Tag.calculatorCommercialAmount.rawValue,
            let amount = text.double {
            self.calculatorCommercialAmountDelegate?.calculatorCommercialAmountTextField(textField, commercialAmountDidEndEditing: amount)
        }
        
        if let currencyText = text.rublesGroupedFormatting {
            textField.text = currencyText
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let dotDecimalSeparator = "."
        let commaDecimalSeparator = ","
    
        // check for decimal digits
        let allowedCharacters = CharacterSet(charactersIn: "1234567890\(dotDecimalSeparator)\(commaDecimalSeparator)")
        let characterSet = CharacterSet(charactersIn: string)
        let isNumber = allowedCharacters.isSuperset(of: characterSet)
        
        if !isNumber {
            return false
            
        } else {
            //check for more than one decimal separator
            let newTextHasMoreThanOneDecimalSeparator: Bool
            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else { return true }
            
            let existingTextHasDecimalSeparator = oldText.contains(dotDecimalSeparator) || oldText.contains(commaDecimalSeparator)
            let replacementTextHasDecimalSeparator = string.contains(dotDecimalSeparator) || string.contains(commaDecimalSeparator)
            
            if existingTextHasDecimalSeparator &&
                replacementTextHasDecimalSeparator {
                newTextHasMoreThanOneDecimalSeparator = true
            } else {
                newTextHasMoreThanOneDecimalSeparator = false
            }
            
            //get number of decimal digits
            let numberOfDecimalDigits: Int
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            
            if let dotDecimalSeparatorIndex = newText.firstIndex(of: Character(dotDecimalSeparator)){
                numberOfDecimalDigits = newText.distance(from: dotDecimalSeparatorIndex, to: newText.endIndex) - 1
            } else if let commaDecimalSeparatorIndex = newText.firstIndex(of: Character(commaDecimalSeparator)) {
                numberOfDecimalDigits = newText.distance(from: commaDecimalSeparatorIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return !newTextHasMoreThanOneDecimalSeparator && numberOfDecimalDigits <= 2
        }
    }
}
