//
//  CountTextFieldDelegate.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08/07/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import UIKit

protocol CalculatorPublicTripsDelegate: class {
    func calculatorPublicTripsTextField(_ textField: UITextField, numberOfTripsDidEndEditing newNumberOfTrips: Int)
}

class CountTextFieldDelegate: NSObject {
    weak var calculatorPublicTripsDelegate: CalculatorPublicTripsDelegate?
}

extension CountTextFieldDelegate: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if let numberOfTrips = Int(text) {
            self.calculatorPublicTripsDelegate?.calculatorPublicTripsTextField(textField, numberOfTripsDidEndEditing: numberOfTrips)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
