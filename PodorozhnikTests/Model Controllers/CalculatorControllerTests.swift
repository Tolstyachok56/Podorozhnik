//
//  CalculatorControllerTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 07/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class CalculatorControllerTests: XCTestCase {

    var publicTransportFaresStateController = PublicTransportFaresStateController()
    var calculator: Calculator = Calculator()
    var transportCard = TransportCard(code: "1234567890", balance: 0, trips: [])
    
    override func setUp() {
        calculator.tripsByMetroAtWeekday = 2
        calculator.tripsByMetroAtRestday = 2
        calculator.tripsByGroundAtWeekday = 2
        calculator.tripsByGroundAtRestday = 0
        calculator.commercialAmount = 400
    }
    
    override func tearDown() {
        calculator.startDate = Date().startOfDay
        calculator.endDate = calculator.startDate.endOfMonth
        transportCard.balance = 0
        transportCard.trips = []
    }

    func test_CalculatorController_getTotalAndMissingAmount_cardWithoutTripsInCurrentMonth() {
        calculator.startDate = Calendar.current.date(from: DateComponents(year: 2050, month: 1, day: 1))!
        calculator.endDate = calculator.startDate.endOfMonth
        transportCard.balance = 142
        
        let sut = CalculatorController(calculator: calculator,
                                       transportCard: transportCard,
                                       publicTransportFares: publicTransportFaresStateController)
        let expectedTotalAmount: Double =  4454 // 21 * (2 * 41 + 2 * 36) + 10 * (2 * 41) + 400
        let expectedMissingAmount: Double = expectedTotalAmount - 142 // 4312
        
        XCTAssertEqual(sut.getTotalAmount(), expectedTotalAmount)
        XCTAssertEqual(sut.getMissingAmount(), expectedMissingAmount)
    }
    
    func test_CalculatorController_getTotalAndMissingAmount_cardWithTripsInCurrentMonth() {
        let currentDate = Calendar.current.date(from: DateComponents(year: 2050, month: 1, day: 3))!
        calculator.startDate = Calendar.current.date(from: DateComponents(year: 2050, month: 1, day: 15))!
        calculator.endDate = Calendar.current.date(from: DateComponents(year: 2050, month: 2, day: 15))!
        
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 41, date: currentDate.add(days: -1))
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 41, date: currentDate)
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 36, date: currentDate.add(days: -1))
        let trip4 = Trip(transportType: .ground, numberOfTrip: 2, fare: 36, date: currentDate)
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: currentDate.add(days: -1))
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 2, fare: 35, date: currentDate)
        transportCard.balance = 174
        transportCard.trips = [trip1, trip2, trip3, trip4, trip5, trip6]
        
        let sut = CalculatorController(calculator: calculator,
                                       transportCard: transportCard,
                                       publicTransportFares: publicTransportFaresStateController)
        let expectedTotalAmount: Double = 4608 // 22 * (2 * 41 + 2 * 36) + 10 * (2 * 41) + 400
        let expectedMissingAmount: Double = expectedTotalAmount - 174
        
        XCTAssertEqual(sut.getTotalAmount(at: currentDate), expectedTotalAmount)
        XCTAssertEqual(sut.getMissingAmount(at: currentDate), expectedMissingAmount)
    }
}
