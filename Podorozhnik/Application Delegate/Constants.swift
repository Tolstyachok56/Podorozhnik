//
//  Constants.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 03.08.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//


enum Transport {
    case Metro
}

enum Fare {
    static func metro(numberOfTrip: Int) -> Double {
        switch numberOfTrip {
        case 1...10: return 36.00
        case 11...20: return 35.00
        case 21...30: return 34.00
        case 31...40: return 33.00
        case 41...: return 32.00
        default: return 36.00
        }
    }
}

enum MessageSettings {
    static let recipient: String = "7878"
}

enum DayOfWeek {
    case Weekday
    case Restday
}


