//
//  CalculatorCommercialTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorCommercialTextField: UITextField {
    
    // MARK: - Properties

    var calculator: Calculator?
    
    // MARK: -
    
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumIntegerDigits = 1
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    // MARK: - Methods
    
    func setup(calculator: Calculator) {
        self.delegate = self
        self.calculator = calculator
        setupNotificationHandling()
        update()
    }
    
    func update() {
        if let amount = calculator?.commercialAmount {
            self.text = numberFormatter.string(from: amount as NSNumber)
        } else {
            self.text = "0.00"
        }
    }
    
    // MARK: - Notiification handling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(updateCalculatorCommercialAmount),
                                       name: NSNotification.Name.UITextFieldTextDidChange,
                                       object: nil)
    }
    
    @objc private func updateCalculatorCommercialAmount() {
        if let commercialAmountText = self.text, !commercialAmountText.isEmpty {
            calculator?.commercialAmount = Double(commercialAmountText)!
        } else {
            calculator?.commercialAmount = 0.0
        }
    }

}

// MARK: - UITextFieldDelegate methods

extension CalculatorCommercialTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cardBalanceTextField = textField as? CalculatorCommercialTextField {
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
