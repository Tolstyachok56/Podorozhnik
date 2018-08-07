//
//  MonthStatistics.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

class MonthStatistics: Codable {
    
    let month: String
    var tripsByMetro: Int
    var costByMetro: Double
    
    init(month: String, tripsByMetro: Int, costByMetro: Double) {
        self.month = month
        self.tripsByMetro = tripsByMetro
        self.costByMetro = costByMetro
    }
    
}
