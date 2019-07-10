//
//  CalculatorTripsTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorTripsTextField: UITextField {
    
    // MARK: - Enums
    enum DayOfWeek {
        case weekday
        case restday
    }
    
    // MARK: - Properties
    var calculator: CalculatorOld?
    var transport: Transport?
    var dayOfWeek: DayOfWeek?
    
    // MARK: - Methods
    func setup(calculator: CalculatorOld, transport: Transport, dayOfWeek: DayOfWeek) {
        self.delegate = self
        self.calculator = calculator
        self.transport = transport
        self.dayOfWeek = dayOfWeek
        self.setupNotificationHandling()
        self.update()
    }
    
    func update() {
        switch transport {
        case .metro?:
            if self.dayOfWeek == .weekday {
                self.setTextFrom(self.calculator?.tripsByMetroAtWeekday)
            } else if self.dayOfWeek == .restday {
                self.setTextFrom(self.calculator?.tripsByMetroAtRestday)
            }
        case .ground?:
            if self.dayOfWeek == .weekday {
                self.setTextFrom(self.calculator?.tripsByGroundAtWeekday)
            } else if dayOfWeek == .restday {
                self.setTextFrom(self.calculator?.tripsByGroundAtRestday)
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
                                       name: UITextField.textDidChangeNotification,
                                       object: nil)
    }
    
    @objc private func updateCalculatorTrips() {
        switch self.transport {
        
        case .metro?:
            if self.dayOfWeek == .weekday {
                if let tripsText = self.text, !tripsText.isEmpty {
                    self.calculator?.tripsByMetroAtWeekday = Int(tripsText)!
                } else {
                    self.calculator?.tripsByMetroAtWeekday = 0
                }
                
            } else if self.dayOfWeek == .restday {
                if let tripsText = self.text, !tripsText.isEmpty {
                    self.calculator?.tripsByMetroAtRestday = Int(tripsText)!
                } else {
                    self.calculator?.tripsByMetroAtRestday = 0
                }
            }
            
        case .ground?:
            if self.dayOfWeek == .weekday {
                if let tripsText = self.text, !tripsText.isEmpty {
                    self.calculator?.tripsByGroundAtWeekday = Int(tripsText)!
                } else {
                    self.calculator?.tripsByGroundAtWeekday = 0
                }
                
            } else if self.dayOfWeek == .restday {
                if let tripsText = self.text, !tripsText.isEmpty {
                    self.calculator?.tripsByGroundAtRestday = Int(tripsText)!
                } else {
                    self.calculator?.tripsByGroundAtRestday = 0
                }
            }
            
        default:
            fatalError("Unexpected type of transport")
        }
    }

}

// MARK: - UITextFieldDelegate
extension CalculatorTripsTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let tripsTextField = textField as? CalculatorTripsTextField {
//            tripsTextField.update()
//        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // check for decimal digits
        let allowedCharacters = CharacterSet(charactersIn: "1234567890")
        let characterSet = CharacterSet(charactersIn: string)
        let isIntNumber = allowedCharacters.isSuperset(of: characterSet)
        
        return isIntNumber
    }
    
}


