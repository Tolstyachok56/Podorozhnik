//
//  StatisticsTableViewCellTests.swift
//  PodorozhnikTests
//
//  Created by Виктория Бадисова on 13/02/2020.
//  Copyright © 2020 Виктория Бадисова. All rights reserved.
//

import XCTest
@testable import Podorozhnik

class StatisticsTableViewCellMock: ShadowedTableViewCell {
    var transportTypeImageView = UIImageView()
    var numberOfTripsLabel = UILabel()
    var averageFareLabel = UILabel()
    var totalAmountLabel = UILabel()
    
    var viewModel: StatisticsTableViewCell.ViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            self.transportTypeImageView.image = viewModel.transportTypeImage
            self.numberOfTripsLabel.text = viewModel.numberOfTrips
            self.averageFareLabel.text = viewModel.averageFare
            self.totalAmountLabel.text = viewModel.totalAmount
            switch viewModel.transportType {
            case .metro:
                self.addShadow(isFirstRow: true)
            default:
                break
            }
        }
    }
}

class StatisticsTableViewCellTests: XCTestCase {

    func test_StatisticsTableViewCell_ViewModelDidSet_updatesLabelsText() {
        let sut = StatisticsTableViewCellMock()
        
        let numberOfTrips = "10"
        let averageFare = "38"
        let totalAmount = "380"
        let image = UIImage()
        sut.viewModel = StatisticsTableViewCell.ViewModel(transportType: .metro, transportTypeImage: image, numberOfTrips: numberOfTrips, averageFare: averageFare, totalAmount: totalAmount)
        
        XCTAssertEqual(sut.transportTypeImageView.image, image)
        XCTAssertEqual(sut.numberOfTripsLabel.text, numberOfTrips)
        XCTAssertEqual(sut.averageFareLabel.text, averageFare)
        XCTAssertEqual(sut.totalAmountLabel.text, totalAmount)
    }

    func test_StatisticsTableViewCell_ViewModelInitWithTrips_setsViewModelProperties() {
        let trip1 = Trip(transportType: .metro, numberOfTrip: 1, fare: 1023, date: Date())
        let trip2 = Trip(transportType: .metro, numberOfTrip: 2, fare: 1023, date: Date())
        let trips = [trip1, trip2]
        let sut = StatisticsTableViewCell.ViewModel(transportType: .metro, trips: trips)
        
        let expectedAverageFareOptions = ["1\(Locale.current.groupingSeparator ?? " ")023.00",
                                          "1\(Locale.current.groupingSeparator ?? " ")023,00"]
        let expectedTotalAmountOptions = ["2\(Locale.current.groupingSeparator ?? " ")046.00",
                                          "2\(Locale.current.groupingSeparator ?? " ")046,00"]
        
        XCTAssertEqual(sut.transportType, .metro)
        //XCTAssertEqual(sut.transportTypeImage, UIImage(named: .metro.imageName)!)????
        XCTAssertEqual(sut.numberOfTrips, "2")
        XCTAssertTrue(expectedAverageFareOptions.contains(sut.averageFare))
        XCTAssertTrue(expectedTotalAmountOptions.contains(sut.totalAmount))
    }

}
