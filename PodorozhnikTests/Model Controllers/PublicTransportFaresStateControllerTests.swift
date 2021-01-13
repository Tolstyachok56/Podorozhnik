//
//  PublicTransportFaresStateControllerTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 07/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

let fares: [Int : [String : [Double]]] = [2019: ["metro": [36, 35, 34, 33, 32], "ground": [31, 30, 29, 28, 27]],
                                          2020: ["metro": [38, 37, 36, 35, 34], "ground": [33, 32, 31, 30, 29]],
                                          2021: ["metro": [41, 41, 41, 41, 41], "ground": [36, 36, 36, 36, 36]]]

class PublicTransportFaresStateControllerTests: XCTestCase {
    
    var sut = PublicTransportFaresStateController()
    let year = Calendar.current.component(.year, from: Date())
    
    var metroFareFrom1To10: Double { return fares[year]!["metro"]![0] }
    var metroFareFrom11To20: Double { return fares[year]!["metro"]![1] }
    var metroFareFrom21To30: Double { return fares[year]!["metro"]![2] }
    var metroFareFrom31To40: Double { return fares[year]!["metro"]![3] }
    var metroFareFrom41: Double { return fares[year]!["metro"]![4] }
    
    var groundFareFrom1To10: Double { return fares[year]!["ground"]![0] }
    var groundFareFrom11To20: Double { return fares[year]!["ground"]![1] }
    var groundFareFrom21To30: Double { return fares[year]!["ground"]![2] }
    var groundFareFrom31To40: Double { return fares[year]!["ground"]![3] }
    var groundFareFrom41: Double { return fares[year]!["ground"]![4] }

    func test_PublicTransportFaresStateController_getMetroFareFor1_5_10_returnsFareFor1To10() {
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 1), metroFareFrom1To10)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 5), metroFareFrom1To10)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 10), metroFareFrom1To10)
    }
    func test_PublicTransportFaresStateController_getMetroFareFor11_15_20_returnsFareFrom11To20() {
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 11), metroFareFrom11To20)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 15), metroFareFrom11To20)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 20), metroFareFrom11To20)
    }
    func test_PublicTransportFaresStateController_getMetroFareFor21_25_30_returnsFareFrom21To30() {
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 21), metroFareFrom21To30)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 25), metroFareFrom21To30)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 30), metroFareFrom21To30)
    }
    func test_PublicTransportFaresStateController_getMetroFareFor31_35_40_returnsFareFrom31To40() {
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 31), metroFareFrom31To40)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 35), metroFareFrom31To40)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 40), metroFareFrom31To40)
    }
    func test_PublicTransportFaresStateController_getMetroFareFor41_45_returnsFareFrom41() {
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 41), metroFareFrom41)
        XCTAssertEqual(sut.getMetroFare(numberOfTrip: 45), metroFareFrom41)
    }
    
    func test_PublicTransportFaresStateController_getGroundFareFor1_5_10_returnsFareFor1To10() {
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 1), groundFareFrom1To10)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 5), groundFareFrom1To10)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 10), groundFareFrom1To10)
    }
    func test_PublicTransportFaresStateController_getGroundFareFor11_15_20_returnsFareFrom11To20() {
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 11), groundFareFrom11To20)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 15), groundFareFrom11To20)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 20), groundFareFrom11To20)
    }
    func test_PublicTransportFaresStateController_getGroundFareFor21_25_30_returnsFareFrom21To30() {
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 21), groundFareFrom21To30)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 25), groundFareFrom21To30)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 30), groundFareFrom21To30)
    }
    func test_PublicTransportFaresStateController_getGroundFareFor31_35_40_returnsFareFrom31To40() {
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 31), groundFareFrom31To40)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 35), groundFareFrom31To40)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 40), groundFareFrom31To40)
    }
    func test_PublicTransportFaresStateController_getGroundFareFor41_45_returnsFareFrom41() {
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 41), groundFareFrom41)
        XCTAssertEqual(sut.getGroundFare(numberOfTrip: 45), groundFareFrom41)
    }
}
