//
//  TransportCardTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 07/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class TransportCardTests: XCTestCase {

    func test_TransportCard_lastTrip_returnsLastInTripsArray() {
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 23, date: Date())
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 23, date: Date())
        
        let sut = TransportCard(code: "1234567890", balance: 12345678.90, trips: [trip1, trip2])
        
        XCTAssertEqual(sut.lastTrip, trip2)
    }
    
    func test_TransportCard_numberOfTripsByMetro_returns2() {
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 23, date: Date())
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 23, date: Date())
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 20, date: Date())
        let trip4 = Trip(transportType: .ground, numberOfTrip: 2, fare: 20, date: Date())
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: Date())
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 2, fare: 35, date: Date())
        
        let sut = TransportCard(code: "1234567890", balance: 12345678.90, trips: [trip1, trip2, trip3, trip4, trip5, trip6])
        
        XCTAssertEqual(sut.numberOfTripsByMetro, 2)
    }
    
    func test_TransportCard_numberOfTripsByGround_returns2() {
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 23, date: Date())
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 23, date: Date())
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 20, date: Date())
        let trip4 = Trip(transportType: .ground, numberOfTrip: 2, fare: 20, date: Date())
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: Date())
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 2, fare: 35, date: Date())
        
        let sut = TransportCard(code: "1234567890", balance: 12345678.90, trips: [trip1, trip2, trip3, trip4, trip5, trip6])
        
        XCTAssertEqual(sut.numberOfTripsByGround, 2)
    }
    
    func test_TransportCard_numberOfTripsByCommercial_returns2() {
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 23, date: Date())
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 23, date: Date())
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 20, date: Date())
        let trip4 = Trip(transportType: .ground, numberOfTrip: 2, fare: 20, date: Date())
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: Date())
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 2, fare: 35, date: Date())
        
        let sut = TransportCard(code: "1234567890", balance: 12345678.90, trips: [trip1, trip2, trip3, trip4, trip5, trip6])
        
        XCTAssertEqual(sut.numberOfTripsByCommercial, 2)
    }
    
    func test_TransportCard_dayStatistics() {
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 23, date: Date().startOfDay)
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 23, date: Date().startOfDay.add(days: 1))
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 20, date: Date().startOfDay)
        let trip4 = Trip(transportType: .ground, numberOfTrip: 2, fare: 20, date: Date().startOfDay.add(days: 1))
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: Date().startOfDay)
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 2, fare: 35, date: Date().startOfDay.add(days: 1))
        
        let sut = TransportCard(code: "1234567890", balance: 12345678.90, trips: [trip1, trip2, trip3, trip4, trip5, trip6])
        
        let expectedOutput = [Date().startOfDay: [trip1, trip3, trip5],
                              Date().startOfDay.add(days: 1): [trip2, trip4, trip6]]
        
        XCTAssertEqual(sut.dayStatistics, expectedOutput)
    }

    func test_TransportCard_monthStatistics() {
        let date = Date().startOfMonth
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 23, date: date.startOfDay)
        let trip2 = Trip(transportType: .metro, numberOfTrip: 1, fare: 23, date: date.startOfNextMonth)
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 20, date: date.startOfDay.add(days: 1))
        let trip4 = Trip(transportType: .ground, numberOfTrip: 1, fare: 20, date: date.startOfNextMonth.add(days: 1))
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: date.startOfDay.add(days: 2))
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 35, date: date.startOfNextMonth.add(days: 2))
        
        let sut = TransportCard(code: "1234567890", balance: 12345678.90, trips: [trip1, trip2, trip3, trip4, trip5, trip6])
        
        let expectedOutput = [date.startOfMonth: [trip1, trip3, trip5],
                              date.startOfNextMonth: [trip2, trip4, trip6]]
        
        XCTAssertEqual(sut.monthStatistics, expectedOutput)
    }
}
