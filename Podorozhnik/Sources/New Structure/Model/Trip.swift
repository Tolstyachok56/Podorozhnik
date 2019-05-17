//
//  Trip.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

struct Trip {
    let transportTypeString: String
    let numberOfTrip: Int?
    let fare: Double
    let month: Date
}

extension Trip {
    var transportType: TransportType {
        if self.transportTypeString == "metro" {
            return TransportType.metro
        } else if self.transportTypeString == "ground"{
            return TransportType.ground
        } else {
            return TransportType.commercial
        }
    }
}

extension Trip: Codable {
    enum CodingKeys: String, CodingKey {
        case transportTypeString = "transportType"
        case numberOfTrip
        case fare
        case month
    }
}
