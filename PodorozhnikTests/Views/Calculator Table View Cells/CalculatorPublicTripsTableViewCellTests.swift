//
//  CalculatorPublicTripsTableViewCellTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 14/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class CalculatorPublicTripsTableViewCellMock: ShadowedTableViewCell {
    let titleLabel = UILabel()
    let metroTripsTextField = UITextField()
    let groundTripsTextField = UITextField()
    
    var viewModel: CalculatorPublicTripsTableViewCell.ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.titleLabel.text = viewModel.title
            self.metroTripsTextField.text = viewModel.tripsByMetro
            self.groundTripsTextField.text = viewModel.tripsByGround
        }
    }
}

class CalculatorPublicTripsTableViewCellTests: XCTestCase {
    
    func test_CalculatorPublicTripsTableViewCell_ViewModelDidSet_updatesViews() {
        let sut = CalculatorPublicTripsTableViewCellMock()
        let title = "Title"
        let metroTrips = "MetroTrips"
        let groundTrips = "GroundTrips"
        sut.viewModel = CalculatorPublicTripsTableViewCell.ViewModel(weekdayType: .weekday, title: title, tripsByMetro: metroTrips, tripsByGround: groundTrips)
        
        XCTAssertEqual(sut.titleLabel.text, title)
        XCTAssertEqual(sut.metroTripsTextField.text, metroTrips)
        XCTAssertEqual(sut.groundTripsTextField.text, groundTrips)
    }
    
    func test_CalculatorPublicTripsTableViewCell_ViewModelInitWithWeekdayAndCalculator_setsViewModelProperties() {
        let calculator = Calculator()
        calculator.tripsByMetroAtWeekday = 2
        calculator.tripsByGroundAtWeekday = 3
        let sut = CalculatorPublicTripsTableViewCell.ViewModel(weekdayType: .weekday, calculator: calculator)
        
        XCTAssertEqual(sut.weekdayType, .weekday)
        XCTAssertEqual(sut.title, "Trips at Weekdays".localized)
        XCTAssertEqual(sut.tripsByMetro, "2")
        XCTAssertEqual(sut.tripsByGround, "3")
    }
    
    func test_CalculatorPublicTripsTableViewCell_ViewModelInitWithRestdayAndCalculator_setsViewModelProperties() {
        let calculator = Calculator()
        calculator.tripsByMetroAtRestday = 2
        calculator.tripsByGroundAtRestday = 3
        let sut = CalculatorPublicTripsTableViewCell.ViewModel(weekdayType: .restday, calculator: calculator)
        
        XCTAssertEqual(sut.weekdayType, .restday)
        XCTAssertEqual(sut.title, "Trips at Restdays".localized)
        XCTAssertEqual(sut.tripsByMetro, "2")
        XCTAssertEqual(sut.tripsByGround, "3")
    }
    
}
