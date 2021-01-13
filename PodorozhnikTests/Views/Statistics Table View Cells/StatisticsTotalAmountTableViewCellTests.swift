//
//  StatisticsTotalAmountTableViewCellTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 13/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class StatisticsTotalAmountTableViewCellMock: ShadowedTableViewCell {
    let totalAmountLabel = UILabel()
    var viewModel: StatisticsTotalAmountTableViewCell.ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.totalAmountLabel.text = viewModel.totalAmount
        }
    }
}

class StatisticsTotalAmountTableViewCellTests: XCTestCase {

    func test_StatisticsTotalAmountTableViewCell_ViewModelDidSet_updatesTotalAmountLabelText() {
        let sut = StatisticsTotalAmountTableViewCellMock()
        sut.viewModel = StatisticsTotalAmountTableViewCell.ViewModel(totalAmount: "1000")
        
        let expectedOutput = "1000"
        
        XCTAssertEqual(sut.totalAmountLabel.text, expectedOutput)
    }
    
    func test_StatisticsTotalAmountTableViewCell_ViewModelInitWithTrips_setsViewModelTotalAmount() {
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 1023, date: Date())
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 23, date: Date())
        let trip3 = Trip(transportType: .ground, numberOfTrip: 1, fare: 20, date: Date())
        let trip4 = Trip(transportType: .ground, numberOfTrip: 2, fare: 20, date: Date())
        let trip5 = Trip(transportType: .commercial, numberOfTrip: 1, fare: 40, date: Date())
        let trip6 = Trip(transportType: .commercial, numberOfTrip: 2, fare: 35, date: Date())
        let trips = [trip1, trip2, trip3, trip4, trip5, trip6]
        let sut = StatisticsTotalAmountTableViewCell.ViewModel(trips)
        
        let expectedOutputOptions = ["1\(Locale.current.groupingSeparator ?? " ")161.00",
                                     "1\(Locale.current.groupingSeparator ?? " ")161,00"]
        
        XCTAssertTrue(expectedOutputOptions.contains(sut.totalAmount))
    }

}
