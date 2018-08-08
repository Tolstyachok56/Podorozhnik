//
//  CalculatorDaysTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorDaysTextField: UITextField {

    var calculator: Calculator?
    var dayOfWeek: DayOfWeek?
    
    func setup(calculator: Calculator, dayOfWeek: DayOfWeek) {
        self.delegate = self
        self.calculator = calculator
        self.dayOfWeek = dayOfWeek
        update()
    }
    
    func update() {
        switch dayOfWeek {
        case .Weekday?:
            setTextFrom(calculator?.weekdays)
        case .Restday?:
            setTextFrom(calculator?.restdays)
        default:
            fatalError("Unexpected day of week")
        }
    }
    
    private func setTextFrom(_ days: Int?) {
        if days != nil {
            self.text = "\(days!)"
        } else {
            self.text = "0"
        }
    }

}

extension CalculatorDaysTextField: UITextFieldDelegate {
    
}
