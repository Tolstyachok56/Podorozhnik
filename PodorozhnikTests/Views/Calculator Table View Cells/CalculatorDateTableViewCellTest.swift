//
//  CalculatorDateTableViewCellTest.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 14/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class CalculatorDateTableViewCellMock: ShadowedTableViewCell {
    let titleLabel = UILabel()
    let dateButton = UIButton()
    
    var viewModel: CalculatorDateTableViewCell.ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.titleLabel.text = viewModel.title
            self.dateButton.setTitle(viewModel.dateString, for: .normal)
            switch viewModel.dateType {
            case .start:
                self.addShadow(isFirstRow: true)
            case .end:
                self.addShadow(isLastRow: true)
            }
        }
    }
}

class CalculatorDateTableViewCellTest: XCTestCase {

    func test_CalculatorDateTableViewCell_ViewModelDidSet_updatesViews() {
        let sut = CalculatorDateTableViewCellMock()
        let title = "Title"
        let dateString = "DateString"
        sut.viewModel = CalculatorDateTableViewCell.ViewModel(dateType: .start, title: title, date: Date(), dateString: dateString)
        
        XCTAssertEqual(sut.titleLabel.text, title)
        XCTAssertEqual(sut.dateButton.titleLabel?.text, dateString)
    }
    
    func test_CalculatorDateTableViewCell_ViewModelInitWithStartDateAndCalculator_setsViewModelProperties() {
        let calculator = Calculator()
        let date = Calendar.current.date(from: DateComponents(year: 2050, month: 1, day: 15))!
        calculator.startDate = date
        let sut = CalculatorDateTableViewCell.ViewModel(dateType: .start, calculator: calculator)
        
        XCTAssertEqual(sut.dateType, .start)
        XCTAssertEqual(sut.title, "Start Date".localized)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.dateString, date.mediumFormatting)
    }
    
    func test_CalculatorDateTableViewCell_ViewModelInitWithEndDateAndCalculator_setsViewModelProperties() {
        let calculator = Calculator()
        let date = Calendar.current.date(from: DateComponents(year: 2050, month: 1, day: 15))!
        calculator.endDate = date
        let sut = CalculatorDateTableViewCell.ViewModel(dateType: .end, calculator: calculator)
        
        XCTAssertEqual(sut.dateType, .end)
        XCTAssertEqual(sut.title, "End Date".localized)
        XCTAssertEqual(sut.date, date)
        XCTAssertEqual(sut.dateString, date.mediumFormatting)
    }

}
