//
//  TransportCardsStateController.swift
//  Podorozhnik
//
//  Created by Виктория Бадисова on 17/05/2019.
//  Copyright © 2019 Виктория Бадисова. All rights reserved.
//

import Foundation

class TransportCardsStateController {
    
    private(set) var transportCards: [TransportCard] = []
    
    private var fileURL: URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileDocumentsURL = documentsDirectory?.appendingPathComponent("Cards").appendingPathExtension("plist")
        
        if !FileManager.default.fileExists(atPath: fileDocumentsURL!.path) {
            let fileBundleURL = Bundle.main.url(forResource: "Cards", withExtension: "plist")
            try? FileManager.default.copyItem(at: fileBundleURL!, to: fileDocumentsURL!)
        }
        return fileDocumentsURL
    }
    
    init() {
        self.update()
    }
    
    private func update() {
        self.transportCards = []
        guard let fileURL = self.fileURL,
            let cardsData = try? Data(contentsOf: fileURL),
            let cards = try? PropertyListDecoder().decode([TransportCard].self, from: cardsData) else {
                self.transportCards = []
                return
        }
        self.transportCards = cards
    }
    
    private func save() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        if  let fileURL = self.fileURL,
            let cardsData = try? encoder.encode(self.transportCards) {
            do {
                try cardsData.write(to: fileURL)
            } catch let error {
                print(error)
            }
        }
    }
    
    func addTransportCard(_ card: TransportCard) {
        self.transportCards.append(card)
        self.save()
    }
    
    func getTransportCard(withCode code: String) -> TransportCard? {
        return self.transportCards.first(where: {$0.code == code})
    }
    
    func setBalance(_ balance: Double, forTransportCardWithCode code: String) {
        for (index, transportCard) in self.transportCards.enumerated() {
            if transportCard.code == code {
                self.transportCards[index].balance = balance
                self.save()
                break
            }
        }
    }
    
    func addTrip(_ trip: Trip, forTransportCardWithCode code: String) {
        guard let card = self.getTransportCard(withCode: code),
            card.balance >= trip.fare else { return }
        for (index, transportCard) in self.transportCards.enumerated() {
            if transportCard.code == card.code {
                self.transportCards[index].trips.append(trip)
                self.transportCards[index].balance -= trip.fare
                self.save()
                break
            }
        }
    }
    
    func reduceTrip(by transportType: TransportType, fromTransportCardWithCode code: String) {
        guard let card = self.getTransportCard(withCode: code),
            let lastTripIndex = card.trips.lastIndex(where: { $0.transportType == transportType }) else { return }
        let lastTripMonth = card.trips[lastTripIndex].date.monthFormatting
        let currentMonth = Date().monthFormatting
        
        if lastTripMonth == currentMonth {
            for (index, transportCard) in self.transportCards.enumerated() {
                if transportCard.code == code {
                    let removedTrip = self.transportCards[index].trips.remove(at: lastTripIndex)
                    self.transportCards[index].balance += removedTrip.fare
                    self.save()
                    break
                }
            }
        }
    }
}
