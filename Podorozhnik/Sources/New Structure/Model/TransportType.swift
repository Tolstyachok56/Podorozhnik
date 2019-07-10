//
//  TransportType.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

enum TransportType: String, Equatable {
    case metro
    case ground
    case commercial
}

extension TransportType: Codable {
    private enum CodingKeys: String, CodingKey {
        case rawValue
    }
    private enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        switch rawValue {
        case TransportType.metro.rawValue:
            self = .metro
        case TransportType.ground.rawValue:
            self = .ground
        case TransportType.commercial.rawValue:
            self = .commercial
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawValue, forKey: .rawValue)
    }
}

extension TransportType {
    var tag: Int {
        switch self {
        case .metro:
            return 0
        case .ground:
            return 1
        case .commercial:
            return 2
        }
    }
}
