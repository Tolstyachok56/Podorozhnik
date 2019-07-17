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
    
    func setBalance(_ balance: Double, forTransportCard card: inout TransportCard) {
        card.balance = balance
        for (index, transportCard) in self.transportCards.enumerated() {
            if transportCard.code == card.code {
                self.transportCards[index].balance = balance
                self.save()
                break
            }
        }
    }
    
    func addTrip(_ trip: Trip, forTransportCard card: inout TransportCard) {
        if card.balance >= trip.fare {
            card.trips.append(trip)
            card.balance -= trip.fare
            for (index, transportCard) in self.transportCards.enumerated() {
                if transportCard.code == card.code {
                    self.transportCards[index].trips.append(trip)
                    self.transportCards[index].balance -= trip.fare
                    self.save()
                    break
                }
            }
        }
    }
    
    func reduceTrip(by transportType: TransportType, fromTransportCard card: inout TransportCard) {
        func reduceLastTrip(by transportType: TransportType, fromTransportCard card: inout TransportCard) -> Bool {
            guard let index = card.trips.lastIndex(where: { $0.transportType == transportType }) else { return false }
            let tripMonth = card.trips[index].date.monthFormatting
            let currentMonth = Date().monthFormatting
            if tripMonth == currentMonth {
                let fare = card.trips[index].fare
                card.trips.remove(at: index)
                card.balance += fare
                return true
            } else {
                return false
            }
        }
        if reduceLastTrip(by: transportType, fromTransportCard: &card) {
            for (index, transportCard) in self.transportCards.enumerated() {
                if transportCard.code == card.code,
                    reduceLastTrip(by: transportType, fromTransportCard: &self.transportCards[index]) {
                    self.save()
                    break
                }
            }
        }
    }
    
    func getStatistics(for transportCard: TransportCard) -> [String: [Trip]] {
        var statistics = [String: [Trip]]()
        for trip in transportCard.trips {
            let month = trip.date.monthFormatting
            if statistics[month] != nil {
                statistics[month]?.append(trip)
            } else {
                statistics[month] = [trip]
            }
        }
        return statistics
    }
}
