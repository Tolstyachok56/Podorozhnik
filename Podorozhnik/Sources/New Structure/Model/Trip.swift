//
//  Trip.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

struct Trip {
    let transportType: TransportType
    let numberOfTrip: Int?
    let fare: Double
    let date: Date
}

extension Trip: Codable {
    private enum CodingKeys: String, CodingKey {
        case transportType
        case numberOfTrip
        case fare
        case date
    }
}
