//
//  Calculator.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/06/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

class Calculator {
    var startDate: Date = Date().startOfDay
    var endDate: Date
    var tripsByMetroAtWeekday: Int = 0
    var tripsByMetroAtRestday: Int = 0
    var tripsByGroundAtWeekday: Int = 0
    var tripsByGroundAtRestday: Int = 0
    var commercialAmount: Double = 0.0
    init() {
        self.endDate = self.startDate.endOfMonth.startOfDay
    }
}
