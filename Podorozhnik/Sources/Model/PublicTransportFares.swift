//
//  PublicTransportFares.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

struct PublicTransportFares {
    let transportType: TransportType
    let fareForTripsFrom1To10: Double
    let fareForTripsFrom11To20: Double
    let fareForTripsFrom21To30: Double
    let fareForTripsFrom31To40: Double
    let fareForTripsFrom41: Double
}

extension PublicTransportFares: Codable {
    private enum CodingKeys: String, CodingKey {
        case transportType
        case fareForTripsFrom1To10
        case fareForTripsFrom11To20
        case fareForTripsFrom21To30
        case fareForTripsFrom31To40
        case fareForTripsFrom41
    }
}
