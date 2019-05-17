//
//  PublicTransportFaresController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

class PublicTransportFaresControler {
    
    private(set) var publicTransportFares: [PublicTransportFare]
    
    private var fileURL: URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileDocumentsURL = documentsDirectory?.appendingPathComponent("PublicTransportFares").appendingPathExtension("plist")
        
        if !FileManager.default.fileExists(atPath: fileDocumentsURL!.path) {
            let fileBundleURL = Bundle.main.url(forResource: "PublicTransportFares", withExtension: "plist")
            try? FileManager.default.copyItem(at: fileBundleURL!, to: fileDocumentsURL!)
        }
        return fileDocumentsURL
    }
    
    init() {
        self.publicTransportFares = []
        guard let fileURL = self.fileURL,
            let faresData = try? Data(contentsOf: fileURL),
            let fares = try? PropertyListDecoder().decode([PublicTransportFare].self, from: faresData) else {
                self.publicTransportFares = []
                return
        }
        self.publicTransportFares = fares
    }
}
