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
    private enum CodingKeys: String, CodingKey {
        case code
        case balance
        case trips
    }
}

extension TransportCard {
    var numberOfTripsByMetro: Int {
        return self.getNumberOfTrips(by: .metro)
    }
    var numberOfTripsByGround: Int {
        return self.getNumberOfTrips(by: .ground)
    }
    var numberOfTripsByCommercial: Int {
        return self.getNumberOfTrips(by: .commercial)
    }
    
    private func getNumberOfTrips(by transportType: TransportType, at date: Date = Date()) -> Int {
        return self.trips.filter {
            $0.transportType == transportType &&
            $0.date >= date.startOfMonth.startOfDay &&
            $0.date < date.startOfNextMonth.startOfDay }
            .count
    }
}
