//
//  CalculatorTripsTextField.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 08.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

class CalculatorTripsTextField: UITextField {

    var calculator: Calculator?
    var transport: Transport?
    var dayOfWeek: DayOfWeek?
    
    func setup(calculator: Calculator, transport: Transport, dayOfWeek: DayOfWeek) {
        self.delegate = self
        self.calculator = calculator
        self.transport = transport
        self.dayOfWeek = dayOfWeek
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

}

extension CalculatorTripsTextField: UITextFieldDelegate {
    
}
