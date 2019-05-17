//
//  OldTransport.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 16.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

enum Transport {
    case metro
    case ground
    case commercial(tariff: Double)
    
    // MARK: - Methods
    func getTariff(numberOfTrip: Int?) -> Double? {
        if let numberOfTrip = numberOfTrip {
            switch self {
            case .metro:
                return Tariff.metro(numberOfTrip: numberOfTrip)
            case .ground:
                return Tariff.ground(numberOfTrip: numberOfTrip)
            case let .commercial(tariff):
                return tariff
            }
        }
        return nil
    }
    
}
