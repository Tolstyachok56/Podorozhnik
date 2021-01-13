//
//  CalculatorCommercialAmountTableViewCellTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 14/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class CalculatorCommercialAmountTableViewCellMock: ShadowedTableViewCell {
    let titleLabel = UILabel()
    let commercialAmountTextField = UITextField()
    
    var viewModel: CalculatorCommercialAmountTableViewCell.ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.titleLabel.text = viewModel.title
            self.commercialAmountTextField.text = viewModel.commercialAmount
        }
    }
}

class CalculatorCommercialAmountTableViewCellTests: XCTestCase {

   func test_CalculatorCommercialAmountTableViewCell_ViewModelDidSet_updatesViews() {
        let sut = CalculatorCommercialAmountTableViewCellMock()
        let title = "Title"
        let commercialAmount = "CommercialAmount"
        sut.viewModel = CalculatorCommercialAmountTableViewCell.ViewModel(title: title, commercialAmount: commercialAmount)
        
        XCTAssertEqual(sut.titleLabel.text, title)
        XCTAssertEqual(sut.commercialAmountTextField.text, commercialAmount)
    }
    
    func test_CalculatorCommercialAmountTableViewCell_ViewModelInitWithCalculator_setsViewModelProperties() {
        let calculator = Calculator()
        calculator.commercialAmount = 400
        let sut = CalculatorCommercialAmountTableViewCell.ViewModel(calculator: calculator)
        
        XCTAssertEqual(sut.title, "Commercial".localized)
        XCTAssertEqual(sut.commercialAmount, "400\(Locale.current.decimalSeparator ?? ".")00")
    }

}
