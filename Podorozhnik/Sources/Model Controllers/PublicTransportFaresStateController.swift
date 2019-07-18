//
//  PublicTransportFaresStateController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

class PublicTransportFaresStateController {
    
    private(set) var publicTransportFares: [PublicTransportFares]
    
    private var fileURL: URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsDirectory?.appendingPathComponent("PublicTransportFares").appendingPathExtension("plist")
    }
    
    init() {
        self.publicTransportFares = []
        guard let fileURL = self.fileURL else { return }
        self.updatePublicTransportFaresFile(at: fileURL)
        
        guard let faresData = try? Data(contentsOf: fileURL),
            let fares = try? PropertyListDecoder().decode([PublicTransportFares].self, from: faresData) else { return }
        self.publicTransportFares = fares
    }
    
    private func updatePublicTransportFaresFile(at fileDocumentsURL: URL) {
        let fileBundleURL = Bundle.main.url(forResource: "PublicTransportFares", withExtension: "plist")
        if !FileManager.default.fileExists(atPath: fileDocumentsURL.path) {
            try? FileManager.default.copyItem(at: fileBundleURL!, to: fileDocumentsURL)
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, version != "1.0" {
            try? FileManager.default.removeItem(at: fileDocumentsURL)
            try? FileManager.default.copyItem(at: fileBundleURL!, to: fileDocumentsURL)
        }
    }
    
    func getMetroFare(numberOfTrip: Int) -> Double {
        return self.getFare(for: .metro, numberOfTrip: numberOfTrip)
    }
    
    func getGroundFare(numberOfTrip: Int) -> Double {
        return self.getFare(for: .ground, numberOfTrip: numberOfTrip)
    }
    
    func getFare(for transportType: TransportType, numberOfTrip: Int) -> Double {
        for fares in self.publicTransportFares {
            if fares.transportType == transportType {
                return fares.getFareValue(forNumberOfTrip: numberOfTrip)
            }
        }
        return 0
    }
    
}

fileprivate extension PublicTransportFares {
    func getFareValue(forNumberOfTrip numberOfTrip: Int) -> Double {
        switch numberOfTrip {
        case 1...10: return self.fareForTripsFrom1To10
        case 11...20: return self.fareForTripsFrom11To20
        case 21...30: return self.fareForTripsFrom21To30
        case 31...40: return self.fareForTripsFrom31To40
        case 41...: return self.fareForTripsFrom41
        default: return self.fareForTripsFrom1To10
        }
    }
}
