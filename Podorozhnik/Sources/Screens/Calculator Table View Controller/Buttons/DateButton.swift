//
//  DateButton.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 27.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit

enum DateIntervalEdge {
    case start
    case end
}

class DateButton: UIButton {
    
    // MARK: - Properties
    var calculator: Calculator?
    var dateIntervalEdge: DateIntervalEdge?
    
    // MARK: - Methods
    func setup(calculator: Calculator, dateIntervalEdge: DateIntervalEdge) {
        self.calculator = calculator
        self.dateIntervalEdge = dateIntervalEdge
        self.update()
    }
    
    func update() {
        switch dateIntervalEdge {
        case .start?:
            self.setTitle(self.calculator?.startDate.mediumFormat(), for: .normal)
        case .end?:
            self.setTitle(self.calculator?.endDate.mediumFormat(), for: .normal)
        default:
            fatalError("Unexpected date interval edge")
        }
    }
    
}
