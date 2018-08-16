//
//  MonthStatistics.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 07.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

class MonthStatistics: Codable {
    
    // MARK: - Properties
    
    let month: String
    
    var tripsByMetro: Int = 0
    var costByMetro: Double = 0.00
    
    var tripsByGround: Int = 0
    var costByGround: Double = 0.00
    
    var tripsByCommercial: Int = 0
    var costByCommercial: Double = 0.00
    
    // MARK: - Initializing
    
    init(month: String) {
        self.month = month
    }
    
}
