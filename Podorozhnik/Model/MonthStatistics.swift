//
//  MonthStatistics.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//
import Foundation

class MonthStatistics: Codable {
    
    let month: String
    
    var tripsByMetro: Int = 0
    var costByMetro: Double = 0.00
    
    var tripsByCommercial: Int = 0
    var costByCommercial: Double = 0.00
    
    init(month: String) {
        self.month = month
    }
    
    init(month: String, tripsByMetro: Int, costByMetro: Double, tripsByCommercial: Int, costByCommercial: Double) {
        self.month = month
        self.tripsByMetro = tripsByMetro
        self.costByMetro = costByMetro
        self.tripsByCommercial = tripsByCommercial
        self.costByCommercial = costByCommercial
    }
    
}
