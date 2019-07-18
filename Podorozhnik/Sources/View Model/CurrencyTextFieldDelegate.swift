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
            let balance = Double(text) {
            self.transportCardBalanceDelegate?.transportCardBalanceTextField(textField, cardBalanceDidEndEditing: balance)
        }
        
        if textField.tag == Tag.calculatorCommercialAmount.rawValue,
            let amount = Double(text) {
            self.calculatorCommercialAmountDelegate?.calculatorCommercialAmountTextField(textField, commercialAmountDidEndEditing: amount)
        }
        
        if let currencyText = text.rublesGroupedFormatting {
            textField.text = currencyText
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
