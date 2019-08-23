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
    var lastTrip: Trip? {
        return self.trips.last
    }
    var numberOfTripsByMetro: Int {
        return self.getNumberOfTrips(by: .metro)
    }
    var numberOfTripsByGround: Int {
        return self.getNumberOfTrips(by: .ground)
    }
    var numberOfTripsByCommercial: Int {
        return self.getNumberOfTrips(by: .commercial)
    }
    
    var monthStatistics: [Date: [Trip]] {
        var statistics = [Date: [Trip]]()
        for trip in self.trips {
            let month = trip.date.startOfMonth
            if statistics[month] != nil {
                statistics[month]?.append(trip)
            } else {
                statistics[month] = [trip]
            }
        }
        return statistics
    }
    
    var dayStatistics: [Date: [Trip]] {
        var statistics = [Date: [Trip]]()
        for trip in self.trips {
            let day = trip.date.startOfDay
            if statistics[day] != nil {
                statistics[day]?.append(trip)
            } else {
                statistics[day] = [trip]
            }
        }
        return statistics
    }
    
    private func getNumberOfTrips(by transportType: TransportType, at date: Date = Date()) -> Int {
        return self.trips.filter {
            $0.transportType == transportType &&
            $0.date >= date.startOfMonth.startOfDay &&
            $0.date < date.startOfNextMonth.startOfDay }
            .count
    }
}
