//
//  TransportCard.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

struct TransportCard {
    let code: String
    var balance: Double
    var trips: [Trip]
}

extension TransportCard: Codable {
    enum CodingKeys: String, CodingKey {
        case code
        case balance
        case trips
    }
}
