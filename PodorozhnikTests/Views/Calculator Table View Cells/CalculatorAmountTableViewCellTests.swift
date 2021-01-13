//
//  CalculatorAmountTableViewCellTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 14/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class CalculatorAmountTableViewCellMock: ShadowedTableViewCell {
    let totalAmountLabel = UILabel()
    let missingAmountLabel = UILabel()
    
    var viewModel: CalculatorAmountTableViewCell.ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.totalAmountLabel.text = viewModel.totalAmount
            self.missingAmountLabel.text = viewModel.missingAmount
            self.missingAmountLabel.textColor = viewModel.missingAmountColor
        }
    }
}

class CalculatorAmountTableViewCellTests: XCTestCase {

    func test_CalculatorAmountTableViewCell_ViewModelDidSet_updatesViews() {
        let sut = CalculatorAmountTableViewCellMock()
        let totalAmount = "TotalAmount"
        let missingAmount = "MissingAmount"
        let missingAmountColor = UIColor.red
        sut.viewModel = CalculatorAmountTableViewCell.ViewModel(totalAmount: totalAmount, missingAmount: missingAmount, missingAmountColor: missingAmountColor)
        
        XCTAssertEqual(sut.totalAmountLabel.text, totalAmount)
        XCTAssertEqual(sut.missingAmountLabel.text, missingAmount)
        XCTAssertEqual(sut.missingAmountLabel.textColor, missingAmountColor)
    }
    
    func test_CalculatorAmountTableViewCell_ViewModelInitWithCalculatorController_setsViewModelProperties() {
        let calculator = Calculator()
        calculator.tripsByMetroAtWeekday = 2
        calculator.tripsByMetroAtRestday = 2
        calculator.tripsByGroundAtWeekday = 2
        calculator.tripsByGroundAtRestday = 0
        calculator.commercialAmount = 400
        let currentDate = Date()
        calculator.startDate = currentDate
        calculator.endDate = currentDate.endOfMonth
        
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 38, date: currentDate.add(days: -1))
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 38, date: currentDate)
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 33, date: currentDate.add(days: -1))
        let trip4 = Trip(transportType: .ground, numberOfTrip: 2, fare: 33, date: currentDate)
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: currentDate.add(days: -1))
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 2, fare: 35, date: currentDate)
        let trips = [trip1, trip2, trip3, trip4, trip5, trip6]
        let transportCard = TransportCard(code: "1234567890", balance: 174, trips: trips)
        
        let publicTransportFaresStateController = PublicTransportFaresStateController()
        
        let calculatorController = CalculatorController(calculator: calculator, transportCard: transportCard, publicTransportFares: publicTransportFaresStateController)
        
        let totalAmount = calculatorController.getTotalAmount()
        let diff = totalAmount - transportCard.balance
        let missingAmount = diff > 0 ? diff : 0
        let missingAmountColor: UIColor!
        if #available(iOS 13.0, *) {
            missingAmountColor = (missingAmount == 0) ? .label : .red
        } else {
            missingAmountColor = (missingAmount == 0) ? .black : .red
        }
        
        let sut = CalculatorAmountTableViewCell.ViewModel(calculatorController)
        
        XCTAssertEqual(sut.totalAmount, String(totalAmount).rublesGroupedFormatting)
        XCTAssertEqual(sut.missingAmount, String(missingAmount).rublesGroupedFormatting)
        XCTAssertEqual(sut.missingAmountColor, missingAmountColor)
    }

}
