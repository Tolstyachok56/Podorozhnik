//
//  DateButton.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 13.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

enum CalculatorDay {
    case first
    case last
}

class DateButton: UIButton {

    // MARK: - Properties
    
    var calculator: Calculator?
    
    // MARK: -
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: - Methods
    
    func setup(calculator: Calculator, calculatorDay: CalculatorDay) {
        self.calculator = calculator
        update(calculatorDay: calculatorDay)
    }
    
    func update(calculatorDay: CalculatorDay) {
        switch calculatorDay {
        case .first:
            self.setTitle(dateFormatter.string(from: (calculator?.firstDate)!), for: .normal)
        case .last:
            self.setTitle(dateFormatter.string(from: (calculator?.lastDate)!), for: .normal)
        }
    }

}
