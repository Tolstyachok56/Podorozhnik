//
//  TripsTrackerViewTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 14/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class TripsTrackerViewMock {
    
    let cardBalanceTextField = UITextField()
    let lastTripDateLabel = UILabel()
    
    let cardBalanceViewContainer = UIView()
    let metroViewContainer = UIView()
    let groundViewContainer = UIView()
    let commercialViewContainer = UIView()
    
    let tripsByMetroLabel = UILabel()
    let tripsByGroundLabel = UILabel()
    let tripsByCommercialLabel = UILabel()
    
    let fareOfMetroLabel = UILabel()
    let fareOfGroundLabel = UILabel()
    let fareOfCommercialTextField = UITextField()
    
    let addTripByMetroButton = UIButton()
    let addTripByGroundButton = UIButton()
    let addTripByCommercialButton = UIButton()
    
    let reduceTripByMetroButton = UIButton()
    let reduceTripByGroundButton = UIButton()
    let reduceTripByCommercialButton = UIButton()
    
    var viewModel: TripsTrackerView.ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.cardBalanceTextField.text = viewModel.cardBalance
            self.lastTripDateLabel.text = viewModel.lastTripDate
            
            self.tripsByMetroLabel.text = viewModel.tripsByMetro
            self.tripsByGroundLabel.text = viewModel.tripsByGround
            self.tripsByCommercialLabel.text = viewModel.tripsByCommercial
            
            self.fareOfMetroLabel.text = viewModel.metroFare
            self.fareOfGroundLabel.text = viewModel.groundFare
            self.fareOfCommercialTextField.placeholder = viewModel.commercialFare
        }
    }
}

class TripsTrackerViewTests: XCTestCase {

    func test_TripsTrackerView_ViewModelDidSet_updatesViews() {
        let sut = TripsTrackerViewMock()
        let cardBalance = "1000"
        let lastTripDate = "07.02.2020, 23:30"
        let tripsByMetro = "2"
        let tripsByGround = "3"
        let tripsByCommercial = "4"
        let metroFare = "38"
        let groundFare = "33"
        let commercialFare = "0"
        sut.viewModel = TripsTrackerView.ViewModel(cardBalance: cardBalance,
                                                   lastTripDate: lastTripDate,
                                                   tripsByMetro: tripsByMetro,
                                                   tripsByGround: tripsByGround,
                                                   tripsByCommercial: tripsByCommercial,
                                                   metroFare: metroFare,
                                                   groundFare: groundFare,
                                                   commercialFare: commercialFare)
        XCTAssertEqual(sut.cardBalanceTextField.text, cardBalance)
        XCTAssertEqual(sut.lastTripDateLabel.text, lastTripDate)
        XCTAssertEqual(sut.tripsByMetroLabel.text, tripsByMetro)
        XCTAssertEqual(sut.tripsByGroundLabel.text, tripsByGround)
        XCTAssertEqual(sut.tripsByCommercialLabel.text, tripsByCommercial)
        XCTAssertEqual(sut.fareOfMetroLabel.text, metroFare)
        XCTAssertEqual(sut.fareOfGroundLabel.text, groundFare)
        XCTAssertEqual(sut.fareOfCommercialTextField.placeholder, commercialFare)
    }
    
    func test_TripsTrackerView_ViewModelInitWithTransportCard_setsViewModelProperties() {
        let date = Date()
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 23, date: date)
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 23, date: date)
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 20, date: date)
        let trip4 = Trip(transportType: .ground, numberOfTrip: 2, fare: 20, date: date)
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: date)
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 2, fare: 35, date: date)
        let trips = [trip1, trip2, trip3, trip4, trip5, trip6]
        let transportCard = TransportCard(code: "1234567890", balance: 12345678.90, trips: trips)
        let sut = TripsTrackerView.ViewModel(transportCard)
        
        let cardBalance = "12 345 678\(Locale.current.decimalSeparator ?? ".")90"
        let lastTripDate = "Last: ".localized + date.dayTimeFormatting
        let tripsByMetro = "2"
        let tripsByGround = "2"
        let tripsByCommercial = "2"
        let metroFare = "Fare: ".localized + "41\(Locale.current.decimalSeparator ?? ".")00"
        let groundFare = "Fare: ".localized + "36\(Locale.current.decimalSeparator ?? ".")00"
        let commercialFare = "0\(Locale.current.decimalSeparator ?? ".")00"
        
        XCTAssertEqual(sut.cardBalance, cardBalance)
        XCTAssertEqual(sut.lastTripDate, lastTripDate)
        XCTAssertEqual(sut.tripsByMetro, tripsByMetro)
        XCTAssertEqual(sut.tripsByGround, tripsByGround)
        XCTAssertEqual(sut.tripsByCommercial, tripsByCommercial)
        XCTAssertEqual(sut.metroFare, metroFare)
        XCTAssertEqual(sut.groundFare, groundFare)
        XCTAssertEqual(sut.commercialFare, commercialFare)
    }

}
