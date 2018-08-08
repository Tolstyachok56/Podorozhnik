//
//  CalculatorTripsTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorTripsTextField: UITextField {
    
    // MARK: - Properties

    var calculator: Calculator?
    var transport: Transport?
    var dayOfWeek: DayOfWeek?
    
    // MARK: - Methods
    
    func setup(calculator: Calculator, transport: Transport, dayOfWeek: DayOfWeek) {
        self.delegate = self
        self.calculator = calculator
        self.transport = transport
        self.dayOfWeek = dayOfWeek
        setupNotificationHandling()
        update()
    }
    
    func update() {
        switch transport {
        case .Metro?:
            if dayOfWeek == .Weekday {
                setTextFrom(calculator?.tripsByMetroAtWeekday)
            } else if dayOfWeek == .Restday {
                setTextFrom(calculator?.tripsByMetroAtRestday)
            }
        default:
            fatalError("Unexpected type of transport")
        }
    }
    
    private func setTextFrom(_ trips: Int?) {
        if trips != nil {
            self.text = "\(trips!)"
        } else {
            self.text = "0"
        }
    }
    
    // MARK: - Notiification handling
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(updateCalculatorTrips),
                                       name: NSNotification.Name.UITextFieldTextDidChange,
                                       object: nil)
    }
    
    @objc private func updateCalculatorTrips() {
        switch transport {
        
        case .Metro?:
            if dayOfWeek == .Weekday {
                if let tripsText = self.text, !tripsText.isEmpty {
                    calculator?.tripsByMetroAtWeekday = Int(tripsText)!
                } else {
                    calculator?.tripsByMetroAtWeekday = 0
                }
                
            } else if dayOfWeek == .Restday {
                if let tripsText = self.text, !tripsText.isEmpty {
                    calculator?.tripsByMetroAtRestday = Int(tripsText)!
                } else {
                    calculator?.tripsByMetroAtRestday = 0
                }
            }
            
        default:
            fatalError("Unexpected type of transport")
        }
    }

}

// MARK: - UITextFieldDelegate methods

extension CalculatorTripsTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let tripsTextField = textField as? CalculatorTripsTextField {
            tripsTextField.update()
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
